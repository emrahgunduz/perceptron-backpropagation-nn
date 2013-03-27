//
//  emrView.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class emrNetwork;

@interface emrView : NSView
{
  emrNetwork *network;
}

- (void)drawNetwork:(emrNetwork*)network;
- (void)update;

@end
