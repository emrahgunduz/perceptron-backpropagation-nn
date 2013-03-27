//
//  emrNetwork.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrNetwork.h"
#include "vector"

NSString *transferFunctionNone     = @"transfer.Fuction.None";
NSString *transferFunctionSigmoid  = @"transfer.Fuction.Sigmoid";
NSString *transferFunctionLinear   = @"transfer.Fuction.Linear";
NSString *transferFunctionGaussian = @"transfer.Fuction.Gaussian";
NSString *transferFunctionRational = @"transfer.Fuction.Rational";

@implementation emrNetwork

@synthesize layers;
@synthesize layerCount;
@synthesize systemTransferFunction;

// Built in vectors for nodes
std::vector < std::vector<double> > nodeInput;
std::vector < std::vector<double> > nodeOutput;
std::vector < std::vector<double> > nodeDelta;
std::vector < std::vector<double> > nodeBias;
std::vector < std::vector<double> > nodeBiasDelta;
std::vector < std::vector<double> > nodePrevBiasDelta;

// Built in vecrots for connections
std::vector < std::vector< std::vector<double> > > connectionWeight;
std::vector < std::vector< std::vector<double> > > connectionWeightDelta;
std::vector < std::vector< std::vector<double> > > connectionPrevWeightDelta;

- (id)init
{
  self = [super init];
  
  layers            = [NSMutableArray array];
  layerCount        = 0;
  hiddenLayerCount  = 0;
  transferFunctions = nil;
  thousandCounter   = 0;
  errors            = [NSMutableArray array];
  systemTransferFunction = transferFunctionSigmoid;
  
  return self;
}

+ (BOOL)fuzzyEqual:(double)a and:(double)b difference:(double)diff
{
  return (a - diff <= b && b <= a + diff);
}

- (void)destroy
{
  nodeInput.clear();
  nodeOutput.clear();
  nodeDelta.clear();
  nodeBias.clear();
  nodeBiasDelta.clear();
  nodePrevBiasDelta.clear();
  
  connectionWeight.clear();
  connectionWeightDelta.clear();
  connectionPrevWeightDelta.clear();
  
  layers            = nil;
  layers            = [NSMutableArray array];
  layerCount        = 0;
  hiddenLayerCount  = 0;
  transferFunctions = nil;
}

- (void)setRenderView:(emrView*)view
{
  networkView = view;
  [networkView drawNetwork:self];
}

- (void)updateView
{
  [self prepareNetworkBeforeSaving];
  [networkView update];
}

- (void)setTransferFunctions:(NSArray *)funcs
{
  if(funcs.count != layerCount) {
    NSLog(@"Transfer function count must be the same as the layer count");
    return;
  }
  transferFunctions = funcs;
}

- (void)createInputLayerWithNodeCount:(int)nodeCount withConnectionCount:(int)connCount
{
  NSMutableArray *layer = [NSMutableArray array];
  for(int i = 0; i < nodeCount; i++) {
    emrNode *node = [emrNode new];
    [node createConnections:connCount];
    [layer addObject:node];
  }
  [layers addObject:layer];
  layerCount++;
}

- (void)createOutputLayerWithNodeCount:(int)nodeCount
{
  NSMutableArray *layer = [NSMutableArray array];
  for(int i = 0; i < nodeCount; i++) {
    emrNode *node = [emrNode new];
    [layer addObject:node];
  }
  [layers addObject:layer];
  layerCount++;
  
  [self prepareNetworkBeforeRunning];
}

- (void)createHiddenLayerWithNodeCount:(int)nodeCount withConnectionCount:(int)connCount
{
  NSMutableArray *layer = [NSMutableArray array];
  for(int i = 0; i < nodeCount; i++) {
    emrNode *node = [emrNode new];
    [node createConnections:connCount];
    [layer addObject:node];
  }
  [layers addObject:layer];
  
  layerCount++;
  hiddenLayerCount++;
}

- (void)prepareNetworkBeforeRunning
{
  nodeInput.clear();
  nodeOutput.clear();
  nodeDelta.clear();
  nodeBias.clear();
  nodeBiasDelta.clear();
  nodePrevBiasDelta.clear();
  
  connectionWeight.clear();
  connectionWeightDelta.clear();
  connectionPrevWeightDelta.clear();
  
  // Convert nodes' and connections' data to c++ vectors
  for (int i = 0; i < layers.count; i++) {
    NSMutableArray *layer = [layers objectAtIndex:i];
    
    nodeInput.push_back(std::vector<double>());
    nodeOutput.push_back(std::vector<double>());
    nodeBias.push_back(std::vector<double>());
    nodeBiasDelta.push_back(std::vector<double>());
    nodePrevBiasDelta.push_back(std::vector<double>());
    nodeDelta.push_back(std::vector<double>());
    
    connectionWeight.push_back(std::vector<std::vector<double>>());
    connectionWeightDelta.push_back(std::vector<std::vector<double>>());
    connectionPrevWeightDelta.push_back(std::vector<std::vector<double>>());
    
    for (int j = 0; j < layer.count; j++) {
      emrNode *node = [layer objectAtIndex:j];
      
      nodeInput[i].push_back(node.input);
      nodeOutput[i].push_back(node.output);
      nodeBias[i].push_back(node.bias);
      nodeBiasDelta[i].push_back(node.biasDelta);
      nodePrevBiasDelta[i].push_back(node.prevBiasDelta);
      nodeDelta[i].push_back(node.delta);
      
      connectionWeight[i].push_back(std::vector<double>());
      connectionWeightDelta[i].push_back(std::vector<double>());
      connectionPrevWeightDelta[i].push_back(std::vector<double>());
      
      for (int k = 0; k < [node.connections count]; k++) {
        emrConn *conn = [node.connections objectAtIndex:k];
        
        connectionWeight[i][j].push_back(conn.weight);
        connectionPrevWeightDelta[i][j].push_back(conn.prevWeightDelta);
      }
    }
  }
}

- (void)prepareNetworkBeforeSaving
{
  // Move c++ vector data to nodes and connections
  for (int i = 0; i < layers.count; i++) {
    NSMutableArray *layer = [layers objectAtIndex:i];
    for (int j = 0; j < layer.count; j++) {
      emrNode *node = [layer objectAtIndex:j];
      
      node.input         = nodeInput[i][j];
      node.output        = nodeOutput[i][j];
      node.bias          = nodeBias[i][j];
      node.biasDelta     = nodeBiasDelta[i][j];
      node.prevBiasDelta = nodePrevBiasDelta[i][j];
      node.delta         = nodeDelta[i][j];
      
      for (int k = 0; k < [node.connections count]; k++) {
        emrConn *conn = [node.connections objectAtIndex:k];
        
        conn.weight = connectionWeight[i][j][k];
        conn.prevWeightDelta = connectionPrevWeightDelta[i][j][k];
        
        // Save connection
        [node.connections replaceObjectAtIndex:k withObject:conn];
      }
      
      // Save node
      [layer replaceObjectAtIndex:j withObject:node];
    }
    
    // Save layer
    [layers replaceObjectAtIndex:i withObject:layer];
  }
}

- (NSArray*)runWithInput:(NSArray*)input
{
  @autoreleasepool {  
    if(nodeOutput[0].size() != input.count) {
      NSLog(@"Input node count and input value count must be same");
      return [NSArray array];
    }
    
    // Set input for the input layer
    for (int i = 0; i < nodeOutput[0].size(); i++) {
      nodeOutput[0][i] = [[input objectAtIndex:i] doubleValue];
    }
    
    double sum = 0.0f;
    
    // Set hidden and output layers
    for (int i = 1; i < layerCount; i++) {
      for (int j = 0; j < nodeOutput[i].size(); j++) {
        
        sum = 0.0f;
        
        for (int k = 0; k < nodeOutput[i-1].size(); k++) {
          double a = nodeOutput[i-1][k];
          double b = connectionWeight[i-1][k][j];
          sum += a * b;
        }
        
        sum += nodeBias[i][j];
        nodeInput[i][j] = sum;
        if(transferFunctions) {
          nodeOutput[i][j] = [emrTransferFuncs run:[transferFunctions objectAtIndex:i] withDouble:sum isDerivative:NO];
        } else {
          nodeOutput[i][j] = [emrTransferFuncs run:systemTransferFunction withDouble:sum isDerivative:NO];
        }
      }
    }
  }
  
  NSMutableArray *output;
  @autoreleasepool {
    // Build the output array
    output = [NSMutableArray array];
    for (int i = 0; i < nodeOutput[layerCount-1].size(); i++) {
      [output addObject:[NSNumber numberWithDouble:nodeOutput[layerCount-1][i]]];
    }
  }
  
  return [output copy];
}

- (double)trainWithInput:(NSArray *)input desired:(NSArray *)desired trainingRate:(double)trainingRate momentum:(double)momentum
{
  if(nodeOutput[0].size() != input.count) {
    NSLog(@"Input node count and input value count must be same");
    return 0.0f;
  }
  
  if(nodeOutput[layerCount-1].size() != desired.count) {
    NSLog(@"Output node count and desired value count must be same");
    return 0.0f;
  }
  
  double error = 0.0f;
  double sum = 0.0f;
  double weightDelta = 0.0f;
  double biasDelta = 0.0f;
  
  // Get the output
  NSArray *output = [self runWithInput:input];
  
  @autoreleasepool {
    //
    // BACKPROPAGATE
    //
    for (int l = layerCount-1; l >= 0; l--) {
      if(l == layerCount - 1) {
        // Output layer
        for (int k = 0; k < nodeOutput[l].size(); k++) {
          nodeDelta[l][k] = [[output objectAtIndex:k] doubleValue] - [[desired objectAtIndex:k] doubleValue];
          error += pow(nodeDelta[l][k], 2);
          
          if(transferFunctions) {
            nodeDelta[l][k] *= [emrTransferFuncs run:[transferFunctions objectAtIndex:l] withDouble:nodeInput[l][k] isDerivative:YES];
          } else {
            nodeDelta[l][k] *= [emrTransferFuncs run:systemTransferFunction withDouble:nodeInput[l][k] isDerivative:YES];            
          }
        }
        
      } else {
        for (int i = 0; i < nodeOutput[l].size(); i++) {
          sum = 0.0f;
          
          for (int j = 0; j < nodeOutput[l+1].size(); j++) {
            sum += connectionWeight[l][i][j] * nodeDelta[l+1][j];
          }
          
          if(transferFunctions) {
            sum *= [emrTransferFuncs run:[transferFunctions objectAtIndex:l] withDouble:nodeInput[l][i] isDerivative:YES];
          } else {
            sum *= [emrTransferFuncs run:systemTransferFunction withDouble:nodeInput[l][i] isDerivative:YES];
          }
          nodeDelta[l][i] = sum;
        }
      }
    }
    
    //
    // UPDATING WEIGHTS
    //
    for (int l = 1; l < layerCount; l++) {
      for (int i = 0; i < nodeOutput[l].size(); i++) {
        for (int j = 0; j < nodeOutput[l-1].size(); j++) {
          weightDelta = trainingRate * nodeDelta[l][i] * nodeOutput[l-1][j] + momentum * connectionPrevWeightDelta[l-1][j][i];
          connectionWeight[l-1][j][i] -= weightDelta;
          connectionPrevWeightDelta[l-1][j][i] = weightDelta;
        }
      }
    }
    
    //
    // UPDATING BIASES
    //
    for (int l = 0; l < layerCount; l++) {
      for (int i = 0; i < nodeOutput[l].size(); i++) {
        biasDelta = trainingRate * nodeDelta[l][i];
        nodeBias[l][i] -= nodeBiasDelta[l][i] + momentum * nodePrevBiasDelta[l][i];
        nodePrevBiasDelta[l][i] = biasDelta;
      }
    }
  }
  
  [errors addObject:[NSNumber numberWithDouble:error]];
  
  return error;
}

- (void)clearErrorArray
{
  errors = [NSMutableArray array];
}

- (NSArray*)getErrorArray
{
  return [errors copy];
}

- (NSMutableArray*)returnForSaving:(NSMutableArray*)layer
{
  NSMutableArray *l = [NSMutableArray array];
  
  for (int i = 0; i < layer.count; i++) {
    emrNode *node = [layer objectAtIndex:i];
    
    NSMutableArray *c = [NSMutableArray array];
    for (int j = 0; j < node.connections.count; j++) {
      emrConn *conn = [node.connections objectAtIndex:j];
      
      NSDictionary *cDict = @{
                              @"weight"          : [NSNumber numberWithDouble:conn.weight],
                              @"weightDelta"     : [NSNumber numberWithDouble:conn.weightDelta],
                              @"prevWeightDelta" : [NSNumber numberWithDouble:conn.prevWeightDelta]
                              };
      [c addObject:cDict];
    }
    
    NSDictionary *dict = @{
                           @"output"        : [NSNumber numberWithDouble:node.output],
                           @"input"         : [NSNumber numberWithDouble:node.input],
                           @"delta"         : [NSNumber numberWithDouble:node.delta],
                           @"bias"          : [NSNumber numberWithDouble:node.bias],
                           @"biasDelta"     : [NSNumber numberWithDouble:node.biasDelta],
                           @"prevBiasDelta" : [NSNumber numberWithDouble:node.prevBiasDelta],
                           @"connections"   : c
                           };
    [l addObject:dict];
  }

  return l;
}

- (void)saveTrainingData:(NSString*)file
{
  [self prepareNetworkBeforeSaving];
  
  NSMutableArray *trainingData = [NSMutableArray array];
  for (int k = 0; k < layers.count; k++) {
    NSMutableArray *layer = [layers objectAtIndex:k];
    [trainingData addObject:[self returnForSaving:layer]];
  }
  
  if(transferFunctions) {
    NSDictionary *functions = @{@"transferFunctions" : transferFunctions};
    [trainingData addObject:functions];
  }
  
  [trainingData writeToFile:file atomically:YES];
}

- (void)loadTrainingData:(NSString*)file
{
  NSMutableArray *trainingData = [NSMutableArray arrayWithContentsOfFile:file];
  if(!trainingData) {
    NSLog(@"No training data was found");
    return;
  }
  
  // Resetting network
  [self destroy];
  
  // Last part of the training data is transferfunctions
  NSDictionary *functions = [trainingData lastObject];
  if([functions class] == [NSDictionary class]) {
    transferFunctions = [functions objectForKey:@"transferFunctions"];
    // Remove last training object
    [trainingData removeLastObject];
  }
  
  for (int i = 0; i < trainingData.count; i++) {
    NSMutableArray *layer = [trainingData objectAtIndex:i];
    if (i == 0) {
      // Create input layer
      NSMutableArray *nextLayer = [trainingData objectAtIndex:i+1];
      [self createInputLayerWithNodeCount:(int)layer.count withConnectionCount:(int)nextLayer.count];
    } else if(i < trainingData.count - 1) {
      // Create other layers
      NSMutableArray *nextLayer = [trainingData objectAtIndex:i+1];
      [self createHiddenLayerWithNodeCount:(int)layer.count withConnectionCount:(int)nextLayer.count];
    } else {
      // Create output layer
      [self createOutputLayerWithNodeCount:(int)layer.count];
    }
    
    NSMutableArray *createdLayer = [layers objectAtIndex:i];
    for (int j = 0; j < createdLayer.count; j++) {
      // Update nodes of the created layer
      NSDictionary *nodeDict = [layer objectAtIndex:j];
      emrNode *node = [createdLayer objectAtIndex:j];
      node.input         = [[nodeDict objectForKey:@"input"] doubleValue];
      node.output        = [[nodeDict objectForKey:@"output"] doubleValue];
      node.delta         = [[nodeDict objectForKey:@"delta"] doubleValue];
      node.bias          = [[nodeDict objectForKey:@"bias"] doubleValue];
      node.biasDelta     = [[nodeDict objectForKey:@"biasDelta"] doubleValue];
      node.prevBiasDelta = [[nodeDict objectForKey:@"prevBiasDelta"] doubleValue];
      
      // Update connection if this is not output layer
      if(i != trainingData.count -1) {
        // Connections
        NSArray *conns = [nodeDict objectForKey:@"connections"];
        for (int k = 0; k < node.connections.count; k++) {
          NSDictionary *connDict = [conns objectAtIndex:k];
          emrConn *conn = [node.connections objectAtIndex:k];
          conn.weight          = [[connDict objectForKey:@"weight"] doubleValue];
          conn.weightDelta     = [[connDict objectForKey:@"weightDelta"] doubleValue];
          conn.prevWeightDelta = [[connDict objectForKey:@"prevWeightDelta"] doubleValue];
          // Save connection
          [node.connections replaceObjectAtIndex:k withObject:conn];
        }
      }
      
      // Save node
      [createdLayer replaceObjectAtIndex:j withObject:node];
    }
    
    // Save layer
    [layers replaceObjectAtIndex:i withObject:createdLayer];
  }
  
  [self prepareNetworkBeforeRunning];
  [networkView update];
}









@end
