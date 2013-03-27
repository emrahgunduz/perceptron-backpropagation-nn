//
//  emrNetwork.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "emrNode.h"
#import "emrConn.h"

@class emrView;

extern NSString *transferFunctionNone;
extern NSString *transferFunctionSigmoid;
extern NSString *transferFunctionLinear;
extern NSString *transferFunctionGaussian;
extern NSString *transferFunctionRational;

@interface emrNetwork : NSObject
{
  int hiddenLayerCount;
  emrView *networkView;
  NSArray *transferFunctions;  
  int thousandCounter;
  NSMutableArray *errors;
}

@property (assign) int layerCount;
@property (strong) NSMutableArray *layers;
@property (strong) NSString *systemTransferFunction;

+ (BOOL)fuzzyEqual:(double)a and:(double)b difference:(double)diff;

- (id)init;
- (void)createInputLayerWithNodeCount:(int)nodeCount withConnectionCount:(int)connCount;
- (void)createHiddenLayerWithNodeCount:(int)nodeCount withConnectionCount:(int)connCount;
- (void)createOutputLayerWithNodeCount:(int)nodeCount;
- (void)setTransferFunctions:(NSArray*)funcs;
- (void)setRenderView:(NSView*)view;

- (void)updateView;

- (void)prepareNetworkBeforeRunning;
- (void)prepareNetworkBeforeSaving;
- (NSArray*)runWithInput:(NSArray*)input;
- (double)trainWithInput:(NSArray*)input desired:(NSArray*)desired trainingRate:(double)trainingRate momentum:(double)momentum;

- (void)destroy;
- (void)clearErrorArray;
- (NSArray*)getErrorArray;
- (void)saveTrainingData:(NSString*)file;
- (void)loadTrainingData:(NSString*)file;

@end
