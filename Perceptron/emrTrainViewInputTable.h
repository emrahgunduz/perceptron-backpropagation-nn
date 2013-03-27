//
//  emrTrainViewInputTable.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol emrTrainViewInputTableDelegate <NSObject>
- (void)selectionChange:(long)row;
@end

@interface emrTrainViewInputTable : NSTableView <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) id <emrTrainViewInputTableDelegate> tableDelegate;
@property (assign) long tableSelectedRow;
@property (strong) NSMutableArray *tableData;

- (void)tableForceChangeSelectedRow:(long)row;
- (void)tableChangeColumnCount:(long)column;
@end
