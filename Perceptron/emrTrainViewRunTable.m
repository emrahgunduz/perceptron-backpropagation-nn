//
//  emrTrainViewRunTable.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrTrainViewRunTable.h"

@implementation emrTrainViewRunTable

@synthesize tableData, tableDelegate, tableSelectedRow;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  return tableData.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  int ident = [[tableColumn identifier] intValue];
  NSArray *data = [tableData objectAtIndex:row];
  return [data objectAtIndex:ident];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  int ident = [[tableColumn identifier] intValue];
  NSMutableArray *data = [tableData objectAtIndex:row];
  [data replaceObjectAtIndex:ident withObject:[NSNumber numberWithDouble:[object doubleValue]]];
  [tableData replaceObjectAtIndex:row withObject:data];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
  tableSelectedRow = (long)self.selectedRow;
  if(tableDelegate && [tableDelegate respondsToSelector:@selector(testRunSelectionChange:)])
    [tableDelegate testRunSelectionChange:tableSelectedRow];
}

- (void)tableForceChangeSelectedRow:(long)row
{
  [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}

- (void)tableChangeColumnCount:(long)column
{
  while([[self tableColumns] count] > 0) {
    [self removeTableColumn:[[self tableColumns] lastObject]];
  }
  for (int i = 0; i < column; i++) {
    NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%i",i]];
    [col setEditable:YES];
    [col setMinWidth:40.0f];
    [col setWidth:40.0f];
    [col setResizingMask:NSTableColumnUserResizingMask];
    [[col headerCell] setStringValue:@"Node"];
    [self addTableColumn:col];
  }
}

@end
