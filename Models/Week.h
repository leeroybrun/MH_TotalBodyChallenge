//
//  Workout.h
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 04.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Week : NSObject

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *days;

@end
