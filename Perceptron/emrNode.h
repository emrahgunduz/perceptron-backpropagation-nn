//
//  emrNode.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface emrNode : NSObject

@property (strong) NSMutableArray *connections;
@property (assign) double input;
@property (assign) double output;
@property (assign) double delta;
@property (assign) double bias;
@property (assign) double biasDelta;
@property (assign) double prevBiasDelta;

- (id)init;
- (void)createConnections:(int)count;

@end
