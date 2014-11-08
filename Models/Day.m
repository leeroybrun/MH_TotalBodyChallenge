//
//  Workout.m
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 04.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "Day.h"
#import "Exercice.h"
#import "XPathQuery.h"

@implementation Day

- (id)init
{
    self = [super init];
    if (self)
    {
        self.exercices = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (NSString*)name
{
    switch ([self.num integerValue]) {
        case 1:
            return @"Monday";
            break;
        case 2:
            return @"Tuesday";
            break;
        case 3:
            return @"Wednesday";
            break;
        case 4:
            return @"Thursday";
            break;
        case 5:
            return @"Friday";
            break;
        case 6:
            return @"Saturday";
            break;
        case 7:
            return @"Sunday";
            break;
            
        default:
            return @"";
            break;
    }
}

-(void)getDetail {
    // Already fetched ?
    if([self.exercices count] > 0) {
        return;
    }
    
    // Get data from webpage
    NSURL *url = [NSURL URLWithString:self.url];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    NSArray *node = PerformHTMLXPathQuery(htmlData, @"//div[@class='introCopy']/div[contains(@class,'col2')]/text()");
    self.description = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
    
    // Parse exercices nodes
    NSArray *exNodes = PerformHTMLXPathQuery(htmlData, @"//div[contains(@class,'workoutsRow')]");
    
    self.exercices = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Loop over each exercices
    for (NSDictionary *exNode in exNodes) {
        Exercice *exercice = [[Exercice alloc] init];
        
        NSData* exNodeContent = [[exNode objectForKey:@"nodeXMLContent"] dataUsingEncoding:NSUTF8StringEncoding];
        
        // Search for exercice name
        node = PerformHTMLXPathQuery(exNodeContent, @"//div[@class='colHead']");
        if([node count] > 0) {
            exercice.name = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Exercice description
            node = PerformHTMLXPathQuery(exNodeContent, @"//div[@class='colText']");
            exercice.description = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            
            // Exercice sets, reps & rest
            node = PerformHTMLXPathQuery(exNodeContent, @"//div[@class='colRep']/ul/li/text()");
            exercice.sets = [[node objectAtIndex:0] objectForKey:@"nodeContent"];
            exercice.reps = [[node objectAtIndex:1] objectForKey:@"nodeContent"];
            exercice.rest = [[node objectAtIndex:2] objectForKey:@"nodeContent"];
            
            // Exercice image
            node = PerformHTMLXPathQuery(exNodeContent, @"//img");
            exercice.imageUrl = [[[node objectAtIndex:0] objectForKey:@"nodeAttributeDictionary"] objectForKey:@"src"];
            
            [self.exercices addObject:exercice];
        }
    }
}

@end
