//
// Created by iOS Entwickler on 30.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

// This calculator is based on https://en.wikipedia.org/wiki/Sunrise_equation

#import <Foundation/Foundation.h>


@interface SunCalculatorV2 : NSObject

+ (NSString *)getSunriseForYear:(int)year month:(int)month day:(int)day latitude:(double)latitude longitude:(double)longitude;

@end