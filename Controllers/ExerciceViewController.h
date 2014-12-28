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

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *exerciceName;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UILabel *exerciceReps;
@property (weak, nonatomic) IBOutlet UILabel *exerciceSets;
@property (weak, nonatomic) IBOutlet UILabel *exerciceRest;
@property (weak, nonatomic) IBOutlet UITextView *exerciceDesc;

@property (strong, nonatomic) VideoPlayerViewController *playerViewController;

- (IBAction)playVideoBtnTouched:(id)sender;

@end
