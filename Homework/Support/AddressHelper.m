//
//  AddressHelper.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 28/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "AddressHelper.h"
#import <CoreLocation/CoreLocation.h>

@implementation AddressHelper

+ (void)addressWithLocation:(CLLocation *)location completionHandler:(void (^)(NSString *address, NSError *error))completionHandler {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            
            completionHandler(nil, error);
            return;
        }
        
        CLPlacemark *placemark = placemarks.firstObject;
        
        if (placemark) {
            
            NSString *address = [NSString stringWithFormat:@"%@, %@, %@", placemark.country, placemark.locality, placemark.thoroughfare];

            completionHandler(address, nil);
            return;
        }
    }];
}

@end
