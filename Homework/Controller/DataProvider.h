//
//  DataProvider.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Owner+CoreDataClass.h"
#import "VehicleLocation+CoreDataClass.h"

@interface DataProvider : NSObject

+ (instancetype)sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));
-(instancetype) copy __attribute__((unavailable("copy not available, call sharedInstance instead")));

- (NSArray <User *>*)getUsers;
- (User *)getUserWithUserid:(NSNumber *)userid;

- (Vehicle *)getVehicleWithVehicleid:(NSNumber *)vehicleid;

- (void)clearUsers;
- (void)clearVehicles;
- (void)clearVehicleLocations;

- (void)updateIfNeeded;

- (User *)saveUserFromDict:(NSDictionary *)dict;
- (Owner *)saveOwnerFromDict:(NSDictionary *)dict user:(User *)user;
- (Vehicle *)saveVehicleFromDict:(NSDictionary *)dict user:(User *)user;
- (VehicleLocation *)saveVehicleLocationFromDict:(NSDictionary *)dict;

- (void)saveUsersListDownloadTime;

@end
