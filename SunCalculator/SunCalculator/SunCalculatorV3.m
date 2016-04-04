//
// Created by iOS Entwickler on 31.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

// based on http://users.electromagnetic.net/bu/astro/sunrise-set.php

#import "SunCalculatorV3.h"
#import "DateTool.h"
#import "MyLog.h"


@implementation SunCalculatorV3


+ (NSString *)calcSunriseAndSunsetForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude{

    // J*
    double solarNoon = [DateTool getJulianDayCountFor:date] + JULIAN_DAY_COUNT_FOR_LEAP_SECONDS + (longitude / 360.0);
    MyLog(@"solarNoon %f", solarNoon);

    // M
    double meanSolarAnomaly = fmod((357.5291 + 0.98560028 * (solarNoon - JULIAN_DAY_COUNT_AT_01_01_2000)), 360.0);
    MyLog(@"meanSolarAnomaly %f", meanSolarAnomaly);

    // C
    double equationOfCenter = 1.9148 * sin(meanSolarAnomaly) + 0.0200 * sin(2 * meanSolarAnomaly) + 0.0003 * sin(3 * meanSolarAnomaly);
    MyLog(@"equationOfCenter %f", equationOfCenter);

    // λ
    double epilepticLongitude = fmod((meanSolarAnomaly + 102.9372 + equationOfCenter + 180.0), 360.0);
    MyLog(@"epilepticLongitude %f", epilepticLongitude);

    // J-transit
    double solarTransit = solarNoon + (0.0053 * sin(meanSolarAnomaly)) - (0.0069 * sin(2 * epilepticLongitude));
    MyLog(@"solarTransit %f", solarTransit);

    // δ
    double declinationOfSun = asin( sin(epilepticLongitude) * sin(23.45) );
    MyLog(@"declinationOfSun %f", declinationOfSun);

    // Note: If hourAngle is undefined, then there is either no sunrise (in winter) or no sunset (in summer) for the supplied latitude.
    double hourAngle = acos( (sin(-0.83) - sin(latitude) * sin(declinationOfSun)) / (cos(latitude) * cos(declinationOfSun)) );
    MyLog(@"hourAngle %f", hourAngle);


    //J**
    double solarNoonWithHourAngle = [DateTool getJulianDayCountFor:date] + JULIAN_DAY_COUNT_FOR_LEAP_SECONDS + ( (hourAngle + longitude) / 360.0);
    MyLog(@"solarNoonWithHourAngle %f", solarNoonWithHourAngle);

    // J-set
    double julianSunset = solarNoonWithHourAngle + (0.0053 * sin(meanSolarAnomaly)) - (0.0069 * sin(2 * epilepticLongitude));
    MyLog(@"julianSunset %f", julianSunset);

    // J-rise
    double julianSunrise = solarTransit - (julianSunset - solarTransit);
    MyLog(@"julianSunrise %f", julianSunrise);


    // Jrise = 2457478.6966298 = 03/31/2016 at 06:43:08 +0100
    // Jset = 2457479.2356212 = 03/31/2016 at 19:39:17 +0100

    double testSet = 2457479.2356212;
    double testRise = 2457478.6966298;


    NSDate *gregorianSunset = [DateTool julianDaysToGregorianDate:testSet];
    NSDate *gregorianSunrise = [DateTool julianDaysToGregorianDate:testRise];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy.MM.dd - HH:mm"];

    NSString *sunset  = [dateFormat stringFromDate:gregorianSunset];
    MyLog(@"sunset %@", sunset);
    NSString *sunrise = [dateFormat stringFromDate:gregorianSunrise];
    MyLog(@"sunrise %@", sunrise);

    return [NSString stringWithFormat: @"sunrise: %@\nsunset: %@", sunrise, sunset];
}


@end