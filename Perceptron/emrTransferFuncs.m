//
//  emrTransferFuncs.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrTransferFuncs.h"

@implementation emrTransferFuncs

+ (double)run:(NSString*)function withDouble:(double)x isDerivative:(BOOL)derivative
{
  if([function isEqualToString:transferFunctionNone]) {
    return 0.0f;
  }
  
  if([function isEqualToString:transferFunctionGaussian]) {
    return derivative ? [emrTransferFuncs gaussianDerivative:x]  : [emrTransferFuncs gaussian:x];
  }
  
  if([function isEqualToString:transferFunctionLinear]) {
    return derivative ? [emrTransferFuncs linearDerivative:x]    : [emrTransferFuncs linear:x];
  }
  
  if([function isEqualToString:transferFunctionRational]) {
    return derivative ? [emrTransferFuncs rationalSigmoid:x]     : [emrTransferFuncs rationalSigmoid:x];
  }
  
  if([function isEqualToString:transferFunctionSigmoid]) {
    return derivative ? [emrTransferFuncs sigmoid:x]             : [emrTransferFuncs sigmoid:x];
  }
  
  // Return linear, if else fails
  return 0.0f;
}

+ (double)sigmoid:(double)x
{
  return 1.0f / (1.0f + expf(-x));
}

+ (double)sigmoidDerivative:(double)x
{
  return [emrTransferFuncs sigmoid:x] * (1 - [emrTransferFuncs sigmoid:x]);
}

+ (double)linear:(double)x
{
  return x;
}

+ (double)linearDerivative:(double)x
{
  return 1.0f;
}

+ (double)gaussian:(double)x
{
  return expf(-powf(x, 2));
}

+ (double)gaussianDerivative:(double)x
{
  return -2.0f * x * [emrTransferFuncs gaussian:x];
}

+ (double)rationalSigmoid:(double)x
{
  return x / (1.0f + sqrtf(1.0f + x * x));
}

+ (double)rationalSigmoidDerivative:(double)x
{
  double val = sqrtf(1.0f + x * x);
  return 1.0f / (val * (1 + val));
}

+ (double)getRandom
{
  return ((double)arc4random() / ARC4RANDOM_MAX);
}

+ (double)getRandomGaussian:(double)mean stddev:(double)stddev
{
  double u, v, s, t, val1, val2;
  
  do {
    u = 2 * [emrTransferFuncs getRandom] - 1;
    v = 2 * [emrTransferFuncs getRandom] - 1;
  } while (u * u + v * v > 1 || (u == 0 && v == 0));
  
  s = u * u + v * v;
  t = sqrt((-2.0 * log(s)) / s);
  
  val1 = stddev * u * t + mean;
  val2 = stddev * v * t + mean;
  
  return val1;
}

@end
