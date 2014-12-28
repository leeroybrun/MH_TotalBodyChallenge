//
//  WorkoutsTableViewController.h
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 05.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutsViewController : UITableViewController

@property (strong, nonatomic) NSArray *workouts;

- (IBAction)offlineSync:(UIBarButtonItem *)sender;

@end
