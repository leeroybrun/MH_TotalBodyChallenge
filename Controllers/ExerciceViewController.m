//
//  ExerciceViewController.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 09.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "ExerciceViewController.h"
#import "VideoPlayerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ExerciceViewController ()

@end

@implementation ExerciceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.exercice.name;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.exercice.imageUrl] placeholderImage:[UIImage imageNamed:@"barbell"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVideoPlayer"]) {
        VideoPlayerViewController *destViewController = segue.destinationViewController;
        destViewController.videoId = [self.exercice videoId];
    }
}

- (IBAction)playVideoBtnTouched:(id)sender {
    self.playerViewController = [[VideoPlayerViewController alloc] init];
    
    self.playerViewController.videoId = [self.exercice videoId];
    
    [self presentViewController:self.playerViewController animated:YES completion:^{}];
}

@end
