//
//  TideInfo.m
//  KingTides
//
//  Created by linchuang on 23/07/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import "TideInfo.h"
@interface TideInfo()

@end

@implementation TideInfo
+(NSDictionary*)groupDataByState:(NSArray*)tideInfoArray
{
    NSMutableSet* stateSet= [NSMutableSet set];
    NSMutableDictionary* tideInfoDivideByState= [NSMutableDictionary dictionary];
    
    for (TideInfo* info in tideInfoArray)
    {
        [stateSet addObject:info.state];
    }
    
    for (NSString* stateNmae in stateSet)
    {
        NSMutableArray* sectionArray= [NSMutableArray array];
        
        for (TideInfo* info in tideInfoArray)
        {
            if ([info.state isEqualToString:stateNmae])
            {
                [sectionArray addObject:info];
                
            }
         }
        [tideInfoDivideByState setObject:sectionArray forKey:stateNmae];
    }
    return [NSDictionary dictionaryWithDictionary:tideInfoDivideByState];
    
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tideID": @"id",
             @"location": @"event.location",
             @"state": @"event.state",
             @"description": @"event.description",
             @"hightTideOccurs": @"event.highTideOccurs",
             @"eventStarts": @"event.eventStart",
             @"eventEnds": @"event.eventEnd",
             @"latitude": @"event.latitude",
             @"longtitude": @"event.longitude",
             @"version": @"event.__v",
             
             };
}

@end
