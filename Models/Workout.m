//
//  Workout.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "Workout.h"
#import "Week.h"


@implementation Workout

@dynamic desc;
@dynamic detailsFetched;
@dynamic imageUrl;
@dynamic num;
@dynamic title;
@dynamic url;
@dynamic with;
@dynamic weeks;

- (void)addWeeksObject:(Week *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.weeks];
    [tempSet addObject:value];
    self.weeks = tempSet;
}

@end
