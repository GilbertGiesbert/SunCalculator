//
// Created by iOS Entwickler on 31.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MwxLogger_trace(args...) [MwxLogger trace:@"%@%s > %@", [self class], __FUNCTION__, [NSString stringWithFormat: args]]




@interface MyLog : NSObject

+ (void)log:(NSString *)format,...;

@end

#define MyLog(args...) [MyLog log:@"%s > %@", __FUNCTION__, [NSString stringWithFormat: args]]

