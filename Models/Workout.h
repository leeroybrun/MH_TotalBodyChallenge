//
//  Workout.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Week;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic) BOOL detailsFetched;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * with;
@property (nonatomic, retain) NSOrderedSet *weeks;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)insertObject:(Week *)value inWeeksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWeeksAtIndex:(NSUInteger)idx;
- (void)insertWeeks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWeeksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWeeksAtIndex:(NSUInteger)idx withObject:(Week *)value;
- (void)replaceWeeksAtIndexes:(NSIndexSet *)indexes withWeeks:(NSArray *)values;
- (void)addWeeksObject:(Week *)value;
- (void)removeWeeksObject:(Week *)value;
- (void)addWeeks:(NSOrderedSet *)values;
- (void)removeWeeks:(NSOrderedSet *)values;
@end
