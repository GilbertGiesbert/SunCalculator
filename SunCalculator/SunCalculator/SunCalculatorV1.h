//
// Created by iOS Entwickler on 29.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

// This calculator is based on http://lexikon.astronomie.info/zeitgleichung/

#import <Foundation/Foundation.h>

#define HORIZONT_HEIGHT_SUNRISE_IN_ANGULAR_MINUTES -50.0
#define HORIZONT_HEIGHT_SUNSET_IN_ANGULAR_MINUTES -50.0


@interface SunCalculatorV1 : NSObject

+ (NSString *)calcSunriseForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude;
+ (NSString *)calcSunsetForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude;

@end