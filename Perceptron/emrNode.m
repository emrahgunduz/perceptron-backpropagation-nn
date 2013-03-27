//
//  emrNode.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrNode.h"

@implementation emrNode

@synthesize connections, input, output, delta, bias, biasDelta, prevBiasDelta;

- (id)init
{
  self = [super init];
  
  connections   = [NSMutableArray array];
  input         = 0.0f;
  output        = 0.0f;
  delta         = ((double)arc4random() / ARC4RANDOM_MAX);
  bias          = ((double)arc4random() / ARC4RANDOM_MAX);
  biasDelta     = 0.0f;
  prevBiasDelta = 0.0f;
  return self;
}

- (void)createConnections:(int)count
{
  for(int i = 0; i < count; i++) {
    emrConn *conn = [emrConn new];
    [connections addObject:conn];
  }
}

@end
