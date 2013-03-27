//
//  emrAppDelegate.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrAppDelegate.h"
#import "emrTests.h"

@implementation emrAppDelegate

@synthesize mainView;

@synthesize networkSetupPanel, networkLayersTable;

@synthesize trainingPanel, trainViewRunning, trainViewTraining, trainViewTableForInput, trainViewTableForOutput;
@synthesize textEpoch, textError, inputEpoch, inputMomentum, inputTrainingRate;
@synthesize trainViewTableRunInput, trainViewTableRunOutput;

@synthesize runningPanel, runningInputTable, runningOutputTable;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
  return YES;
}

- (void)openNetwork:(id)sender
{
  NSOpenPanel *open = [NSOpenPanel openPanel];
  [open setAllowedFileTypes:[NSArray arrayWithObject:@"network"]];
  [open setAllowsOtherFileTypes:NO];

  long int result = [open runModal];
  if (result == NSOKButton) {
    // Load network data
    NSString *file = [[open URL] path];
    // Reset network
    [network destroy];
    // Load file
    [network loadTrainingData:file];
  }
}

- (void)saveNetwork:(id)sender
{
  NSSavePanel *save = [NSSavePanel savePanel];
  [save setAllowedFileTypes:[NSArray arrayWithObject:@"network"]];
  [save setAllowsOtherFileTypes:NO];

  long int result = [save runModal];
  if(result == NSOKButton) {
    // Save network data
    NSString *file = [[save URL] path];
    [network saveTrainingData:file];
  }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.window.delegate = self;
  
  networkView = [[emrView alloc] initWithFrame:mainView.frame];
  [mainView addSubview:networkView];
  
  networkLayersTable.delegate   = self;
  networkLayersTable.dataSource = self;
  
  trainViewTableForInput.tableDelegate  = self;
  trainViewTableForOutput.tableDelegate = self;
  trainViewTableForInput.tableData      = [NSMutableArray array];
  trainViewTableForOutput.tableData     = [NSMutableArray array];
  
  trainViewTableForInput.delegate    = trainViewTableForInput;
  trainViewTableForOutput.delegate   = trainViewTableForOutput;
  trainViewTableForInput.dataSource  = trainViewTableForInput;
  trainViewTableForOutput.dataSource = trainViewTableForOutput;
  
  trainViewTableRunInput.tableDelegate  = self;
  trainViewTableRunOutput.tableDelegate = self;
  trainViewTableRunInput.tableData      = [NSMutableArray array];
  trainViewTableRunOutput.tableData     = [NSMutableArray array];
  
  trainViewTableRunInput.delegate    = trainViewTableRunInput;
  trainViewTableRunOutput.delegate   = trainViewTableRunOutput;
  trainViewTableRunInput.dataSource  = trainViewTableRunInput;
  trainViewTableRunOutput.dataSource = trainViewTableRunOutput;
  
  runningInputTable.tableDelegate  = self;
  runningOutputTable.tableDelegate = self;
  runningInputTable.tableData      = [NSMutableArray array];
  runningOutputTable.tableData     = [NSMutableArray array];
  
  runningInputTable.delegate       = runningInputTable;
  runningOutputTable.delegate      = runningOutputTable;
  runningInputTable.dataSource     = runningInputTable;
  runningOutputTable.dataSource    = runningOutputTable;
  
  isInTraining = NO;
  
  network = [emrNetwork new];
  [network createInputLayerWithNodeCount:2 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:2];
  [network createOutputLayerWithNodeCount:2];
  [network setRenderView:networkView];
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
  [networkView setFrame:NSMakeRect(0, 0, frameSize.width, frameSize.height)];
  return frameSize;
}

- (void)windowDidResize:(NSNotification *)notification
{
  [networkView setFrame:NSMakeRect(0, 0, self.window.frame.size.width, self.window.frame.size.height - 20)];
}

- (void)awakeFromNib
{
  [networkLayersTable reloadData];
}

- (IBAction)networkSetupButton:(id)sender
{
  [networkSetupPanel makeKeyAndOrderFront:self];
  [networkLayersTable reloadData];
}

- (IBAction)trainDataButton:(id)sender
{
  [trainingPanel makeKeyAndOrderFront:self];
  if(!isInTraining) {
    [trainingPanel setContentView:trainViewTraining];
  } else {
    [trainingPanel setContentView:trainViewRunning];
  }
}

- (IBAction)runDataButton:(id)sender
{
  [runningPanel makeKeyAndOrderFront:self];
}





//
//
// NETWORK SETUP PANEL
//
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  return network.layers.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  NSArray *layer = [network.layers objectAtIndex:row];
  if(row == 0) {
    if ([[tableColumn identifier] isEqualToString:@"ColumnA"]) {
      return @"Input";
    } else {
      return [NSNumber numberWithLong:layer.count];
    }    
  } else if (row == network.layers.count-1) {
    if ([[tableColumn identifier] isEqualToString:@"ColumnA"]) {
      return @"Output";
    } else {
      return [NSNumber numberWithLong:layer.count];
    }
  } else {
    if ([[tableColumn identifier] isEqualToString:@"ColumnA"]) {
      return @"Hidden";
    } else {
      return [NSNumber numberWithLong:layer.count];
    }
  }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  // Get current layer values
  NSMutableArray *layerCounts = [NSMutableArray array];
  for (int i = 0; i < network.layers.count; i++) {
    NSArray *layer = [network.layers objectAtIndex:i];
    [layerCounts addObject:[NSNumber numberWithLong:layer.count]];
  }
  
  // Rebuild network
  [network destroy];
  
  if(row == 0) {
    // Input
    [network createInputLayerWithNodeCount:[object intValue] withConnectionCount:[[layerCounts objectAtIndex:1] intValue]];
    for (int i = 1; i < layerCounts.count-1; i++) {
      [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[[layerCounts objectAtIndex:i+1] intValue]];
    }
    [network createOutputLayerWithNodeCount:[[layerCounts lastObject] intValue]];
  } else if (row == layerCounts.count-1) {
    // Output
    [network createInputLayerWithNodeCount:[[layerCounts objectAtIndex:0] intValue] withConnectionCount:[[layerCounts objectAtIndex:1] intValue]];
    for (int i = 1; i < layerCounts.count-1; i++) {
      if(i == layerCounts.count-2) {
        [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[object intValue]];
      } else {
        [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[[layerCounts objectAtIndex:i+1] intValue]];
      }
    }
    [network createOutputLayerWithNodeCount:[object intValue]];
  } else {
    if(row == 1) {
      [network createInputLayerWithNodeCount:[[layerCounts objectAtIndex:0] intValue] withConnectionCount:[object intValue]];
    } else {
      [network createInputLayerWithNodeCount:[[layerCounts objectAtIndex:0] intValue] withConnectionCount:[[layerCounts objectAtIndex:1] intValue]];
    }
    for (int i = 1; i < layerCounts.count-1; i++) {
      if(i == row-1) {
        [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[object intValue]];
      } else if(i == row) {
        [network createHiddenLayerWithNodeCount:[object intValue] withConnectionCount:[[layerCounts objectAtIndex:i+1] intValue]];
      } else {
        [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[[layerCounts objectAtIndex:i+1] intValue]];
      }
    }
    [network createOutputLayerWithNodeCount:[[layerCounts lastObject] intValue]];
  }
  
  [network updateView];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
  selectedRow = (long)networkLayersTable.selectedRow;
}

- (IBAction)addNewLayer:(id)sender
{
  // Get current layer values
  NSMutableArray *layerCounts = [NSMutableArray array];
  for (int i = 0; i < network.layers.count; i++) {
    NSArray *layer = [network.layers objectAtIndex:i];
    [layerCounts addObject:[NSNumber numberWithLong:layer.count]];
  }
  
  // Rebuild network
  [network destroy];  
  // Input
  [network createInputLayerWithNodeCount:[[layerCounts objectAtIndex:0] intValue] withConnectionCount:[[layerCounts objectAtIndex:1] intValue]];
  // Hidden
  for (int i = 1; i < layerCounts.count-1; i++) {
    if (i == layerCounts.count-2) {
      [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:3];
    } else {
      [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[[layerCounts objectAtIndex:i+1] intValue]];
    }
  }
  // Create the new layer
  [network createHiddenLayerWithNodeCount:3 withConnectionCount:[[layerCounts lastObject] intValue]];
  // Output
  [network createOutputLayerWithNodeCount:[[layerCounts lastObject] intValue]];
  
  [network updateView];
  [networkLayersTable reloadData];
}

- (IBAction)removeSelectedLayer:(id)sender
{
  // Get current layer values
  NSMutableArray *layerCounts = [NSMutableArray array];
  for (int i = 0; i < network.layers.count; i++) {
    NSArray *layer = [network.layers objectAtIndex:i];
    [layerCounts addObject:[NSNumber numberWithLong:layer.count]];
  }
  
  if(selectedRow == 0) {
    // Cannot delete input
    NSAlert *alert = [NSAlert alertWithMessageText:@"Input Layer"
                                     defaultButton:@"Cancel"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Input layer cannot be deleted."];
    [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    return;
  }
  
  if(selectedRow == layerCounts.count - 1) {
    // Cannot delete output
    NSAlert *alert = [NSAlert alertWithMessageText:@"Output Layer"
                                     defaultButton:@"Cancel"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Output layer cannot be deleted."];
    [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    return;
  }
  
  if(layerCounts.count == 3) {
    // Cannot delete output
    NSAlert *alert = [NSAlert alertWithMessageText:@"Hidden Layer"
                                     defaultButton:@"Cancel"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Last hidden layer cannot be deleted."];
    [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    return;
  }
  
  // Rebuild network
  [network destroy];
  // Input
  if(selectedRow == 0) {
    [network createInputLayerWithNodeCount:[[layerCounts objectAtIndex:0] intValue] withConnectionCount:[[layerCounts objectAtIndex:2] intValue]];
  } else {
    [network createInputLayerWithNodeCount:[[layerCounts objectAtIndex:0] intValue] withConnectionCount:[[layerCounts objectAtIndex:1] intValue]];
  }
  
  // Hidden
  for (int i = 1; i < layerCounts.count-1; i++) {
    if (i != selectedRow) {
      if(i+1 == selectedRow) {
        [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[[layerCounts objectAtIndex:i+2] intValue]];
      } else {
        [network createHiddenLayerWithNodeCount:[[layerCounts objectAtIndex:i] intValue] withConnectionCount:[[layerCounts objectAtIndex:i+1] intValue]];
      }
    }
  }
  
  [network createOutputLayerWithNodeCount:[[layerCounts lastObject] intValue]];
  
  [network updateView];
  [networkLayersTable reloadData];
}

- (IBAction)changeTransferFunc:(id)sender
{
  NSComboBox *cb = (NSComboBox*)sender;
  long selected = cb.indexOfSelectedItem;
  switch (selected) {
    case 0:
    {
      network.systemTransferFunction = transferFunctionSigmoid;
    }
      break;
    case 1:
    {
      network.systemTransferFunction = transferFunctionLinear;
    }
      break;
    case 2:
    {
      network.systemTransferFunction = transferFunctionGaussian;
    }
      break;
    case 3:
    {
      network.systemTransferFunction = transferFunctionRational;
    }
      break;
    default:
    {
      network.systemTransferFunction = transferFunctionSigmoid;
    }
      break;
  }
}







//
//
// TRAIN PANEL
//
- (IBAction)trainViewStartTraining:(id)sender
{
  [network clearErrorArray];
  
  NSArray *inputLayer  = [network.layers objectAtIndex:0];
  NSArray *outputLayer = [network.layers lastObject];
  [trainViewTableRunInput tableChangeColumnCount:inputLayer.count];
  [trainViewTableRunOutput tableChangeColumnCount:outputLayer.count];
  
  input = [trainViewTableForInput.tableData copy];
  output = [trainViewTableForOutput.tableData copy];
  
  trainViewTableRunInput.tableData = [input mutableCopy];
  [trainViewTableRunInput reloadData];
  
  isInTraining = YES;
  [trainingPanel setContentView:trainViewRunning];
  
  int epoch = [inputEpoch.stringValue intValue];
  double trainingRate = [inputTrainingRate.stringValue doubleValue];
  double momentum = [inputMomentum.stringValue doubleValue];
  
  dispatch_queue_t run = dispatch_queue_create("NNRun", NULL);
  dispatch_async(run, ^{
    // Train
    BOOL equal = NO;
    double error = 0.0f;
    int autoDraw = abs(50000/input.count);
    int i = 0;
    
    do {
      error = 0.0f;
      
      for (int j = 0; j < input.count; j++) {
        error += [network trainWithInput:[input objectAtIndex:j] desired:[output objectAtIndex:j] trainingRate:trainingRate momentum:momentum];
      }
      
      if(i % autoDraw == 0) {
        [textEpoch setStringValue:[NSString stringWithFormat:@"%i",i]];
        [textError setStringValue:[NSString stringWithFormat:@"%f",error]];
        
        NSMutableArray *result = [NSMutableArray array];
        for (int j = 0; j < input.count; j++) {
          NSMutableArray *o = [[network runWithInput:[input objectAtIndex:j]] mutableCopy];
          for (int k = 0; k < o.count; k++) {
            double a = [[o objectAtIndex:k] doubleValue];
            [o replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", a]];
          }
          [result addObject:o];
        }
        trainViewTableRunInput.tableData = [input mutableCopy];
        trainViewTableRunOutput.tableData = result;
        [trainViewTableRunOutput reloadData];
      }
      
      if(i == epoch || !isInTraining || [emrNetwork fuzzyEqual:error and:0.00f difference:0.0000001]){
        equal = YES;
        [textEpoch setStringValue:[NSString stringWithFormat:@"Finished: %i",i]];
        [textError setStringValue:[NSString stringWithFormat:@"%f",error]];
        NSMutableArray *result = [NSMutableArray array];
        for (int j = 0; j < input.count; j++) {
          NSMutableArray *o = [[network runWithInput:[input objectAtIndex:j]] mutableCopy];
          for (int k = 0; k < o.count; k++) {
            double a = [[o objectAtIndex:k] doubleValue];
            [o replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", a]];
          }
          [result addObject:o];
        }
        trainViewTableRunInput.tableData = [input mutableCopy];
        trainViewTableRunOutput.tableData = result;
        [trainViewTableRunInput reloadData];
        [trainViewTableRunOutput reloadData];
        [network updateView];
        isInTraining = NO;
      }
      
      i++;
      
      dispatch_async(dispatch_get_main_queue(), ^{
        if(i % autoDraw == 0)
          [network updateView];
      });
      
    } while (!equal);
  });
}

- (IBAction)trainViewClearData:(id)sender
{
  trainViewTableForInput.tableData  = [NSMutableArray array];
  trainViewTableForOutput.tableData = [NSMutableArray array];
  
  NSArray *inputLayer  = [network.layers objectAtIndex:0];
  NSArray *outputLayer = [network.layers lastObject];
  
  NSMutableArray *data = [NSMutableArray array];
  for (int i = 0; i < inputLayer.count; i++) {
    [data addObject:@0.0f];
  }
  [trainViewTableForInput.tableData addObject:[data mutableCopy]];
  
  data = [NSMutableArray array];
  for (int i = 0; i < outputLayer.count; i++) {
    [data addObject:@0.0f];
  }
  [trainViewTableForOutput.tableData addObject:[data mutableCopy]];
  
  [trainViewTableForInput tableChangeColumnCount:inputLayer.count];
  [trainViewTableForOutput tableChangeColumnCount:outputLayer.count];
  
  [trainViewTableForInput reloadData];
  [trainViewTableForOutput reloadData];
}

- (void)selectionChange:(long)row
{
  selectedRow = row;
  [trainViewTableForInput tableForceChangeSelectedRow:row];
  [trainViewTableForOutput tableForceChangeSelectedRow:row];
}

- (void)testRunSelectionChange:(long)row
{
  [trainViewTableRunInput tableForceChangeSelectedRow:row];
  [trainViewTableRunOutput tableForceChangeSelectedRow:row];
}

- (IBAction)trainViewAddRow:(id)sender
{
  NSArray *inputLayer  = [network.layers objectAtIndex:0];
  NSArray *outputLayer = [network.layers lastObject];
  
  NSMutableArray *data = [NSMutableArray array];
  for (int i = 0; i < inputLayer.count; i++) {
    [data addObject:@0.0f];
  }
  [trainViewTableForInput.tableData addObject:[data mutableCopy]];
  
  data = [NSMutableArray array];
  for (int i = 0; i < outputLayer.count; i++) {
    [data addObject:@0.0f];
  }
  [trainViewTableForOutput.tableData addObject:[data mutableCopy]];
  
  [trainViewTableForInput reloadData];
  [trainViewTableForOutput reloadData];
}

- (IBAction)trainViewRemoveRow:(id)sender
{
  if(trainViewTableForInput.tableData.count) {
    [trainViewTableForInput.tableData removeObjectAtIndex:selectedRow];
    [trainViewTableForOutput.tableData removeObjectAtIndex:selectedRow];
  }
  
  NSArray *inputLayer  = [network.layers objectAtIndex:0];
  NSArray *outputLayer = [network.layers lastObject];
  
  [trainViewTableForInput tableChangeColumnCount:inputLayer.count];
  [trainViewTableForOutput tableChangeColumnCount:outputLayer.count];
  
  [trainViewTableForInput reloadData];
  [trainViewTableForOutput reloadData];
}

- (IBAction)trainViewStopTraining:(id)sender
{
  isInTraining = NO;
  [trainingPanel setContentView:trainViewTraining];
}

- (IBAction)saveTrainingData:(id)sender
{
  NSSavePanel *saveData = [NSSavePanel savePanel];
  [saveData setAllowedFileTypes:[NSArray arrayWithObject:@"csv"]];
  [saveData setAllowsOtherFileTypes:NO];
  
  long int result = [saveData runModal];
  if(result == NSOKButton) {
    NSArray *inputData = trainViewTableForInput.tableData;
    NSArray *outputData = trainViewTableForOutput.tableData;
    
    NSMutableString *str = [@"" mutableCopy];
    for (NSArray *row in inputData) {
      for (NSNumber *col in row) {
        [str appendString:[NSString stringWithFormat:@"%f,", [col doubleValue]]];
      }
      [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];      
      [str appendString:@"\n"];
    }
    [str appendString:@"OUTPUT:\n"];
    
    for (NSArray *row in outputData) {
      for (NSNumber *col in row) {
        [str appendString:[NSString stringWithFormat:@"%f,", [col doubleValue]]];
      }
      [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];      
      [str appendString:@"\n"];
    }
    [str writeToFile:[[saveData URL] path] atomically:YES encoding:NSUTF8StringEncoding error:nil];
  }
}

- (IBAction)loadTrainingData:(id)sender
{
  NSOpenPanel *open = [NSOpenPanel openPanel];
  [open setAllowedFileTypes:[NSArray arrayWithObject:@"csv"]];
  [open setAllowsOtherFileTypes:NO];
  
  long int result = [open runModal];
  if (result == NSOKButton) {
    NSString *str = [NSString stringWithContentsOfFile:[[open URL] path] encoding:NSUTF8StringEncoding error:nil];
    NSArray *content = [str componentsSeparatedByString:@"\n"];
    
    NSMutableArray *inputData = [NSMutableArray array];
    NSMutableArray *outputData = [NSMutableArray array];
    
    BOOL isOutput = NO;
    for (NSString *line in content) {
      if(!line.length) {
        continue;
      }
      
      if(!isOutput && [line rangeOfString:@"OUTPUT"].location != NSNotFound) {
        isOutput = YES;
        continue;
      }
      
      NSMutableArray *column = [NSMutableArray array];
      NSArray *nodeValues = [line componentsSeparatedByString:@","];
      for (NSNumber *value in nodeValues) {
        [column addObject:[NSNumber numberWithDouble:[value doubleValue]]];
      }
      
      if(!isOutput) {
        [inputData addObject:column];
      } else {
        [outputData addObject:column];
      }
    }
    
    trainViewTableForInput.tableData = [inputData mutableCopy];
    trainViewTableForOutput.tableData = [outputData mutableCopy];
    
    [trainViewTableForInput reloadData];
    [trainViewTableForOutput reloadData];
  }
}







//
//
// RUNNING PANEL
//
- (IBAction)runAddRow:(id)sender
{
  NSArray *inputLayer  = [network.layers objectAtIndex:0];
  NSArray *outputLayer = [network.layers lastObject];
  
  NSMutableArray *data = [NSMutableArray array];
  for (int i = 0; i < inputLayer.count; i++) {
    [data addObject:@0.0f];
  }
  [runningInputTable.tableData addObject:[data mutableCopy]];
  
  data = [NSMutableArray array];
  for (int i = 0; i < outputLayer.count; i++) {
    [data addObject:@0.0f];
  }
  [runningOutputTable.tableData addObject:[data mutableCopy]];
  
  [runningInputTable reloadData];
  [runningOutputTable reloadData];
}

- (IBAction)runRemoveRow:(id)sender
{
  if(runningInputTable.tableData.count) {
    [runningInputTable.tableData removeObjectAtIndex:selectedRow];
    [runningOutputTable.tableData removeObjectAtIndex:selectedRow];
  }
  [runningInputTable reloadData];
  [runningOutputTable reloadData];
}

- (void)runSelectionChange:(long)row
{
  [runningInputTable tableForceChangeSelectedRow:row];
  [runningOutputTable tableForceChangeSelectedRow:row];
}

- (IBAction)runResetData:(id)sender
{
  runningInputTable.tableData  = [NSMutableArray array];
  runningOutputTable.tableData = [NSMutableArray array];
  
  NSArray *inputLayer  = [network.layers objectAtIndex:0];
  NSArray *outputLayer = [network.layers lastObject];
  [runningInputTable tableChangeColumnCount:inputLayer.count];
  [runningOutputTable tableChangeColumnCount:outputLayer.count];
  
  [runningInputTable reloadData];
  [runningOutputTable reloadData];
}

- (IBAction)runData:(id)sender
{
  input = [runningInputTable.tableData copy];
  
  NSMutableArray *result = [NSMutableArray array];
  for (int j = 0; j < input.count; j++) {
    NSMutableArray *o = [[network runWithInput:[input objectAtIndex:j]] mutableCopy];
    for (int k = 0; k < o.count; k++) {
      double a = [[o objectAtIndex:k] doubleValue];
      [o replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", a]];
    }
    [result addObject:o];
  }
  runningOutputTable.tableData = result;
  [runningInputTable reloadData];
  [runningOutputTable reloadData];
}








@end
