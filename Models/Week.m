//
//  Week
//  TotalBodyChallenge
//
//  Created by Leeroy Brun on 04.11.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "Week.h"

@implementation Week

- (id)init
{
    self = [super init];
    if (self)
    {
        self.days = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

@end
