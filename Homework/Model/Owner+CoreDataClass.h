//
//  Owner+CoreDataClass.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Owner : NSManagedObject

@property (nullable, copy, nonatomic) NSString *foto;
@property (nullable, copy, nonatomic) NSString *name;
@property (nullable, copy, nonatomic) NSString *surname;
@property (nullable, copy, nonatomic, readonly) NSString *fullname;
@property (nullable, nonatomic) User *user;

@end
