//
//  ExerciceViewController.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 09.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayerViewController.h"
#import "Exercice.h"

@interface ExerciceViewController : UIViewController

@property (strong, nonatomic) Exercice *exercice;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) VideoPlayerViewController *playerViewController;

- (IBAction)playVideoBtnTouched:(id)sender;

@end
