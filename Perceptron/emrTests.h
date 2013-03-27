//
//  emrTests.h
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface emrTests : NSObject
+ (void)singleInputTrainingWithNetwork:(emrNetwork*)network;
+ (void)xorGateTraining:(emrNetwork*)network;
+ (void)addition:(emrNetwork*)network;
+ (void)additionWithGaussian:(emrNetwork*)network;
+ (void)loadedSumWithFileWithNetwork:(emrNetwork*)network;
@end
