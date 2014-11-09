//
//  Workout.h
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 04.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (nonatomic, copy) NSNumber *num;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSMutableArray *exercices;

-(void)getDetail;

@end
