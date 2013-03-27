//
//  emrTransferFuncs.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface emrTransferFuncs : NSObject

+ (double)run:(NSString*)function withDouble:(double)x isDerivative:(BOOL)derivative;

+ (double)sigmoid:(double)x;
+ (double)sigmoidDerivative:(double)x;

+ (double)linear:(double)x;
+ (double)linearDerivative:(double)x;

+ (double)gaussian:(double)x;
+ (double)gaussianDerivative:(double)x;

+ (double)rationalSigmoid:(double)x;
+ (double)rationalSigmoidDerivative:(double)x;

+ (double)getRandom;
+ (double)getRandomGaussian:(double)mean stddev:(double)stddev;
@end
