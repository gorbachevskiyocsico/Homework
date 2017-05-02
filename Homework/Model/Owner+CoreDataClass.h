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

@property (nullable, nonatomic, copy) NSString *foto;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *surname;
@property (nullable, nonatomic, copy, readonly) NSString *fullname;
@property (nullable, nonatomic) User *user;

@end
