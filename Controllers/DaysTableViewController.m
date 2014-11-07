//
//  WorkoutsTableViewController.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 05.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "DaysTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Workout.h"
#import "Week.h"
#import "Day.h"

@interface DaysTableViewController ()


@end

@implementation DaysTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:nil];
    
    [self.workout getWeeksAndDays];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.workout.weeks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    Week *week = [self.workout.weeks objectAtIndex:section];
    return [[week days] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Week *week = [self.workout.weeks objectAtIndex:section];
    return [week name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
    
    Week *week = [self.workout.weeks objectAtIndex:indexPath.section];
    Day *day = [week.days objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [day title];
    cell.detailTextLabel.text = [day name];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[day imageUrl]] placeholderImage:[UIImage imageNamed:@"day-placeholder"]];
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
