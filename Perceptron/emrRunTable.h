//
//  emrRunTable.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol emrRunTableDelegate <NSObject>
- (void)runSelectionChange:(long)row;
@end

@interface emrRunTable : NSTableView <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) id <emrRunTableDelegate> tableDelegate;
@property (assign) long tableSelectedRow;
@property (strong) NSMutableArray *tableData;

- (void)tableForceChangeSelectedRow:(long)row;
- (void)tableChangeColumnCount:(long)column;
@end
