//
//  NSDate+Converter.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 27/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Converter)

+ (NSInteger)hoursSinceDate:(NSDate *)sinceDate;
+ (NSInteger)hoursSinceDate:(NSDate *)sinceDate toDate:(NSDate *)toDate;

+ (NSInteger)secondsSinceDate:(NSDate *)sinceDate;
+ (NSInteger)secondsSinceDate:(NSDate *)sinceDate toDate:(NSDate *)toDate;

@end
