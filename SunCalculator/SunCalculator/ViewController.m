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


@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_latitude;
@property (weak, nonatomic) IBOutlet UITextField *tf_longitude;
@property (weak, nonatomic) IBOutlet UITextField *tf_dateDay;
@property (weak, nonatomic) IBOutlet UITextField *tf_dateMonth;
@property (weak, nonatomic) IBOutlet UITextField *tf_dateYear;
@property (weak, nonatomic) IBOutlet UILabel *lb_result;

@end

@implementation ViewController

-(void)viewDidLoad{
    
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
    self.lb_result.text = [NSString stringWithFormat:@"app started at %@", [dateFormat stringFromDate:now]];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.tf_latitude ||
       textField == self.tf_longitude ||
       textField == self.tf_dateYear ||
       textField == self.tf_dateMonth ||
       textField == self.tf_dateDay){
        
        [textField resignFirstResponder];
        return YES;
        
    }
    return NO;
}

- (IBAction)bt_calculate:(UIButton *)sender {
    
    [_tf_latitude endEditing:YES];
    [_tf_longitude endEditing:YES];
    [_tf_dateYear endEditing:YES];
    [_tf_dateMonth endEditing:YES];
    [_tf_dateDay endEditing:YES];

    [self updateResultText];
}



- (void)updateResultText {

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

        self.lb_result.text = @"can't calc\ninputs must be valid numbers";
        return;
    }

    double latitude = [latitudeString doubleValue];
    double longitude = [longitudeString doubleValue];
    NSInteger year = [yearString intValue];
    NSInteger month = [monthString intValue];
    NSInteger day = [dayString intValue];

    if(latitude < -180 || longitude < -180 || latitude > 180 || longitude > 180){

        self.lb_result.text = @"can't calc\nlat & long must be in range [ -180 ; 180 ]";
        return;

    }

    if(![DateTool validateDateForYear:year month:month day:day]){

        self.lb_result.text = @"can't calc\ndate must exist";
        return;
    }


    NSDate *inputDate = [DateTool getDateForYear:year month:month day:day];
    NSString *sunrise = [SunCalculatorV1 calcSunriseForDate:inputDate latitude:latitude longitude:longitude];
    NSString *sunset = [SunCalculatorV1 calcSunsetForDate:inputDate latitude:latitude longitude:longitude];

    NSString *resultText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", inputsString, sunrise, sunset];

    self.lb_result.text = resultText;

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