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

@property (copy, nonatomic) NSString *color;
@property (copy, nonatomic) NSString *foto;
@property (copy, nonatomic) NSString *make;
@property (copy, nonatomic) NSString *model;
@property (copy, nonatomic) NSString *vin;
@property (copy, nonatomic) NSString *year;
@property (nonatomic) NSNumber *vehicleid;
@property (retain, nonatomic) VehicleLocation *vehicleLocation;
@property (nonatomic) User *user;

@end

