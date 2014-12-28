//
//  WorkoutsTableViewController.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 05.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "WeekViewController.h"
#import "DayViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomTableViewCell.h"
#import "Workout.h"
#import "Week.h"
#import "Day.h"

@interface WeekViewController ()


@end

@implementation WeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:nil];
    
    NSLog(@"Entered view for %@", self.week.name);
    
    self.navigationItem.title = self.week.name;
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
    return [[self.week days] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
    
    Day *day = [self.week.days objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [day name];
    cell.detailTextLabel.text = [day title];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[day imageUrl]] placeholderImage:[UIImage imageNamed:@"barbell"]];
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDayDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DayViewController *destViewController = segue.destinationViewController;
        
        destViewController.day = [self.week.days objectAtIndex:indexPath.row];
    }
}

@end
