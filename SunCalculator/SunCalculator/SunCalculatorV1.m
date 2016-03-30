//
// Created by iOS Entwickler on 29.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "SunCalculatorV1.h"


@implementation SunCalculatorV1

+ (NSString *)calcSunriseForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude {
    return [self calcSunSwitchForDate:date latitude:latitude longitude:longitude isSunrise:YES];
}

+ (NSString *)calcSunsetForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude {
    return [self calcSunSwitchForDate:date latitude:latitude longitude:longitude isSunrise:NO];
}


+ (NSString *)calcSunSwitchForDate:(NSDate *)date latitude:(double)latitude longitude:(double)longitude isSunrise:(BOOL)isSunrise{

    NSLog(@"latitude: %f", latitude);
    NSLog(@"longitude: %f", longitude);

    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];

    NSInteger timeZoneOffsetSeconds = [timeZone secondsFromGMTForDate:date];
    NSLog(@"timeZoneOffsetSeconds: %d", timeZoneOffsetSeconds);
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeZoneOffsetSeconds]];

    double timeZoneOffsetHours = timeZoneOffsetSeconds / 60.0 / 60.0;
    NSLog(@"timeZoneOffsetHours: %f", timeZoneOffsetHours);


    int dayOfYear = [cal ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    NSLog(@"dayOfYear: %d", dayOfYear);


    double declinationOfSunInRadians = [self declinationOfSunInRadians:dayOfYear];
    NSLog(@"declinationOfSunInRadians: %f", declinationOfSunInRadians);

    double horizontHeightSunSwitchInAngularMinutes = isSunrise ? HORIZONT_HEIGHT_SUNRISE_IN_ANGULAR_MINUTES : HORIZONT_HEIGHT_SUNSET_IN_ANGULAR_MINUTES;

    double timeDiffInHoursNoonToSunSwitch = [self timeDiffInHoursForSunTravelsFromNoonToHorizontHeightX:horizontHeightSunSwitchInAngularMinutes latitude:latitude declinationOfSun:declinationOfSunInRadians];
    NSLog(@"timeDiffInHoursNoonToSunSwitch: %f", timeDiffInHoursNoonToSunSwitch);

    double sunSwitchInHoursTrueLocalTime = [self sunSwitchInHoursTrueLocalTime:timeDiffInHoursNoonToSunSwitch isSunrise:isSunrise];
    NSLog(@"sunSwitchInHoursTrueLocalTime: %f", sunSwitchInHoursTrueLocalTime);

    double sunSwitchInHoursMeanLocalTime = [self sunSwitchInHoursMeanLocalTime:sunSwitchInHoursTrueLocalTime dayOfYear:dayOfYear];
    NSLog(@"sunSwitchInHoursMeanLocalTime: %f", sunSwitchInHoursMeanLocalTime);

    double sunSwitchTime = [self sunSwitchWithSunriseMeanLocalTime:sunSwitchInHoursMeanLocalTime longitude:longitude timezoneCorrection:timeZoneOffsetHours];
    NSLog(@"sunSwitchTime: %f", sunSwitchTime);

    int sunSwitchHours = (int)sunSwitchTime;
    NSLog(@"sunSwitchHours: %d", sunSwitchHours);

    int sunSwitchMinutes = (int)((sunSwitchTime - sunSwitchHours) * 60);
    NSLog(@"sunSwitchMinutes: %d", sunSwitchMinutes);

    NSString *label = isSunrise ? @"sunrise" : @"sunset";

    return [NSString stringWithFormat:@"%@: %02d:%02d", label, sunSwitchHours, sunSwitchMinutes];
}


+ (double)declinationOfSunInRadians:(int)dayOfYear{
    return 0.4095 * sin(0.016906 * (dayOfYear - 80.086));
}

+ (double)timeDiffInHoursForSunTravelsFromNoonToHorizontHeightX:(double)horizontHeightXInAngularMinutes latitude:(double)latitudeInDegrees declinationOfSun:(double)declinationOfSunInRadians {

    double horizontHeightXInRadians = (horizontHeightXInAngularMinutes / 60) * M_PI / 180.0;
    double latitudeInRadians = M_PI * latitudeInDegrees / 180.0;

    return 12* acos( (sin(horizontHeightXInRadians) - sin(latitudeInRadians) * sin(declinationOfSunInRadians) ) / ( cos(latitudeInRadians) * cos(declinationOfSunInRadians) )  )/M_PI;
}

+ (double)sunSwitchInHoursTrueLocalTime:(double)timeDiffNoonToSunSwitch isSunrise:(BOOL)isSunrise{
    return 12 + (isSunrise ? - timeDiffNoonToSunSwitch : timeDiffNoonToSunSwitch);
}

+ (double)sunSwitchInHoursMeanLocalTime:(double)sunSwitchInHoursTrueLocalTime dayOfYear:(double)dayOfYear{
    return sunSwitchInHoursTrueLocalTime - (-0.171 * sin(0.0337 * dayOfYear + 0.465) - 0.1299 * sin(0.01787 * dayOfYear - 0.168));
}

+ (double)sunSwitchWithSunriseMeanLocalTime:(double)sunSwitchInHoursMeanLocalTime longitude:(double)longitudeInDegrees timezoneCorrection:(double)timeZoneOffsetHours{
    return sunSwitchInHoursMeanLocalTime + (longitudeInDegrees / 15) + timeZoneOffsetHours;
}
@end