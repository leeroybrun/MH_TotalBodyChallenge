//
//  MHAPI.h
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 21.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHAPI : NSObject

+(NSMutableArray*)getWorkouts;
+(NSMutableDictionary*)getWorkoutDetails:(NSString *)url;
+(NSMutableDictionary*)getDayDetails:(NSString *)url;
+(NSString*)getVideoUrl:(NSString *)videoId;

@end
