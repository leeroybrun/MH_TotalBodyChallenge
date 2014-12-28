//
//  Day.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "Day.h"
#import "Exercice.h"
#import "Week.h"


@implementation Day

@dynamic desc;
@dynamic imageUrl;
@dynamic name;
@dynamic num;
@dynamic title;
@dynamic url;
@dynamic detailsFetched;
@dynamic exercices;
@dynamic week;

- (void)addExercicesObject:(Exercice *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.exercices];
    [tempSet addObject:value];
    self.exercices = tempSet;
}

@end
