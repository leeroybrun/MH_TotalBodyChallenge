//
//  Exercice.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Exercice : NSManagedObject

@property (nonatomic, retain) NSString * additionalDesc;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nbReps;
@property (nonatomic, retain) NSString * nbRest;
@property (nonatomic, retain) NSString * nbSets;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) Day *day;

@end
