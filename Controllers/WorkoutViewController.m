//
//  WorkoutDetailsViewController.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 15.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "WorkoutViewController.h"
#import "WeekViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomTableViewCell.h"
#import "DataHelper.h"
#import "Workout.h"
#import "Week.h"
#import "Day.h"

@interface WorkoutViewController ()

@end

@implementation WorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:nil];
    
    DataHelper *data = [DataHelper sharedManager];
    
    NSLog(@"Entered view for %@", self.workout.title);
    
    self.navigationItem.title = self.workout.title;
    
    self.workout = [data getWorkoutDetails:self.workout];
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
    return [self.workout.weeks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekCell" forIndexPath:indexPath];
    
    Week *week = [self.workout.weeks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [week name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [week num]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[week.days objectAtIndex:0] imageUrl]] placeholderImage:[UIImage imageNamed:@"barbell"]];
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWeekDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WeekViewController *destViewController = segue.destinationViewController;
        
        destViewController.week = [self.workout.weeks objectAtIndex:indexPath.row];
    }
}

@end
