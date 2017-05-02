//
//  AddressHelper.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 28/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface AddressHelper : NSObject

+ (void)addressWithLocation:(CLLocation *)location completionHandler:(void (^)(NSString *address, NSError *error))completionHandler;

@end
