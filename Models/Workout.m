//
//  Workout.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 04.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "Workout.h"
#import "Week.h"
#import "Day.h"
#import "XPathQuery.h"

@implementation Workout

+(NSMutableArray*)getWorkouts {
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
            workout.with = [[[workout with] lowercaseString] stringByReplacingOccurrencesOfString: @"with" withString:@""];
            workout.with = [[workout with] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            workout.with = [[workout with] capitalizedString];
            workout.with = [NSString stringWithFormat:@"with %@", workout.with];
            
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

-(NSMutableArray*)getWeeksAndDays {
    // Get data from webpage
    NSURL *url = [NSURL URLWithString:self.url];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    // Parse weeks nodes
    NSArray *weeksNodes = PerformHTMLXPathQuery(htmlData, @"//div[contains(@class,'calendarRow')]");
    
    // Loop over each weeks
    for (NSDictionary *weekNode in weeksNodes) {
        Week *week = [Week init];
        NSArray *node = [[NSArray alloc] init];
        
        // Get node XML content and convert it to NSData
        NSData* weekNodeContent = [[weekNode objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
        
        // Search for week number
        node = PerformHTMLXPathQuery(weekNodeContent, @"//li[@class='week']");
        if([node count] > 0) {
            week.name = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Week days
            NSArray *daysNodes = PerformHTMLXPathQuery(weekNodeContent, @"//li[@class='info']/div[contains(@class,'col')]");
            
            NSNumber *dayI = [[NSNumber init] initWithInt:1];
            for (NSDictionary *dayNode in daysNodes) {
                Day *day = [Day init];
                
                dayI = [NSNumber numberWithInt:[dayI intValue] + 1];
                day.num = dayI;
                
                // Get node XML content and convert it to NSData
                NSData* dayNodeContent = [[dayNode objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
                
                // Day url
                node = PerformHTMLXPathQuery(dayNodeContent, @"//a");
                day.url = [[[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"] objectForKey:@"href"];
                
                // Day image
                node = PerformHTMLXPathQuery(dayNodeContent, @"//img[@class='thumb']");
                day.imageUrl = [[[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"] objectForKey:@"src"];
                
                // Day title
                node = PerformHTMLXPathQuery(dayNodeContent, @"//div[@class='caption']");
                day.title = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
                
                [week.days addObject:day];
            }
            
            [self.weeks addObject:week];
        }
    }
    
    return self.weeks;
}

@end
