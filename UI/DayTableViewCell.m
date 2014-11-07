//
//  WorkoutTableViewCell.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 06.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "DayTableViewCell.h"

@implementation DayTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int newImageViewWidth = 59;
    self.imageView.frame = CGRectMake(10,10,newImageViewWidth,59);//91x79
    
    int newTextLeftMargin = self.imageView.frame.origin.x + self.imageView.frame.size.width + 15;
    int olfTextLeftMargin = self.textLabel.frame.origin.x;
    
    // Difference between old and new image size (and margin)
    int diff = newTextLeftMargin-olfTextLeftMargin;
    
    // Rounded image
    self.imageView.layer.cornerRadius = newImageViewWidth / 2;
    self.imageView.clipsToBounds = YES;
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // We move and resize the labels regarding the new image size/position
    self.textLabel.frame = CGRectMake(newTextLeftMargin, self.textLabel.frame.origin.y, self.textLabel.frame.size.width-diff,self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(newTextLeftMargin, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width-diff,self.detailTextLabel.frame.size.height);
}

@end
