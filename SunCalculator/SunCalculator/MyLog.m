//
// Created by iOS Entwickler on 31.03.16.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "MyLog.h"


@implementation MyLog


+ (void)log:(NSString *)format,...{

    va_list args;
    va_start(args, format);
    NSString *log = [[NSString alloc] initWithFormat:format arguments:args];
    NSLog(@"%@", log);
}

@end