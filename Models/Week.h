//
//  Week.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, Workout;

@interface Week : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSOrderedSet *days;
@property (nonatomic, retain) Workout *workout;
@end

@interface Week (CoreDataGeneratedAccessors)

- (void)insertObject:(Day *)value inDaysAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDaysAtIndex:(NSUInteger)idx;
- (void)insertDays:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDaysAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDaysAtIndex:(NSUInteger)idx withObject:(Day *)value;
- (void)replaceDaysAtIndexes:(NSIndexSet *)indexes withDays:(NSArray *)values;
- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSOrderedSet *)values;
- (void)removeDays:(NSOrderedSet *)values;
@end
