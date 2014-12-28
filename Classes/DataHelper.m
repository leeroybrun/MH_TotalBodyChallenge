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
    [fetchRequest setEntity:entity];
    
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", workout];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSString *url = workout.url;
    
    if([fetchedObjects count] == 0) {
        [NSException raise:@"Workout not in DB" format:@"no workout in DB for : %@ %@", workout.title, workout.url];
    } else {
        workout = [fetchedObjects objectAtIndex:0];
    }
    
    if([workout detailsFetched] == NO) {
        NSLog(@"Workout details need to be fetched...");
        
        NSMutableDictionary *workoutDict = [MHAPI getWorkoutDetails:url];
        
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
        
        NSLog(@"Workout has %lu weeks", (unsigned long)[workout.weeks count]);
        NSLog(@"First workout week has %lu days", (unsigned long)[[[workout.weeks objectAtIndex:0] days] count]);
    }
    
    return workout;
}

@end
