//
//  DataHelper.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "DataHelper.h"
#import "NSString+Hashes.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

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
            exercice.videoUrl = @"";
            
            [exercice fetchVideoUrl];
            
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

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

-(NSURL*)downloadVideo:(NSString *)videoUrl {
    NSURL *url = [NSURL URLWithString:videoUrl];
    
    NSString *filename = [videoUrl sha1];
    
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:filename];
    
    NSLog(@"Video cache path: %@", path);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"Video exists in local cache");
        return [NSURL fileURLWithPath:path];
    }
    else
    {
        NSLog(@"Video does not exists in local cache");
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully downloaded file to %@", path);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        [operation start];
        
        return url;
    }
}

-(void)downloadAllContent {
    NSMutableArray *imageUrls = [NSMutableArray array];
    NSMutableArray *videosUrls = [NSMutableArray array];
    
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
                    [videosUrls addObject:[exercice videoUrl]];
                }
            }
        }
    }
    
    // Prefetch all images
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageUrls];
    
    // Prefetch all videos
    for(NSString *videoUrl in videosUrls) {
        [self downloadVideo:videoUrl];
    }
}

@end
