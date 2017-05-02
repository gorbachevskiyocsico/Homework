//
//  NetworkManager.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));
-(instancetype) copy __attribute__((unavailable("copy not available, call sharedInstance instead")));

- (void)getUsersListWithSuccess:(void (^)(NSArray *responseArray))success
                        failure:(void (^)(NSError *error))failure;

- (void)getVehiclesLocationWithUserid:(NSInteger)userid
                              success:(void (^)(NSArray *responseArray))success
                              failure:(void (^)(NSError *error))failure;

- (void)getDirectionsWithFromSource:(CLLocation *)sourceLocation
                      toDestination:(CLLocation *)destinationLocation
                            success:(void (^)(NSDictionary *result))success
                            failure:(void (^)(NSError *error))failure;

@end
