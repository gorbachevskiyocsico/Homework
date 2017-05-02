//
//  MarkerView.h
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 27/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vehicle;

@interface MarkerView : UIView

@property (strong, nonatomic) Vehicle *vehicle;

@property (weak, nonatomic) IBOutlet UIImageView *markerImageView;
@property (weak, nonatomic) IBOutlet UILabel *markerDescriptionLabel;

@end
