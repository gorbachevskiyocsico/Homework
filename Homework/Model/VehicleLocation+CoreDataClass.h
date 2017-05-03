//
//  VehicleLocation+CoreDataClass.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@import CoreLocation;
@class Vehicle;

@interface VehicleLocation : NSManagedObject

@property (strong, nonatomic, readonly) CLLocation *location;

@property (nonatomic) NSNumber *vehicleid;
@property (nonatomic) double lon;
@property (nonatomic) double lat;
@property (retain, nonatomic) Vehicle *vehicle;

@end

