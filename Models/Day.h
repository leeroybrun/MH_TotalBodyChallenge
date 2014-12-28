//
//  Day.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercice, Week;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic) BOOL detailsFetched;
@property (nonatomic, retain) NSOrderedSet *exercices;
@property (nonatomic, retain) Week *week;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)insertObject:(Exercice *)value inExercicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExercicesAtIndex:(NSUInteger)idx;
- (void)insertExercices:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExercicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExercicesAtIndex:(NSUInteger)idx withObject:(Exercice *)value;
- (void)replaceExercicesAtIndexes:(NSIndexSet *)indexes withExercices:(NSArray *)values;
- (void)addExercicesObject:(Exercice *)value;
- (void)removeExercicesObject:(Exercice *)value;
- (void)addExercices:(NSOrderedSet *)values;
- (void)removeExercices:(NSOrderedSet *)values;
@end
