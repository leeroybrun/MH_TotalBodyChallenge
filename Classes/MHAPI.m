//
//  MHAPI.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 04.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "MHAPI.h"
#import "Workout.h"
#import "XPathQuery.h"

@implementation MHAPI

+ (MHAPI*)sharedInstance
{
    static MHAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[MHAPI alloc] init];
    });
    
    return _sharedInstance;
}

-(NSMutableArray*)getWorkouts {
    // Get data from webpage
    NSURL *url = [NSURL URLWithString:@"http://totalbodychallenge.menshealth.co.uk/http://totalbodychallenge.menshealth.co.uk/the-challenges"];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    // Parse workout nodes
    NSArray *workoutNodes = PerformHTMLXPathQuery(htmlData, @"//div[contains(@class,'challengesRow')]/div[contains(@class,'col')]/a");
    
    NSMutableArray *workouts = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *element in workoutNodes) {
        Workout *workout = [[Workout alloc] init];
        NSArray *node = [[NSArray alloc] init];
        
        // Get node XML content and convert it to NSData
        NSData* nodeContent = [[element objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
        
        // Get workout URL (first attribute of "a" node)
        workout.url = [[element objectForKey:@"nodeAttributeDictionary"] objectForKey:@"href"];

        // Search for workout title
        node = PerformHTMLXPathQuery(nodeContent, @"//div[@class='colHead']");
        if([node count] > 0) {
            workout.title = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Workout number
            node = PerformHTMLXPathQuery(nodeContent, @"//div[@class='colNum']");
            workout.num = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Workout "with ..."
            node = PerformHTMLXPathQuery(nodeContent, @"//div[@class='colName']");
            workout.with = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Workout image
            node = PerformHTMLXPathQuery(nodeContent, @"//img");
            NSDictionary *nodeAttributes = [[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"];
            workout.imageUrl = [nodeAttributes objectForKey:@"src"];
            
            // If workout image not set to src, we need to get it from data-src
            if(!workout.imageUrl) {
                NSString *baseURL = [nodeAttributes objectForKey:@"data-src-base"];
                NSString *dataSrc = [nodeAttributes objectForKey:@"data-src"];
                
                NSRange endRange = [dataSrc rangeOfString:@","];
                NSRange searchRange = NSMakeRange(5, endRange.location-5);
                
                if(searchRange.length > 0) {
                    NSString *matchedString = [dataSrc substringWithRange:searchRange];
                    
                    workout.imageUrl = [NSString stringWithFormat:@"%@%@", baseURL, matchedString];
                }
            }
            
            [workouts addObject:workout];
        }
    }
    
    return workouts;
}

@end
