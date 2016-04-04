//
// Created by iOS Entwickler on 30.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

// This calculator is based on https://en.wikipedia.org/wiki/Sunrise_equation

#import "SunCalculatorV2.h"
#import "DateTool.h"
#import "MyLog.h"


@implementation SunCalculatorV2






+ (NSString *)calcSunriseForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude{

    // n
    NSInteger currentJulianDay = [DateTool getJulianDayCountFor:date];
    MyLog(@"currentJulianDay: %d", currentJulianDay);

    // J*
    double meanSolarNoon = longitude / 360.0 + currentJulianDay;
    MyLog(@"meanSolarNoon: %f", meanSolarNoon);

    // M
    double solarMeanAnomaly = fmod((357.5291 + 0.98560028 * meanSolarNoon), 360);
    MyLog(@"solarMeanAnomaly: %f", solarMeanAnomaly);

    // C
    double equationOfTheCenter = 1.9148 * sin(solarMeanAnomaly) + 0.0200 * sin(2*solarMeanAnomaly) + 0.0003 * sin(3*solarMeanAnomaly);
    MyLog(@"equationOfTheCenter: %f", equationOfTheCenter);

    // λ
    double epilipticLongitude = fmod((solarMeanAnomaly + equationOfTheCenter + 180.0 + 102.9372), 360);
    MyLog(@"epilipticLongitude: %f", epilipticLongitude);

    // J-transit
    double solarTransit = 2451545.0 + meanSolarNoon - (0.0053 * sin(solarMeanAnomaly) - 0.0069*sin(2*epilipticLongitude));
    MyLog(@"solarTransit: %f", solarTransit);

    // δ
    double declinationOfTheSun = asin( sin(epilipticLongitude) * sin(23.44) );
    MyLog(@"declinationOfTheSun: %f", declinationOfTheSun);

    // ω
    double hourAngle = acos(  (sin(-0.83) - sin(latitude) * sin(declinationOfTheSun)) / (cos(latitude) * cos(declinationOfTheSun))   );
    MyLog(@"hourAngle: %f", hourAngle);


    // J-set
    double julianDaysSunset = solarTransit + hourAngle / 360.0;
    MyLog(@"julianDaysSunset: %f", julianDaysSunset);

    // J-rise
    double julianDaysSunrise = solarTransit - hourAngle / 360.0;
    MyLog(@"julianDaysSunrise: %f", julianDaysSunrise);




    NSDate *gregorianSunset = [DateTool julianDaysToGregorianDate:julianDaysSunset];
    NSDate *gregorianSunrise = [DateTool julianDaysToGregorianDate:julianDaysSunrise];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy.MM.dd - HH:mm"];

    NSString *sunset  = [dateFormat stringFromDate:gregorianSunset];
    MyLog(@"sunset %@", sunset);
    NSString *sunrise = [dateFormat stringFromDate:gregorianSunrise];
    MyLog(@"sunrise %@", sunrise);

    return [NSString stringWithFormat: @"sunrise: %@\nsunset: %@", sunrise, sunset];

}


@end