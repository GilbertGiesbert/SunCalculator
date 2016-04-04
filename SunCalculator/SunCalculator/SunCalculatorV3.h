//
// Created by iOS Entwickler on 31.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SunCalculatorV3 : NSObject

+ (NSString *)calcSunriseAndSunsetForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude;

@end