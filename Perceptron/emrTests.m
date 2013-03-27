//
//  emrTests.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrTests.h"

@implementation emrTests

+ (void)singleInputTrainingWithNetwork:(emrNetwork*)network
{
  [network destroy];
  [network createInputLayerWithNodeCount:1 withConnectionCount:3];
  [network createHiddenLayerWithNodeCount:3 withConnectionCount:3];
  [network createOutputLayerWithNodeCount:1];
  
  NSArray *transferFunctions = @[transferFunctionSigmoid, transferFunctionSigmoid, transferFunctionLinear];
  [network setTransferFunctions:transferFunctions];
  
  NSArray *input  = @[@1.0f];
  NSArray *output = @[@9.0f];
  
  // Train
  BOOL equal = NO;
  double error = 0.0f;
  int i = 0;
  do {
    
    error = [network trainWithInput:input desired:output trainingRate:0.35f momentum:0.1f];
    
    if(i % 500 == 0) {
      NSLog(@"--------------------------------------");
      NSLog(@"EPOCH  : %i", i);
      NSLog(@"ERROR  : %0.20f", error);
    }
    
    if(i == 10000 || [emrNetwork fuzzyEqual:error and:0.00f difference:0.0000001]){
      equal = YES;
      NSLog(@"--------------------------------------");
      NSLog(@"** EPOCH: %i", i);
      NSLog(@"** ERROR  : %0.20f", error);
    }
    
    i++;
    
  } while (!equal);
  
  NSArray *outRun = [network runWithInput:input];
  NSLog(@"--------------------------------------");
  NSLog(@"FINAL RUN  : %@", outRun);
  NSLog(@"--------------------------------------");
}

+ (void)multipleInputTraining:(emrNetwork*)network
{
  [network destroy];
  [network createInputLayerWithNodeCount:3 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:5];
  [network createOutputLayerWithNodeCount:3];
  
  NSArray *transferFunctions = @[transferFunctionSigmoid, transferFunctionSigmoid, transferFunctionLinear];
  [network setTransferFunctions:transferFunctions];
  
  NSArray *input  = @[@1.0f, @2.0f, @3.0f];
  NSArray *output = @[@10.0f, @20.0f, @30.0f];
  
  // Train
  BOOL equal = NO;
  double error = 0.0f;
  int i = 0;
  do {
    
    error = [network trainWithInput:input desired:output trainingRate:0.35f momentum:0.1f];
    
    if(i % 500 == 0) {
      NSLog(@"--------------------------------------");
      NSLog(@"EPOCH  : %i", i);
      NSLog(@"ERROR  : %0.20f", error);
    }
    
    if(i == 10000 || [emrNetwork fuzzyEqual:error and:0.00f difference:0.00000001]){
      equal = YES;
      NSLog(@"--------------------------------------");
      NSLog(@"** EPOCH: %i", i);
      NSLog(@"** ERROR  : %0.20f", error);
    }
    
    i++;
    
  } while (!equal);
  
  NSArray *outRun = [network runWithInput:input];
  NSLog(@"--------------------------------------");
  NSLog(@"FINAL RUN  : %@", outRun);
  NSLog(@"--------------------------------------");
}

+ (void)xorGateTraining:(emrNetwork*)network
{
  [network destroy];
  
  [network createInputLayerWithNodeCount:2 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:1];
  [network createOutputLayerWithNodeCount:1];
  
  NSArray *input = @[@[@0.0f, @1.0], @[@0.0f, @0.0], @[@1.0f, @1.0], @[@1.0f, @0.0]];
  NSArray *output = @[@[@1.0f], @[@0.0f], @[@0.0f], @[@1.0f]];
  
  // Train
  BOOL equal = NO;
  double error = 0.0f;
  int i = 0;
  do {
    
    error = 0.0f;
    
    for (int i = 0; i < input.count; i++) {
      error += [network trainWithInput:[input objectAtIndex:i] desired:[output objectAtIndex:i] trainingRate:0.35f momentum:0.0f];
    }
    
    if(i % 2000 == 0) {
      NSLog(@"--------------------------------------");
      NSLog(@"EPOCH  : %i", i);
      NSLog(@"ERROR  : %0.20f", error);
    }
    
    if(i == 10000 || [emrNetwork fuzzyEqual:error and:0.00f difference:0.0000001]){
      equal = YES;
      NSLog(@"--------------------------------------");
      NSLog(@"** EPOCH: %i", i);
    }
    
    i++;
    
  } while (!equal);
  
  for (int i = 0; i < input.count; i++) {
    NSArray *outRun = [network runWithInput:[input objectAtIndex:i]];
    NSLog(@"--------------------------------------");
    NSLog(@"FINAL RUN FOR %.1f - %.1f => %.1f", [[[input objectAtIndex:i] objectAtIndex:0] doubleValue], [[[input objectAtIndex:i] objectAtIndex:1] doubleValue], [[outRun objectAtIndex:0] doubleValue]);
    NSLog(@"--------------------------------------");
  }
}

+ (void)addition:(emrNetwork*)network
{
  [network destroy];
  
  [network createInputLayerWithNodeCount:2 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:5];
  [network createHiddenLayerWithNodeCount:5 withConnectionCount:1];
  [network createOutputLayerWithNodeCount:1];
  [network updateView];
  
  NSArray *input = @[
                     @[@0.0f, @0.1],
                     @[@0.0f, @0.2],
                     @[@0.0f, @0.3],
                     @[@0.0f, @0.4],
                     @[@0.0f, @0.5],
                     @[@0.0f, @0.6],
                     @[@0.0f, @0.7],
                     @[@0.0f, @0.8],
                     @[@0.0f, @0.9],
                     @[@0.1f, @0.1],
                     @[@0.1f, @0.2],
                     @[@0.1f, @0.3],
                     @[@0.1f, @0.4],
                     @[@0.1f, @0.5],
                     @[@0.1f, @0.6],
                     @[@0.1f, @0.7],
                     @[@0.1f, @0.8],
                     @[@0.1f, @0.9]
                     ];
  NSArray *output = @[
                      @[@0.1f],
                      @[@0.2f],
                      @[@0.3f],
                      @[@0.4f],
                      @[@0.5f],
                      @[@0.6f],
                      @[@0.7f],
                      @[@0.8f],
                      @[@0.9f],
                      @[@0.2f],
                      @[@0.3f],
                      @[@0.4f],
                      @[@0.5f],
                      @[@0.6f],
                      @[@0.7f],
                      @[@0.8f],
                      @[@0.9f],
                      @[@1.0f]
                      ];
  
  dispatch_queue_t run = dispatch_queue_create("NNRun", NULL);
  dispatch_async(run, ^{
    // Train
    BOOL equal = NO;
    double error = 0.0f;
    int i = 0;
    
    do {
      error = 0.0f;
      
      for (int i = 0; i < input.count; i++) {
        error += [network trainWithInput:[input objectAtIndex:i] desired:[output objectAtIndex:i] trainingRate:0.35f momentum:0.1f];
      }
      
      if(i % 5000 == 0) {
        NSLog(@"--------------------------------------");
        NSLog(@"EPOCH  : %i", i);
        NSLog(@"ERROR  : %0.20f", error);
        NSArray *a = @[@0.2f, @0.3];
        NSArray *b = [network runWithInput:input];
        NSLog(@"CHECK RUN FOR %.1f - %.1f => %.1f", [[a objectAtIndex:0] doubleValue], [[a objectAtIndex:1] doubleValue], [[b objectAtIndex:0] doubleValue]);
      }
      
      if(i == 250000 || [emrNetwork fuzzyEqual:error and:0.00f difference:0.0000001]){
        equal = YES;
        NSLog(@"--------------------------------------");
        NSLog(@"** EPOCH: %i", i);
      }
      
      i++;
      
      dispatch_async(dispatch_get_main_queue(), ^{
        if(i % 5000 == 0)
          [network updateView];
      });
      
    } while (!equal);
    
    for (int i = 0; i < input.count; i++) {
      NSArray *outRun = [network runWithInput:[input objectAtIndex:i]];
      NSLog(@"--------------------------------------");
      NSLog(@"FINAL RUN FOR %.1f - %.1f => %.1f", [[[input objectAtIndex:i] objectAtIndex:0] doubleValue], [[[input objectAtIndex:i] objectAtIndex:1] doubleValue], [[outRun objectAtIndex:0] doubleValue]);
      NSLog(@"--------------------------------------");
    }
    
    NSArray *input = @[@0.2f, @0.3];
    NSArray *outRun = [network runWithInput:input];
    NSLog(@"--------------------------------------");
    NSLog(@"CHECK RUN FOR %.1f - %.1f => %.1f", [[input objectAtIndex:0] doubleValue], [[input objectAtIndex:1] doubleValue], [[outRun objectAtIndex:0] doubleValue]);
    NSLog(@"--------------------------------------");
  });
}

+ (void)additionWithGaussian:(emrNetwork*)network
{
  [network destroy];
  
  [network createInputLayerWithNodeCount:2 withConnectionCount:8];
  [network createHiddenLayerWithNodeCount:8 withConnectionCount:1];
  [network createOutputLayerWithNodeCount:1];
  [network updateView];
  
  NSArray *input = @[
                     @[@0.00f, @0.01],
                     @[@0.00f, @0.02],
                     @[@0.00f, @0.03],
                     @[@0.00f, @0.04],
                     @[@0.00f, @0.05],
                     @[@0.00f, @0.06],
                     @[@0.00f, @0.07],
                     @[@0.00f, @0.08],
                     @[@0.00f, @0.09],
                     @[@0.01f, @0.01],
                     @[@0.01f, @0.02],
                     @[@0.01f, @0.03],
                     @[@0.01f, @0.04],
                     @[@0.01f, @0.05],
                     @[@0.01f, @0.06],
                     @[@0.01f, @0.07],
                     @[@0.01f, @0.08],
                     @[@0.01f, @0.09]
                     ];
  NSArray *output = @[
                      @[@0.01f],
                      @[@0.02f],
                      @[@0.03f],
                      @[@0.04f],
                      @[@0.05f],
                      @[@0.06f],
                      @[@0.07f],
                      @[@0.08f],
                      @[@0.09f],
                      @[@0.02f],
                      @[@0.03f],
                      @[@0.04f],
                      @[@0.05f],
                      @[@0.06f],
                      @[@0.07f],
                      @[@0.08f],
                      @[@0.09f],
                      @[@0.10f]
                      ];
  
  dispatch_queue_t run = dispatch_queue_create("NNRun", NULL);
  dispatch_async(run, ^{
    // Train
    BOOL equal = NO;
    double error = 0.0f;
    int i = 0;
    
    do {
      error = 0.0f;
      
      for (int i = 0; i < input.count; i++) {
        error += [network trainWithInput:[input objectAtIndex:i] desired:[output objectAtIndex:i] trainingRate:0.35f momentum:0.1f];
      }
      
      if(i % 5000 == 0) {
        NSLog(@"--------------------------------------");
        NSLog(@"EPOCH  : %i", i);
        NSLog(@"ERROR  : %0.10f", error);
        NSArray *a = @[@0.03f, @0.02];
        NSArray *b = [network runWithInput:a];
        NSLog(@"CHECK RUN FOR %.4f - %.4f => %.4f", [[a objectAtIndex:0] doubleValue], [[a objectAtIndex:1] doubleValue], [[b objectAtIndex:0] doubleValue]);
        a = @[@0.05f, @0.04];
        b = [network runWithInput:a];
        NSLog(@"CHECK RUN FOR %.4f - %.4f => %.4f", [[a objectAtIndex:0] doubleValue], [[a objectAtIndex:1] doubleValue], [[b objectAtIndex:0] doubleValue]);
      }
      
      if(i == 200000 || [emrNetwork fuzzyEqual:error and:0.00f difference:0.0000001]){
        equal = YES;
        NSLog(@"--------------------------------------");
        NSLog(@"** EPOCH: %i", i);
        [network updateView];
      }
      
      i++;
      
      dispatch_async(dispatch_get_main_queue(), ^{
        if(i % 5000 == 0)
          [network updateView];
      });
      
    } while (!equal);
    
    for (int i = 0; i < input.count; i++) {
      NSArray *outRun = [network runWithInput:[input objectAtIndex:i]];
      NSLog(@"--------------------------------------");
      NSLog(@"FINAL RUN FOR %.4f - %.4f => %.4f", [[[input objectAtIndex:i] objectAtIndex:0] doubleValue], [[[input objectAtIndex:i] objectAtIndex:1] doubleValue], [[outRun objectAtIndex:0] doubleValue]);
      NSLog(@"--------------------------------------");
    }
    
    NSArray *input = @[@0.01f, @0.10];
    NSArray *outRun = [network runWithInput:input];
    NSLog(@"--------------------------------------");
    NSLog(@"CHECK RUN FOR %.4f - %.4f => %.4f", [[input objectAtIndex:0] doubleValue], [[input objectAtIndex:1] doubleValue], [[outRun objectAtIndex:0] doubleValue]);
    NSLog(@"--------------------------------------");
    
    input = @[@0.05f, @0.09];
    outRun = [network runWithInput:input];
    NSLog(@"--------------------------------------");
    NSLog(@"CHECK RUN FOR %.4f - %.4f => %.4f", [[input objectAtIndex:0] doubleValue], [[input objectAtIndex:1] doubleValue], [[outRun objectAtIndex:0] doubleValue]);
    NSLog(@"--------------------------------------");
  });
}

+ (void)loadedSumWithFileWithNetwork:(emrNetwork*)network
{
    NSArray *input = @[
                       @[@0.1f, @0.1],
                       @[@0.1f, @0.2],
                       @[@0.1f, @0.3],
                       @[@0.1f, @0.4],
                       @[@0.1f, @0.5],
                       @[@0.1f, @0.6],
                       @[@0.1f, @0.7],
                       @[@0.1f, @0.8],
                       @[@0.1f, @0.9],
                       @[@0.2f, @0.1],
                       @[@0.2f, @0.2],
                       @[@0.2f, @0.3],
                       @[@0.2f, @0.4],
                       @[@0.2f, @0.5],
                       @[@0.2f, @0.6],
                       @[@0.2f, @0.7],
                       @[@0.2f, @0.8],
                       @[@0.3f, @0.1],
                       @[@0.3f, @0.2],
                       @[@0.3f, @0.3],
                       @[@0.3f, @0.4],
                       @[@0.3f, @0.5],
                       @[@0.3f, @0.6],
                       @[@0.3f, @0.7],
                       @[@0.4f, @0.1],
                       @[@0.4f, @0.2],
                       @[@0.4f, @0.3],
                       @[@0.4f, @0.4],
                       @[@0.4f, @0.5],
                       @[@0.4f, @0.6],
                       @[@0.5f, @0.1],
                       @[@0.5f, @0.2],
                       @[@0.5f, @0.3],
                       @[@0.5f, @0.4],
                       @[@0.5f, @0.5],
                       @[@0.6f, @0.1],
                       @[@0.6f, @0.2],
                       @[@0.6f, @0.3],
                       @[@0.6f, @0.4],
                       @[@0.7f, @0.1],
                       @[@0.7f, @0.2],
                       @[@0.7f, @0.3],
                       @[@0.8f, @0.1],
                       @[@0.8f, @0.2],
                       @[@0.9f, @0.1],
                       @[@0.9f, @0.9],
                       ];
    for (int i = 0; i < input.count; i++) {
      NSArray *outRun = [network runWithInput:[input objectAtIndex:i]];
      float a = ([[[input objectAtIndex:i] objectAtIndex:0] doubleValue]*10.0f);
      float b = ([[[input objectAtIndex:i] objectAtIndex:1] doubleValue]*10.0f);
      float c = ([[outRun objectAtIndex:0] doubleValue] * 10.0f);
      NSLog(@"%.1f + %.1f = %.1f", a, b, round(c));
    }
}
@end
