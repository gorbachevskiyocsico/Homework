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

@property (copy, nonatomic) NSString *foto;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *surname;
@property (copy, nonatomic, readonly) NSString *fullname;
@property (nonatomic) User *user;

@end
