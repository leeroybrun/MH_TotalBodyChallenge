//
//  WorkoutTableViewCell.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 06.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "WorkoutTableViewCell.h"

@implementation WorkoutTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int oldImageViewWidth = self.imageView.frame.origin.x+self.imageView.frame.size.width;
    int newImageViewWidth = 91;
    self.imageView.frame = CGRectMake(0,0,newImageViewWidth,79);
    
    // Difference between old and new image size (and margin)
    int diff = newImageViewWidth-oldImageViewWidth;
    
    // We move and resize the labels regarding the new image size/position
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x+diff, self.textLabel.frame.origin.y, self.textLabel.frame.size.width-diff,self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x+diff, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width-diff,self.detailTextLabel.frame.size.height);
}

@end
