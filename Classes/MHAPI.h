//
//  MHAPI.h
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 04.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHAPI : NSObject

+ (MHAPI*)sharedInstance;

-(NSMutableArray*)getWorkouts;

@end
