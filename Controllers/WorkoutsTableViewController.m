//
//  WorkoutsTableViewController.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 05.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "WorkoutsTableViewController.h"
#import "Workout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WorkoutTableViewCell.h"
#import "DaysTableViewController.h"

@interface WorkoutsTableViewController ()


@end

@implementation WorkoutsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.workouts = [Workout getWorkouts];
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
    WorkoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];
    
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
        DaysTableViewController *destViewController = segue.destinationViewController;
        destViewController.workout = [self.workouts objectAtIndex:indexPath.row];
    }
}

@end
