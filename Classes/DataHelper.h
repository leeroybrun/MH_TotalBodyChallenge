//
//  DataHelper.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "MHAPI.h"

#import "Workout.h"
#import "Week.h"
#import "Day.h"
#import "Exercice.h"

@interface DataHelper : NSObject

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

+(id)sharedManager;

-(NSMutableArray*)getWorkouts;
-(Workout*)getWorkoutDetails:(Workout *)workout;
-(Day*)getDayDetails:(Day *)day;
-(void)downloadAllContent;
-(NSURL *)applicationDocumentsDirectory;
-(NSURL*)downloadVideo:(NSString *)videoUrl;

@end
