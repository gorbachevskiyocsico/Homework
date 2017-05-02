//
//  Owner+CoreDataClass.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Owner+CoreDataClass.h"

@implementation Owner

- (NSString *)fullname {
    
    return [NSString stringWithFormat:@"%@ %@", self.name, self.surname];
}

@dynamic foto;
@dynamic name;
@dynamic surname;
@dynamic user;

@end
