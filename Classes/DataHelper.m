//
//  DataHelper.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper

@synthesize managedObjectContext;

#pragma mark Singleton Methods

+(id)sharedManager {
    static DataHelper *sharedDataHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataHelper = [[self alloc] init];
    });
    return sharedDataHelper;
}

-(NSArray*)getWorkouts {
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Workout" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count] == 0) {
        NSMutableArray *workouts = [MHAPI getWorkouts];
        
        for(NSMutableDictionary *workoutDict in workouts) {
            Workout *workout = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"Workout"
                                              inManagedObjectContext:managedObjectContext];
            workout.url = [workoutDict objectForKey:@"url"];
            workout.title = [workoutDict objectForKey:@"title"];
            workout.num = [workoutDict objectForKey:@"num"];
            workout.with = [workoutDict objectForKey:@"with"];
            workout.imageUrl = [workoutDict objectForKey:@"imageUrl"];
        }
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }

    return fetchedObjects;
}

-(Workout*)getWorkoutDetails:(Workout *)workout {
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Workout" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", workout.url];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count] == 0) {
        [NSException raise:@"Cannot fetch details, workout not in DB" format:@"no workout in DB for : %@ %@", workout.title, workout.url];
    } else {
        workout = [fetchedObjects objectAtIndex:0];
    }
    
    if([workout detailsFetched] == NO) {
        NSLog(@"Workout details needs to be fetched...");
        
        NSMutableDictionary *workoutDict = [MHAPI getWorkoutDetails:workout.url];
        
        workout.desc = [workoutDict objectForKey:@"desc"];
        
        for(NSMutableDictionary *weekDict in [workoutDict objectForKey:@"weeks"]) {
            Week *week = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Week"
                                inManagedObjectContext:managedObjectContext];
            
            week.name = [weekDict objectForKey:@"name"];
            week.num = [weekDict objectForKey:@"num"];
            
            [week setWorkout:workout];
            [workout addWeeksObject:week];
            
            for(NSMutableDictionary *dayDict in [weekDict objectForKey:@"days"]) {
                Day *day = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Day"
                              inManagedObjectContext:managedObjectContext];
                
                day.num = [dayDict objectForKey:@"num"];
                day.name = [dayDict objectForKey:@"name"];
                day.title = [dayDict objectForKey:@"title"];
                day.url = [dayDict objectForKey:@"url"];
                day.imageUrl = [dayDict objectForKey:@"imageUrl"];
                
                [week addDaysObject:day];
                [day setWeek:week];
            }
        }
        
        workout.detailsFetched = YES;
        
        NSLog(@"OK!");
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        workout = [fetchedObjects objectAtIndex:0];
    }
    
    return workout;
}

-(Day*)getDayDetails:(Day *)day {
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", day.url];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count] == 0) {
        [NSException raise:@"Cannot get details, day not in DB" format:@"no day in DB for : %@ %@", day.name, day.url];
    } else {
        day = [fetchedObjects objectAtIndex:0];
    }
    
    if([day detailsFetched] == NO) {
        NSLog(@"Day details needs to be fetched...");
        
        NSMutableDictionary *dayDict = [MHAPI getDayDetails:day.url];
        
        day.desc = [dayDict objectForKey:@"desc"];
        
        for(NSMutableDictionary *exDict in [dayDict objectForKey:@"exercices"]) {
            Exercice *exercice = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Exercice"
                          inManagedObjectContext:managedObjectContext];
            
            exercice.name = [exDict objectForKey:@"name"];
            exercice.desc = [exDict objectForKey:@"desc"];
            exercice.additionalDesc= [exDict objectForKey:@"additionalDesc"];
            exercice.nbSets = [exDict objectForKey:@"nbSets"];
            exercice.nbReps = [exDict objectForKey:@"nbReps"];
            exercice.nbRest = [exDict objectForKey:@"nbRest"];
            exercice.imageUrl = [exDict objectForKey:@"imageUrl"];
            exercice.videoId = [exDict objectForKey:@"videoId"];
            
            [exercice setDay:day];
            [day addExercicesObject:exercice];
        }
        
        day.detailsFetched = YES;
        
        NSLog(@"OK!");
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        day = [fetchedObjects objectAtIndex:0];
    }
    
    return day;
}


-(void)downloadAllContent {
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSMutableArray *workouts = [self getWorkouts];
    for(Workout *eWorkout in workouts) {
        Workout *workout = [self getWorkoutDetails:eWorkout];
        
        [imageUrls addObject:[NSURL URLWithString:[workout imageUrl]]];
        
        for(Week *week in workout.weeks) {
            for(Day *eDay in week.days) {
                Day *day = [self getDayDetails:eDay];
                
                [imageUrls addObject:[NSURL URLWithString:[day imageUrl]]];
                
                for(Exercice *exercice in day.exercices) {
                    [imageUrls addObject:[NSURL URLWithString:[exercice imageUrl]]];
                }
            }
        }
    }
    
    // Prefetch all images
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageUrls];
    
    // Prefetch all videos
    // http://stackoverflow.com/a/18357918/1160800
    // http://www.hpique.com/2014/03/how-to-cache-server-responses-in-ios-apps/
    // http://nshipster.com/nsurlcache/
}

@end
