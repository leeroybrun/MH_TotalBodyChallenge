//
//  MHAPI.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 21.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "MHAPI.h"
#import "XPathQuery.h"

@implementation MHAPI

+(NSMutableArray*)getWorkouts {
    // Get data from webpage
    NSURL *url = [NSURL URLWithString:@"http://totalbodychallenge.menshealth.co.uk/http://totalbodychallenge.menshealth.co.uk/the-challenges"];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    // Parse workout nodes
    NSArray *workoutNodes = PerformHTMLXPathQuery(htmlData, @"//div[contains(@class,'challengesRow')]/div[contains(@class,'col')]/a");
    
    NSMutableArray *workouts = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *element in workoutNodes) {
        NSArray *node = [[NSArray alloc] init];
        
        NSString *workoutUrl = @"";
        NSString *workoutTitle = @"";
        NSNumber *workoutNum;
        NSString *workoutWith = @"";
        NSString *workoutImageUrl = @"";
        
        // Get node XML content and convert it to NSData
        NSData* nodeContent = [[element objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
        
        // Get workout URL (first attribute of "a" node)
        workoutUrl = [[element objectForKey:@"nodeAttributeDictionary"] objectForKey:@"href"];
        
        // Search for workout title
        node = PerformHTMLXPathQuery(nodeContent, @"//div[@class='colHead']");
        if([node count] > 0) {
            workoutTitle = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Workout number
            node = PerformHTMLXPathQuery(nodeContent, @"//div[@class='colNum']");
            workoutNum = [NSNumber numberWithInteger:[[[node objectAtIndex:0] objectForKey:@"nodeContent"] integerValue]];
            
            // Workout "with ..."
            node = PerformHTMLXPathQuery(nodeContent, @"//div[@class='colName']");
            
            workoutWith = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            workoutWith = [[workoutWith lowercaseString] stringByReplacingOccurrencesOfString: @"with" withString:@""];
            workoutWith = [workoutWith stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            workoutWith = [workoutWith capitalizedString];
            workoutWith = [NSString stringWithFormat:@"with %@", workoutWith];
            
            // Workout image
            node = PerformHTMLXPathQuery(nodeContent, @"//img");
            NSDictionary *nodeAttributes = [[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"];
            workoutImageUrl = [nodeAttributes objectForKey:@"src"];
            
            // If workout image not set to src, we need to get it from data-src
            if(!workoutImageUrl) {
                NSString *baseURL = [nodeAttributes objectForKey:@"data-src-base"];
                NSString *dataSrc = [nodeAttributes objectForKey:@"data-src"];
                
                NSRange endRange = [dataSrc rangeOfString:@","];
                NSRange searchRange = NSMakeRange(5, endRange.location-5);
                
                if(searchRange.length > 0) {
                    NSString *matchedString = [dataSrc substringWithRange:searchRange];
                    
                    workoutImageUrl = [NSString stringWithFormat:@"%@%@", baseURL, matchedString];
                }
            }
            
            NSMutableDictionary *workout = [NSMutableDictionary dictionary];
            [workout setObject:workoutUrl forKey:@"url"];
            [workout setObject:workoutTitle forKey:@"title"];
            [workout setObject:workoutNum forKey:@"num"];
            [workout setObject:workoutWith forKey:@"with"];
            [workout setObject:workoutImageUrl forKey:@"imageUrl"];
            
            [workouts addObject:workout];
        }
    }
    
    return workouts;
}

+(NSMutableDictionary*)getWorkoutDetails:(NSString *)url {
    // Get data from webpage
    NSURL *urlObj = [NSURL URLWithString:url];
    NSData *htmlData = [NSData dataWithContentsOfURL:urlObj];
    
    NSString *workoutDesc = @"";
    
    // Get workout description
    NSArray *node = PerformHTMLXPathQuery(htmlData, @"//div[@class='articleCopy']");
    workoutDesc = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
    
    // Parse weeks nodes
    NSArray *weeksNodes = PerformHTMLXPathQuery(htmlData, @"//div[contains(@class,'calendarRow')]");
    
    NSMutableArray *workoutWeeks = [[NSMutableArray alloc] initWithCapacity:0];
    
    int weekNum = 1;
    
    // Loop over each weeks
    for (NSDictionary *weekNode in weeksNodes) {
        node = [[NSArray alloc] init];
        
        NSString *weekName = @"";
        NSMutableArray *weekDays = [[NSMutableArray alloc] initWithCapacity:0];
        
        // Get node XML content and convert it to NSData
        NSData* weekNodeContent = [[weekNode objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
        
        // Search for week name
        node = PerformHTMLXPathQuery(weekNodeContent, @"//li[@class='week']/div");
        if([node count] > 0) {
            weekName = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Week days
            NSArray *daysNodes = PerformHTMLXPathQuery(weekNodeContent, @"//li[@class='info']//li[contains(@class,'col')]");
            
            int dayNum = 0;
            for (NSDictionary *dayNode in daysNodes) {
                NSString *dayUrl = @"";
                NSString *dayImageUrl = @"";
                NSString *dayTitle = @"";

                dayNum++;
                
                // Get node XML content and convert it to NSData
                NSData* dayNodeContent = [[dayNode objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
                
                // Day url
                node = PerformHTMLXPathQuery(dayNodeContent, @"//a");
                dayUrl = [[[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"] objectForKey:@"href"];
                
                // Day image
                node = PerformHTMLXPathQuery(dayNodeContent, @"//img[@class='thumb']");
                dayImageUrl = [[[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"] objectForKey:@"src"];
                
                // Day title
                node = PerformHTMLXPathQuery(dayNodeContent, @"//div[@class='caption']");
                dayTitle = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
                
                if(dayTitle == nil) {
                    node = PerformHTMLXPathQuery(dayNodeContent, @"//div[@class='caption']/p");
                    dayTitle = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
                }
                
                NSMutableDictionary *day = [NSMutableDictionary dictionary];
                
                [day setObject:@(dayNum) forKey:@"num"];
                [day setObject:dayUrl forKey:@"url"];
                [day setObject:dayImageUrl forKey:@"imageUrl"];
                [day setObject:dayTitle forKey:@"title"];
                
                [weekDays addObject:day];
            }
            
            NSMutableDictionary *week = [NSMutableDictionary dictionary];

            [week setObject:weekName forKey:@"name"];
            [week setObject:weekDays forKey:@"days"];
            [week setObject:@(weekNum) forKey:@"num"];
            
            [workoutWeeks addObject:week];
            
            weekNum++;
        }
    }
    
    NSMutableDictionary *workout = [NSMutableDictionary dictionary];
    [workout setObject:workoutDesc forKey:@"desc"];
    [workout setObject:workoutWeeks forKey:@"weeks"];
    
    return workout;
}

+(NSMutableDictionary*)getDayDetails:(NSString *)dayUrl {
    // Get data from webpage
    NSURL *url = [NSURL URLWithString:dayUrl];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    NSString *dayDesc = @"";
    NSMutableArray *dayExercices = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *node = PerformHTMLXPathQuery(htmlData, @"//div[@class='introCopy']/div[contains(@class,'col2')]/text()");
    dayDesc = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
    
    // Parse exercices nodes
    NSArray *exNodes = PerformHTMLXPathQuery(htmlData, @"//div[@class='desktop']/div[contains(@class,'workoutsRow')]");
    
    // Parse captions
    NSArray *captionNodes = PerformHTMLXPathQuery(htmlData, @"//div[@class='desktop']/div[@class='introCopy']");
    
    // Loop over each exercices
    for (int i = 0; i < [exNodes count]; i++) {
        NSDictionary *exNode = [exNodes objectAtIndex:i];
        
        NSString *exerciceName = @"";
        NSString *exerciceDesc = @"";
        NSString *exerciceAdditionalDesc = @"";
        NSString *exerciceNbSets = @"";
        NSString *exerciceNbReps = @"";
        NSString *exerciceNbRest = @"";
        NSString *exerciceImageUrl = @"";
        NSString *exerciceVideoId = @"";
        
        NSData* exNodeContent = [[exNode objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
        
        // Search for exercice name
        node = PerformHTMLXPathQuery(exNodeContent, @"//div[@class='colHead']");
        if([node count] > 0) {
            exerciceName = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Exercice description
            node = PerformHTMLXPathQuery(exNodeContent, @"//div[@class='colText']");
            exerciceDesc = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Additional desc from caption nodes array
            if([captionNodes count] > i) {
                exerciceAdditionalDesc = [[captionNodes objectAtIndex:i] objectForKey:@"nodeContent"];
            }
            
            // Exercice sets, reps & rest
            node = PerformHTMLXPathQuery(exNodeContent, @"//div[@class='colRep']/ul/li/text()");
            exerciceNbSets = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            exerciceNbReps = [[node objectAtIndex:1] objectForKey:@"nodeContent"];
            exerciceNbRest = [[node objectAtIndex:2] objectForKey:@"nodeContent"];
            
            // Exercice image
            node = PerformHTMLXPathQuery(exNodeContent, @"//img");
            exerciceImageUrl = [[[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"] objectForKey:@"src"];
            
            // Exercice video ID
            node = PerformHTMLXPathQuery(exNodeContent, @"//div[@class='video']");
            exerciceVideoId = [[[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"] objectForKey:@"data-id"];
            
            NSMutableDictionary *exercice = [NSMutableDictionary dictionary];
            
            [exercice setObject:exerciceName forKey:@"name"];
            [exercice setObject:exerciceDesc forKey:@"desc"];
            [exercice setObject:exerciceAdditionalDesc forKey:@"additionalDesc"];
            [exercice setObject:exerciceNbSets forKey:@"nbSets"];
            [exercice setObject:exerciceNbReps forKey:@"nbReps"];
            [exercice setObject:exerciceNbRest forKey:@"nbRest"];
            [exercice setObject:exerciceImageUrl forKey:@"imageUrl"];
            [exercice setObject:exerciceVideoId forKey:@"videoId"];
            
            [dayExercices addObject:exercice];
        }
    }
    
    NSMutableDictionary *day = [NSMutableDictionary dictionary];
    [day setObject:dayDesc forKey:@"desc"];
    [day setObject:dayExercices forKey:@"exercices"];
    
    return day;
}

+(NSString*)getVideoUrl:(NSString *)videoId {
    NSError *error = nil;
    
    // URL of the iframe for mobiles
    NSURL *url = [NSURL URLWithString:[@"http://c.brightcove.com/services/viewer/htmlFederated?&width=480&height=270&flashID=myExperience&wmode=transparent&playerID=3540969411001&playerKey=AQ~~%2CAAAAAE6v4EM~%2CN712tMps-ILYSGMQ_Ng_D_wWFjzdrfKe&isVid=true&isUI=true&dynamicStreaming=true&autoStart=true&includeAPI=true&templateLoadHandler=onTemplateLoaded&templateReadyHandler=onTemplateReady&%40videoPlayer=VIDEO_ID&debuggerID=&startTime=1415410108644&refURL=not%20available" stringByReplacingOccurrencesOfString:@"VIDEO_ID" withString:videoId]];
    
    NSStringEncoding encoding;
    NSString *htmlData = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&error];
    
    if(error) {
        NSLog(@"Couldn't load string from URL : %@", error);
        return @"";
    }
    
    // We will get the JS part containing an array of the videos availables (with sizes/qualities)
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"renditions\":\\[([^\\]]*)" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error) {
        NSLog(@"Couldn't create regex expression : %@", error);
        return @"";
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:htmlData options:0 range:NSMakeRange(0, [htmlData length])];
    
    if(!match) {
        NSLog(@"MP4 files array not found by Regex.");
        return @"";
    }
    
    NSRange jsonMp4FilesRange = [match rangeAtIndex:1];
    
    if(jsonMp4FilesRange.length == 0) {
        NSLog(@"MP4 files array range empty.");
        return @"";
    }
    
    // Convert JSON string to NSArray
    NSString *jsonMp4Files = [NSString stringWithFormat:@"[%@]", [htmlData substringWithRange:jsonMp4FilesRange]];
    NSArray *mp4Files = [NSJSONSerialization JSONObjectWithData:[jsonMp4Files dataUsingEncoding:encoding] options:0 error:&error];
    
    if(error || !mp4Files) {
        NSLog(@"Couldn't read mp4 files' JSON : %@", error);
        return @"";
    }
    
    // Find the best quality video
    NSDictionary *bestFile = [mp4Files objectAtIndex:0];
    for(NSDictionary *mp4File in mp4Files) {
        if([mp4File objectForKey:@"frameWidth"] > [bestFile objectForKey:@"frameWidth"]) {
            bestFile = mp4File;
        }
    }
    
    return [bestFile objectForKey:@"defaultURL"];
}

@end
