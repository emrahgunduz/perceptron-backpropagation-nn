//
//  emrAppDelegate.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "emrTrainViewInputTable.h"
#import "emrTrainViewRunTable.h"
#import "emrRunTable.h"

@interface emrAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate, emrTrainViewInputTableDelegate, emrTrainViewRunTableDelegate, emrRunTableDelegate>
{
  emrView *networkView;  
  emrNetwork *network;
  long selectedRow;
  
  BOOL isInTraining;
  
  NSArray *input;
  NSArray *output;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *mainView;

- (IBAction)openNetwork:(id)sender;
- (IBAction)saveNetwork:(id)sender;
- (IBAction)networkSetupButton:(id)sender;
- (IBAction)trainDataButton:(id)sender;
- (IBAction)runDataButton:(id)sender;

@property (unsafe_unretained) IBOutlet NSPanel *networkSetupPanel;
@property (weak) IBOutlet NSTableView *networkLayersTable;
- (IBAction)addNewLayer:(id)sender;
- (IBAction)removeSelectedLayer:(id)sender;
- (IBAction)changeTransferFunc:(id)sender;

@property (unsafe_unretained) IBOutlet NSPanel *trainingPanel;
@property (weak) IBOutlet NSView *trainViewTraining;
@property (weak) IBOutlet NSView *trainViewRunning;
@property (weak) IBOutlet emrTrainViewInputTable *trainViewTableForInput;
@property (weak) IBOutlet emrTrainViewInputTable *trainViewTableForOutput;
@property (weak) IBOutlet emrTrainViewRunTable *trainViewTableRunInput;
@property (weak) IBOutlet emrTrainViewRunTable *trainViewTableRunOutput;
@property (weak) IBOutlet NSTextField *textEpoch;
@property (weak) IBOutlet NSTextField *textError;
@property (weak) IBOutlet NSTextField *inputEpoch;
@property (weak) IBOutlet NSTextField *inputTrainingRate;
@property (weak) IBOutlet NSTextField *inputMomentum;
- (IBAction)trainViewStartTraining:(id)sender;
- (IBAction)trainViewClearData:(id)sender;
- (IBAction)trainViewAddRow:(id)sender;
- (IBAction)trainViewRemoveRow:(id)sender;
- (IBAction)trainViewStopTraining:(id)sender;
- (IBAction)saveTrainingData:(id)sender;
- (IBAction)loadTrainingData:(id)sender;


@property (unsafe_unretained) IBOutlet NSPanel *runningPanel;
@property (weak) IBOutlet emrRunTable *runningInputTable;
@property (weak) IBOutlet emrRunTable *runningOutputTable;
- (IBAction)runAddRow:(id)sender;
- (IBAction)runRemoveRow:(id)sender;
- (IBAction)runData:(id)sender;
- (IBAction)runResetData:(id)sender;

@end
