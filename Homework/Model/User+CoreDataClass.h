//
//  User+CoreDataClass.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Owner;
@class Vehicle;

@interface User : NSManagedObject

@property (nonatomic) int64_t userid;
@property (nullable, nonatomic, retain) Owner *owner;
@property (nullable, nonatomic, retain) NSSet<Vehicle *> *vehicles;
@property (nullable, nonatomic, retain) NSDate *vehicleUpdateTime;

@end
