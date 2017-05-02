//
//  NetworkManager.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

#define AppDomain [NSString stringWithFormat:@"%@Domain", [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleExecutableKey]]

@interface NetworkManager()

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

@end

@implementation NetworkManager

+ (instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype) initUniqueInstance {
    
    [self loadRequestManager];
    return [super init];
}

- (void)loadRequestManager
{
    self.requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrlString]];
    self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.requestManager.requestSerializer setTimeoutInterval:20.0f];
}

#pragma mark - API methods

- (void)getUsersListWithSuccess:(void (^)(NSArray *responseArray))success
                        failure:(void (^)(NSError *error))failure {
    
    [self.requestManager GET:@"?op=list" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            if (json) {
                
                id data = [json valueForKey:@"data"];
                
                if ([data isKindOfClass:[NSArray class]]) {
                    
                    success((NSArray *)data);
                }
            } else {
                
                NSString *receivedDataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                failure([self.class errorWithDescription:receivedDataString]);
            }
            
        } else {
            
            failure([self.class errorWithDescription:@"null data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

- (void)getVehiclesLocationWithUserid:(NSInteger)userid
                              success:(void (^)(NSArray *responseArray))success
                              failure:(void (^)(NSError *error))failure {
    
    [self.requestManager GET:[NSString stringWithFormat:@"?op=getlocations&userid=%li", userid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            if (json) {
                
                id data = [json valueForKey:@"data"];
                
                if ([data isKindOfClass:[NSArray class]]) {
                    
                    success((NSArray *)data);
                }
            } else {
                
                NSString *receivedDataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                failure([self.class errorWithDescription:receivedDataString]);
            }
            
        } else {
            
            failure([self.class errorWithDescription:@"null data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

#pragma mark - Google Directions API

- (void)getDirectionsWithFromSource:(CLLocation *)sourceLocation
                      toDestination:(CLLocation *)destinationLocation
                            success:(void (^)(NSDictionary *result))success
                            failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *requestManager = [[AFHTTPSessionManager alloc] init];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&key=%@", sourceLocation.coordinate.latitude,  sourceLocation.coordinate.longitude, destinationLocation.coordinate.latitude,  destinationLocation.coordinate.longitude, kGoogleApiKey];
    
    [requestManager GET:stringUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        if (error) {
            
            failure(error);
        } else {
            
            success(result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}

#pragma mark - NSError

+ (NSError *)errorWithDescription:(NSString *)description {
    
    return [NSError errorWithDomain:AppDomain
                               code:-1
                           userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(description, nil)}];
}

@end
