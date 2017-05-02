//
//  UsersListTableViewCell.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 27/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@class User;

@interface UsersListTableViewCell : BaseTableViewCell

@property (strong, nonatomic) User *user;

@end
