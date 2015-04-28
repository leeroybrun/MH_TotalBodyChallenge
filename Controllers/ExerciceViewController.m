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
    self.exerciceName.text = self.exercice.name;
    self.exerciceDesc.text = self.exercice.desc;
    self.exerciceReps.text = self.exercice.nbReps;
    self.exerciceSets.text = self.exercice.nbSets;
    self.exerciceRest.text = self.exercice.nbRest;
    
    if(self.exercice.videoId) {
        [self.videoButton setEnabled:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVideoPlayer"]) {
        VideoPlayerViewController *destViewController = segue.destinationViewController;
        destViewController.videoUrl = [self.exercice videoUrl];
    }
}

- (IBAction)playVideoBtnTouched:(id)sender {
    if(self.exercice.videoUrl) {
        self.playerViewController = [[VideoPlayerViewController alloc] init];
        
        self.playerViewController.videoUrl = [self.exercice videoUrl];
        
        [self presentViewController:self.playerViewController animated:YES completion:^{}];
    }
}

@end
