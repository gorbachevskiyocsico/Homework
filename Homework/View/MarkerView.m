//
//  MarkerView.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 27/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "MarkerView.h"
#import "Vehicle+CoreDataClass.h"

@interface MarkerView()

@property (weak, nonatomic) IBOutlet UILabel *markerTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *markerColorView;

@end

@implementation MarkerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    }
    
    self.frame = CGRectMake(0, 0, 250, 110);
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
    self.markerImageView.layer.cornerRadius = 5.0f;
    self.markerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.markerImageView.layer.borderWidth = 0.5f;
    
    return self;
}

- (void)setVehicle:(Vehicle *)vehicle {
    
    _vehicle = vehicle;
    
    NSString *title = [NSString stringWithFormat:@"%@ %@", vehicle.make, vehicle.model];
    
    self.markerTitleLabel.text = title;
    
    self.markerColorView.backgroundColor = [UIColor colorWithHexValue:vehicle.color];
    self.markerColorView.layer.borderColor = [UIColor blackColor].CGColor;
    self.markerColorView.layer.borderWidth = 1.0f;
    self.markerColorView.layer.cornerRadius = 5.0f;
}

@end
