//
//  Exercice.m
//  MH_TotalBodyChallenge
//
//  Created by Leeroy Brun on 28.12.14.
//  Copyright (c) 2014 Leeroy Brun. All rights reserved.
//

#import "Exercice.h"
#import "Day.h"


@implementation Exercice

@dynamic additionalDesc;
@dynamic desc;
@dynamic imageUrl;
@dynamic name;
@dynamic nbReps;
@dynamic nbRest;
@dynamic nbSets;
@dynamic num;
@dynamic videoId;
@dynamic videoUrl;
@dynamic day;

-(void)fetchVideoUrl {
    NSError *error = nil;
    
    // URL of the iframe for mobiles
    NSURL *url = [NSURL URLWithString:[@"http://c.brightcove.com/services/viewer/htmlFederated?&width=480&height=270&flashID=myExperience&wmode=transparent&playerID=3540969411001&playerKey=AQ~~%2CAAAAAE6v4EM~%2CN712tMps-ILYSGMQ_Ng_D_wWFjzdrfKe&isVid=true&isUI=true&dynamicStreaming=true&autoStart=true&includeAPI=true&templateLoadHandler=onTemplateLoaded&templateReadyHandler=onTemplateReady&%40videoPlayer=VIDEO_ID&debuggerID=&startTime=1415410108644&refURL=not%20available" stringByReplacingOccurrencesOfString:@"VIDEO_ID" withString:self.videoId]];
    
    NSStringEncoding encoding;
    NSString *htmlData = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&error];
    
    if(error) {
        return NSLog(@"Couldn't load string from URL : %@", error);
    }
    
    // We will get the JS part containing an array of the videos availables (with sizes/qualities)
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"renditions\":\\[([^\\]]*)" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error) {
        return NSLog(@"Couldn't create regex expression : %@", error);
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:htmlData options:0 range:NSMakeRange(0, [htmlData length])];
    
    if(!match) {
        return NSLog(@"MP4 files array not found by Regex.");
    }
    
    NSRange jsonMp4FilesRange = [match rangeAtIndex:1];
    
    if(jsonMp4FilesRange.length == 0) {
        return NSLog(@"MP4 files array range empty.");
    }
    
    // Convert JSON string to NSArray
    NSString *jsonMp4Files = [NSString stringWithFormat:@"[%@]", [htmlData substringWithRange:jsonMp4FilesRange]];
    NSArray *mp4Files = [NSJSONSerialization JSONObjectWithData:[jsonMp4Files dataUsingEncoding:encoding] options:0 error:&error];
    
    if(error || !mp4Files) {
        return NSLog(@"Couldn't read mp4 files' JSON : %@", error);
    }
    
    // Find the best quality video
    NSDictionary *bestFile = [mp4Files objectAtIndex:0];
    for(NSDictionary *mp4File in mp4Files) {
        if([mp4File objectForKey:@"frameWidth"] > [bestFile objectForKey:@"frameWidth"]) {
            bestFile = mp4File;
        }
    }
    
    self.videoUrl = [bestFile objectForKey:@"defaultURL"];
}

@end
