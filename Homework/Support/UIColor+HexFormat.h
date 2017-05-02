//
//  UIColor-MJGAdditions.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexFormat)

+ (UIColor*)colorWithHexValue:(NSString*)hex;

- (UIColor*)blackOrWhiteContrastingColor;
- (CGFloat)luminosity;
- (CGFloat)luminosityDifference:(UIColor*)otherColor;

@end
