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

@property (nullable, nonatomic, copy) NSString *color;
@property (nullable, nonatomic, copy) NSString *foto;
@property (nullable, nonatomic, copy) NSString *make;
@property (nullable, nonatomic, copy) NSString *model;
@property (nullable, nonatomic, copy) NSString *vin;
@property (nullable, nonatomic, copy) NSString *year;
@property (nonatomic) int64_t vehicleid;
@property (nullable, nonatomic, retain) VehicleLocation *vehicleLocation;
@property (nullable, nonatomic) User *user;

@end

