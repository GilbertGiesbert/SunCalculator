//
// Created by iOS Entwickler on 30.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "SunCalculatorV2.h"
#import "DateTool.h"


@implementation SunCalculatorV2


+ (double) getMeanSolarNoonWithJulianDayCount:(double)julianDayCount westernLongitude:(double)westernLongitude{

    return westernLongitude / 360.0 + julianDayCount;
}

+ (double) getSolarMeanAnomaly:(double)meanSolarNoon{
    return fmod((357.5291 + 0.98560028 * meanSolarNoon), 360);
}

+ (double)getEquationOfTheCenter:(double)solarMeanAnomaly{
    return 1.9148 * sin(solarMeanAnomaly) + 0.0200 * sin(2*solarMeanAnomaly) + 0.0003 * sin(3*solarMeanAnomaly);
}

+ (double)getEclipticLongitudeWithSolarMeanAnomaly:(double)solarMeanAnomaly equationOfTheCenter:(double)equationOfTheCenter{
    return fmod((solarMeanAnomaly + equationOfTheCenter + 180 + 102.9372), 360);
}

+ (double)getSolarTransitWithMeanSolarNoon:(double)meanSolarNoon solarMeanAnomaly:(double)solarMeanAnomaly epilipticLongitude:(double)epilipticLongitude{
    return 2451545.0 + meanSolarNoon - (0.0053 * sin(solarMeanAnomaly) - 0.0069*sin(2*epilipticLongitude));
}

+ (double)getDeclinationOfTheSun:(double)epilepticLongitude{
    return asin(sin(epilepticLongitude) * sin(23.44));
}

+ (double)getHourAngleWithNorthLatitude:(double)northLatitude declinationOfTheSun:(double)declinationOfTheSun{
    return acos(  (sin(-0.83) - sin(northLatitude) * sin(declinationOfTheSun)) / (cos(northLatitude) * cos(declinationOfTheSun))   );
}

+ (double)getJulianDateOfSunriseWithSolarTransit:(double)solarTransit hourAngle:(double)hourAngle{
    return solarTransit - hourAngle / 360.0;
}

+ (NSString *)getSunriseForYear:(int)year month:(int)month day:(int)day latitude:(double)latitude longitude:(double)longitude{

    NSInteger julianDayCount = [DateTool getJulianDayCountForYear:year month:month day:day];
    NSLog(@"julianDayCount: %d", julianDayCount);


    double julianDayCountExact = julianDayCount + JULIAN_DAY_COUNT_FOR_LEAP_SECONDS;
    NSLog(@"julianDayCountExact: %f", julianDayCountExact);

    double meanSolarNoon = [self getMeanSolarNoonWithJulianDayCount:julianDayCountExact westernLongitude:longitude];
    NSLog(@"meanSolarNoon: %f", meanSolarNoon);

    double solarMeanAnomaly = [self getSolarMeanAnomaly:meanSolarNoon];
    NSLog(@"solarMeanAnomaly: %f", solarMeanAnomaly);

    double equationOfTheCenter = [self getEquationOfTheCenter:solarMeanAnomaly];
    NSLog(@"equationOfTheCenter: %f", equationOfTheCenter);

    double epilepticLongitude = [self getEclipticLongitudeWithSolarMeanAnomaly:solarMeanAnomaly equationOfTheCenter:equationOfTheCenter];
    NSLog(@"epilepticLongitude: %f", epilepticLongitude);

    double solarTransit = [self getSolarTransitWithMeanSolarNoon:meanSolarNoon solarMeanAnomaly:solarMeanAnomaly epilipticLongitude:epilepticLongitude];
    NSLog(@"solarTransit: %f", solarTransit);

    double declinationOfTheSun = [self getDeclinationOfTheSun:epilepticLongitude];
    NSLog(@"declinationOfTheSun: %f", declinationOfTheSun);

    double hourAngle = [self getHourAngleWithNorthLatitude:latitude declinationOfTheSun:declinationOfTheSun];
    NSLog(@"hourAngle: %f", hourAngle);

    double julianDaysSunrise = [self getJulianDateOfSunriseWithSolarTransit:solarTransit hourAngle:hourAngle];
    NSLog(@"julianDaysSunrise: %f", julianDaysSunrise);

    return [NSString stringWithFormat: @"%f", julianDaysSunrise];

}


@end