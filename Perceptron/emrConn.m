//
//  emrConn.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrConn.h"

@implementation emrConn

@synthesize weight, weightDelta, prevWeightDelta;

- (id)init
{
  self = [super init];
  
  weight          = ((double)arc4random() / ARC4RANDOM_MAX);
  weightDelta     = ((double)arc4random() / ARC4RANDOM_MAX);
  prevWeightDelta = ((double)arc4random() / ARC4RANDOM_MAX);
  
  return self;
}

@end
