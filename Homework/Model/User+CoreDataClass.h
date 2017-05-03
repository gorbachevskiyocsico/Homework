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

@property (nonatomic) NSNumber *userid;
@property (retain, nonatomic) Owner *owner;
@property (retain, nonatomic) NSSet<Vehicle *> *vehicles;
@property (retain, nonatomic) NSDate *vehicleUpdateTime;

@end
