//
// Created by iOS Entwickler on 30.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JULIAN_DAY_COUNT_AT_01_01_2000 2451545
#define JULIAN_DAY_COUNT_FOR_LEAP_SECONDS 0.0009



@interface DateTool : NSObject

+ (BOOL)validateDateForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay;

+ (NSDate *)getDateForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay;
+ (NSDate *)getDateForYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute;

+ (NSInteger)getJulianDayCountForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay;

+ (NSInteger)getJulianDayCountFor:(NSDate *)inputDate;

+ (NSInteger)getDayCountSince2000For:(NSDate *)inputDate;

+ (NSInteger)getDayCountSince2000ForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay;


+ (NSDate *)julianDaysToGregorianDate:(double)julianDays;

@end