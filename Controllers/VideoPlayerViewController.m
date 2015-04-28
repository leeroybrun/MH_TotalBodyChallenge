//
//  VideoPlayerViewController.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 08.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "DataHelper.h"

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playVideo];
}

- (void)setVideoUrl:(NSString *)videoUrl {
    self.videoUrl = videoUrl;
}

-(void)playVideo {
    NSLog(@"Play URL: %@", self.videoUrl);
    
    DataHelper *data = [DataHelper sharedManager];
    
    NSURL* videoUrl = [data downloadVideo:self.videoUrl];
    
    self.player = [AVPlayer playerWithURL:videoUrl];
    [self.player play];
}

@end
