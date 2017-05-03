//
//  Vehicle+CoreDataClass.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VehicleLocation;
@class User;

@interface Vehicle : NSManagedObject

@property (nullable, copy, nonatomic) NSString *color;
@property (nullable, copy, nonatomic) NSString *foto;
@property (nullable, copy, nonatomic) NSString *make;
@property (nullable, copy, nonatomic) NSString *model;
@property (nullable, copy, nonatomic) NSString *vin;
@property (nullable, copy, nonatomic) NSString *year;
@property (nonatomic) int64_t vehicleid;
@property (nullable, retain, nonatomic) VehicleLocation *vehicleLocation;
@property (nullable, nonatomic) User *user;

@end

