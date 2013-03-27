//
//  emrConn.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface emrConn : NSObject

@property (assign) double weight;
@property (assign) double weightDelta;
@property (assign) double prevWeightDelta;

- (id)init;

@end
