//
//  VideoPlayerViewController.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 08.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVKit;
@import AVFoundation;

@interface VideoPlayerViewController : AVPlayerViewController

@property (copy, nonatomic) NSString *videoUrl;

-(void)setVideoUrl:(NSString *)videoUrl;
-(void)playVideo;

@end
