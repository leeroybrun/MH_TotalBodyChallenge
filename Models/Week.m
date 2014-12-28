//
//  Week.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "Week.h"
#import "Day.h"
#import "Workout.h"


@implementation Week

@dynamic name;
@dynamic num;
@dynamic days;
@dynamic workout;

- (void)addDaysObject:(Day *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.days];
    [tempSet addObject:value];
    self.days = tempSet;
}

@end
