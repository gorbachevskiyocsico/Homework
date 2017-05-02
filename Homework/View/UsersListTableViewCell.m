//
//  UsersListTableViewCell.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 27/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "UsersListTableViewCell.h"
#import "User+CoreDataClass.h"
#import "Owner+CoreDataClass.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface UsersListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation UsersListTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _user = nil;
}

- (void)setUser:(User *)user {
    
    _user = user;
    
    self.userLabel.text = user.owner.fullname;
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:self.user.owner.foto]];
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userImageView.layer.borderWidth = 0.5f;
}

@end
