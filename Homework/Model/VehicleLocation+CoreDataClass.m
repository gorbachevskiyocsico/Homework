//
//  VehicleLocation+CoreDataClass.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "VehicleLocation+CoreDataClass.h"

@implementation VehicleLocation

- (CLLocation *)location {
    
    return [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lon];
}

@dynamic vehicleid;
@dynamic lon;
@dynamic lat;
@dynamic vehicle;

@end
