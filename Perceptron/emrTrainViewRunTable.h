//
//  emrTrainViewRunTable.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol emrTrainViewRunTableDelegate <NSObject>
- (void)testRunSelectionChange:(long)row;
@end

@interface emrTrainViewRunTable : NSTableView <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) id <emrTrainViewRunTableDelegate> tableDelegate;
@property (assign) long tableSelectedRow;
@property (strong) NSMutableArray *tableData;

- (void)tableForceChangeSelectedRow:(long)row;
- (void)tableChangeColumnCount:(long)column;
@end
