//
//  WorkoutsTableViewController.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 05.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "ExercicesTableViewController.h"
#import "Exercice.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomTableViewCell.h"
#import "ExerciceViewController.h"

@interface ExercicesTableViewController ()


@end

@implementation ExercicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.day.title;
    
    [self.day getDetail];
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
    return [self.day.exercices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciceCell" forIndexPath:indexPath];
    
    Exercice *exercice = [self.day.exercices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [exercice name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ reps - %@ sets - %@ rest", [exercice reps], [exercice sets], [exercice rest]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:exercice.imageUrl] placeholderImage:[UIImage imageNamed:@"barbell"]];
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showExerciceDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ExerciceViewController *destViewController = segue.destinationViewController;
        destViewController.exercice = [self.day.exercices objectAtIndex:indexPath.row];
    }
}

@end
