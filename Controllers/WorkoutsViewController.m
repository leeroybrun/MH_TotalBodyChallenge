//
//  WorkoutsTableViewController.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 05.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "WorkoutsViewController.h"
#import "DownloadStatusViewController.h"
#import "DataHelper.h"
#import "Workout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MZFormSheetController.h>
#import "CustomTableViewCell.h"
#import "WorkoutViewController.h"

@interface WorkoutsViewController ()


@end

@implementation WorkoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataHelper *data = [DataHelper sharedManager];
    
    self.workouts = [data getWorkouts];
}

- (IBAction)offlineSync:(UIBarButtonItem *)sender {
    DownloadStatusViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"dlStatusController"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.cornerRadius = 6.0;
    
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundBlurEffect:YES];
    [[MZFormSheetController sharedBackgroundWindow] setBlurRadius:4.0];
    
    // present form sheet with view controller
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];
    
    Workout *workout = [self.workouts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [workout title];
    cell.detailTextLabel.text = [workout with];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:workout.imageUrl] placeholderImage:[UIImage imageNamed:@"workout-placeholder"]];
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWorkoutDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WorkoutViewController *destViewController = segue.destinationViewController;
        destViewController.workout = [self.workouts objectAtIndex:indexPath.row];
    }
}

@end
