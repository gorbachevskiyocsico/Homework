//
//  DataProvider.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "DataProvider.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Vehicle+CoreDataClass.h"
#import "UserListCache+CoreDataClass.h"

@implementation DataProvider

+ (instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype) initUniqueInstance {
    
    return [super init];
}

#pragma mark - Private methods

- (void)saveContext
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

- (User *)saveUserFromDict:(NSDictionary *)dict {

    id userid = [dict valueForKey:@"userid"];
    
    if (nil == userid) {
        
        return nil;
    }
    
    User *user = [User MR_createEntity];
    
    if ([userid isKindOfClass:[NSNumber class]]) {
        
        user.userid = [userid intValue];
    }
    
    id owner = [dict valueForKey:@"owner"];
    
    if ([owner isKindOfClass:[NSDictionary class]]) {
        
        user.owner = [self saveOwnerFromDict:(NSDictionary *)owner user:user];
    }
    
    id vehicles = [dict valueForKey:@"vehicles"];
    
    if ([vehicles isKindOfClass:[NSArray class]]) {
        
        if ([(NSArray *)vehicles count] > 0) {
            
            NSMutableSet *tempVehicles = [NSMutableSet new];
            
            for (NSDictionary *vehicle in (NSArray *)vehicles) {
                
                [tempVehicles addObject:[self saveVehicleFromDict:vehicle user:user]];
            }
            
            user.vehicles = [[NSSet alloc] initWithSet:tempVehicles];
        } else {
            
            user.vehicles = [[NSSet alloc] initWithArray:@[]];
        }
    }
    
    user.vehicleUpdateTime = [NSDate date];
    
    [self saveContext];
    
    return user;
}

- (Owner *)saveOwnerFromDict:(NSDictionary *)dict user:(User *)user {
    
    Owner *owner = [Owner MR_createEntity];
    
    owner.name = [dict valueForKey:@"name"];
    owner.surname = [dict valueForKey:@"surname"];
    owner.foto = [dict valueForKey:@"foto"];
    
    owner.user = user;
    
    [self saveContext];
    
    return owner;
}

- (Vehicle *)saveVehicleFromDict:(NSDictionary *)dict user:(User *)user {
    
    Vehicle *vehicle = [Vehicle MR_createEntity];
    
    id vehicleid = [dict valueForKey:@"vehicleid"];
    
    if ([vehicleid isKindOfClass:[NSNumber class]]) {
        
        vehicle.vehicleid = [vehicleid longValue];
    }
    
    vehicle.color = [dict valueForKey:@"color"];
    vehicle.foto = [dict valueForKey:@"foto"];
    vehicle.make = [dict valueForKey:@"make"];
    vehicle.model = [dict valueForKey:@"model"];
    vehicle.vin = [dict valueForKey:@"vin"];
    vehicle.year = [dict valueForKey:@"year"];
    
    vehicle.user = user;
    
    [self saveContext];
    
    return vehicle;
}

- (VehicleLocation *)saveVehicleLocationFromDict:(NSDictionary *)dict {
    
    if ([[dict valueForKey:@"lon"] isKindOfClass:[NSNull class]] ||
        [[dict valueForKey:@"lat"] isKindOfClass:[NSNull class]] ||
        [[dict valueForKey:@"vehicleid"] isKindOfClass:[NSNull class]]) {
        
        return nil;
    }
    
    VehicleLocation *vehicleLocation = [VehicleLocation MR_createEntity];
    
    id vehicleid = [dict valueForKey:@"vehicleid"];
    
    if ([vehicleid isKindOfClass:[NSNumber class]]) {
        
        vehicleLocation.vehicleid = [vehicleid longValue];
    }

    id lon = [dict valueForKey:@"lon"];
    
    if ([lon isKindOfClass:[NSNumber class]]) {
        
        vehicleLocation.lon = [lon doubleValue];
    }
    
    id lat = [dict valueForKey:@"lat"];
    
    if ([lat isKindOfClass:[NSNumber class]]) {
        
        vehicleLocation.lat = [lat doubleValue];
    }
    
    Vehicle *vehicle = [self getVehicleWithVehicleid:vehicleLocation.vehicleid];
    
    vehicle.vehicleLocation = vehicleLocation;
    
    vehicle.user.vehicleUpdateTime = [NSDate date];
    
    [self saveContext];
    
    return vehicleLocation;
}

#pragma mark - Interface methods

- (void)updateIfNeeded {
    
    NSInteger hours = [NSDate hoursSinceDate:[self getUserListDownloadTime]];
    
    if (hours >= kHoursBetweenUpdateUsersList) {
        
        [self clearUsers];
    }
}

- (NSArray <User *>*)getUsers {
    
    return [[User MR_findAll] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        User *user1 = obj1;
        User *user2 = obj2;
        
        if ( user1.userid < user2.userid ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( user1.userid > user2.userid ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
}

- (User *)getUserWithUserid:(NSInteger)userid {
    
    return [User MR_findFirstByAttribute:@"userid" withValue:[NSNumber numberWithInteger:userid]];
}

- (void)clearUsers {
    
    [User MR_truncateAll];
    [self saveContext];
}

- (void)clearVehicleLocations {
    
    [VehicleLocation MR_truncateAll];
    [self saveContext];
}

- (Vehicle *)getVehicleWithVehicleid:(NSInteger)vehicleid {
    
    return [Vehicle MR_findFirstByAttribute:@"vehicleid" withValue:[NSNumber numberWithInteger:vehicleid]];
}

- (void)clearVehicles {
    
    [Vehicle MR_truncateAll];
    [self saveContext];
}

- (NSDate *)getUserListDownloadTime {
    
    UserListCache *userListCache = [UserListCache MR_findFirst];
    
    return userListCache.downloadTime;
}

- (void)saveUsersListDownloadTime {
    
    [self clearAllUserListDownloadTime];
    
    UserListCache *userListCache = [UserListCache MR_createEntity];
    
    userListCache.downloadTime = [NSDate date];
    
    [self saveContext];
}

- (void)clearAllUserListDownloadTime {
    
    [UserListCache MR_truncateAll];
    [self saveContext];
}

@end
