//
//  ViewController.m
//  SunCalculator
//
//  Created by iOS Entwickler on 24.03.16.
//  Copyright (c) 2016 iOS Entwickler. All rights reserved.
//


#import "ViewController.h"
#import "SunCalculatorV1.h"
#import "DateTool.h"
#import "SunCalculatorV2.h"
#import "MyLog.h"
#import "SunCalculatorV3.h"


@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_latitude;
@property (weak, nonatomic) IBOutlet UITextField *tf_longitude;
@property (weak, nonatomic) IBOutlet UITextField *tf_dateDay;
@property (weak, nonatomic) IBOutlet UITextField *tf_dateMonth;
@property (weak, nonatomic) IBOutlet UITextField *tf_dateYear;
@property (weak, nonatomic) IBOutlet UITextView *tv_result;
@property (strong, nonatomic) NSArray *textFields;

@end

@implementation ViewController

-(void)viewDidLoad{

    self.textFields = @[self.tf_latitude, self.tf_longitude, self.tf_dateDay, self.tf_dateMonth, self.tf_dateYear];
    
    self.tf_latitude.text = @"52.5";
    self.tf_longitude.text = @"-13.5";

    NSDate *now = [[NSDate alloc] init];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

    [dateFormat setDateFormat:@"dd"];
    self.tf_dateDay.text = [dateFormat stringFromDate:now];

    [dateFormat setDateFormat:@"MM"];
    self.tf_dateMonth.text = [dateFormat stringFromDate:now];

    [dateFormat setDateFormat:@"yyyy"];
    self.tf_dateYear.text = [dateFormat stringFromDate:now];

    [dateFormat setDateFormat:@"dd.MM.yyyy - hh:mm:ss"];
    self.tv_result.text = [NSString stringWithFormat:@"app started at %@", [dateFormat stringFromDate:now]];



}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{


    NSUInteger i = 0;
    for(UITextField *tf in self.textFields){

        if(tf == textField){

            BOOL isLast = i == ([self.textFields count] - 1);
            if(isLast){

                [textField resignFirstResponder];
                [self processInputs];

            }else{

                [self.textFields[++i] becomeFirstResponder];
            }
            return YES;
        }
        i++;
    }
    return NO;
}

- (IBAction)bt_calculate:(UIButton *)sender {
    
    [_tf_latitude endEditing:YES];
    [_tf_longitude endEditing:YES];
    [_tf_dateYear endEditing:YES];
    [_tf_dateMonth endEditing:YES];
    [_tf_dateDay endEditing:YES];

    NSString *result = [self processInputs];
    self.tv_result.text = result;
}


- (NSString *)processInputs {

    NSString *latitudeString = [self.tf_latitude.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *longitudeString = [self.tf_longitude.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *yearString = [self.tf_dateYear.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *monthString = [self.tf_dateMonth.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *dayString = [self.tf_dateDay.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *inputsString = [NSString stringWithFormat:@"inputs: latitude: %@; longitude: %@; year: %@; month: %@; day: %@", latitudeString, longitudeString, yearString, monthString, dayString];
    NSLog(@"%@", inputsString);

    NSString *regexValidDouble = @"^[-]{0,1}[0-9]+[.]{0,1}[0-9]*$";
    if(     ![self validate:latitudeString with:regexValidDouble] ||
            ![self validate:longitudeString with:regexValidDouble] ||
            ![self validate:yearString with:regexValidDouble] ||
            ![self validate:monthString with:regexValidDouble] ||
            ![self validate:dayString with:regexValidDouble]){

        return @"can't calc\ninputs must be valid numbers";
    }

    double latitude = [latitudeString doubleValue];
    double longitude = [longitudeString doubleValue];
    NSInteger year = [yearString intValue];
    NSInteger month = [monthString intValue];
    NSInteger day = [dayString intValue];

    if(latitude < -180 || longitude < -180 || latitude > 180 || longitude > 180){

        return @"can't calc\nlat & long must be in range [ -180 ; 180 ]";
    }

    if(![DateTool validateDateForYear:year month:month day:day]){

        return @"can't calc\ndate must exist";
    }


    NSDate *inputDate = [DateTool getDateForYear:year month:month day:day];
    NSString *julianDate = [NSString stringWithFormat:@"Julian date: %d", [DateTool getJulianDayCountFor:inputDate]];
    NSString *daysSince2000 = [NSString stringWithFormat:@"days since 2000: %d", [DateTool getDayCountSince2000For:inputDate]];
    NSString *dateToolInfo = [NSString stringWithFormat:@"DateTool\n%@\n%@", julianDate, daysSince2000];


    NSString *sunriseV1 = [SunCalculatorV1 calcSunriseForDate:inputDate latitude:latitude longitude:longitude];
    NSString *sunsetV1 = [SunCalculatorV1 calcSunsetForDate:inputDate latitude:latitude longitude:longitude];
    NSString *v1Info = [NSString stringWithFormat:@"V1\n%@\n%@", sunriseV1, sunsetV1];

    NSString *sunriseV2 = [SunCalculatorV2 calcSunriseForDate:inputDate latitude:latitude longitude:longitude];
    NSString *v2Info = [NSString stringWithFormat:@"V2\n%@", sunriseV2];

    NSString *sunriseAndSunsetV3 = [SunCalculatorV3 calcSunriseAndSunsetForDate:inputDate latitude:latitude longitude:longitude];
    NSString *v3Info = [NSString stringWithFormat:@"V3\n%@", sunriseAndSunsetV3];




    NSString *resultText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@", inputsString, dateToolInfo, v1Info, v2Info, v3Info];
    return resultText;
}

- (BOOL)validate:(NSString *)inputString with:(NSString *)regexString
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
        return NO;
    }else{
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:inputString
                                                            options:0
                                                              range:NSMakeRange(0, [inputString length])];
        return numberOfMatches > 0;
    }
}


@end