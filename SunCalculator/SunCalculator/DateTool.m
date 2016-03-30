//
// Created by iOS Entwickler on 30.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "DateTool.h"


@implementation DateTool

+ (BOOL)validateDateForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";

    NSString *inputString = [NSString stringWithFormat:@"%04d%02d%02d",inputYear,inputMonth,inputDay];

    NSDate *date = [dateFormatter dateFromString:inputString];

    return nil != date;
}

+ (NSDate *)getDateForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay{

    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.year = inputYear;
    comp.month = inputMonth;
    comp.day = inputDay;

    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [cal dateFromComponents:comp];
}

+ (NSInteger)getJulianDayCountForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay{

    NSDate *date = [self getDateForYear:inputYear month:inputMonth day:inputDay];
    return [self getJulianDayCountFor:date];
}

+ (NSInteger)getJulianDayCountFor:(NSDate *)inputDate{

    return [self getDayCountSince2000For:inputDate] + JULIAN_DAY_COUNT_AT_01_01_2000;
}

+ (NSInteger)getDayCountSince2000For:(NSDate *)inputDate{

    NSDate *date_01_01_2000 = [self getDateForYear:2000 month:1 day:1];

    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *diff = [cal components:NSCalendarUnitDay fromDate:date_01_01_2000 toDate:inputDate options:0];
    return diff.day;

}

+ (NSInteger)getDayCountSince2000ForYear:(int)inputYear month:(int)inputMonth day:(int)inputDay{

    NSDate *date = [self getDateForYear:inputYear month:inputMonth day:inputDay];
    return [self getDayCountSince2000For:date];
}

@end