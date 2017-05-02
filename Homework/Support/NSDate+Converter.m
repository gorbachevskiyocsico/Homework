//
//  NSDate+Converter.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 27/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "NSDate+Converter.h"

@implementation NSDate (Converter)

+ (NSInteger)hoursSinceDate:(NSDate *)sinceDate {
    
    return [self hoursSinceDate:sinceDate toDate:[NSDate date]];
}

+ (NSInteger)hoursSinceDate:(NSDate *)sinceDate toDate:(NSDate *)toDate {
    
    if (nil == sinceDate || nil == toDate) {
        
        return 0;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour) fromDate:sinceDate toDate:[NSDate date] options:0];
    return [components hour] + 1;
}

+ (NSInteger)secondsSinceDate:(NSDate *)sinceDate {
    
    return [self secondsSinceDate:sinceDate toDate:[NSDate date]];
}

+ (NSInteger)secondsSinceDate:(NSDate *)sinceDate toDate:(NSDate *)toDate {
    
    if (nil == sinceDate || nil == toDate) {
        
        return 0;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitSecond) fromDate:sinceDate toDate:[NSDate date] options:0];
    return [components second] + 1;
}

@end
