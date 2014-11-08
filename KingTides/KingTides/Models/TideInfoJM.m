//
//  TideInfoJM.m
//  KingTides
//
//  Created by Tarcio Saraiva on 8/11/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import "TideInfoJM.h"

@implementation TideInfoJM

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description": @"Description"}];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (NSDictionary *)groupDataByState:(NSArray *)tideInfoArray {
    NSMutableSet *stateSet = [NSMutableSet set];
    NSMutableDictionary *tideInfoDivideByState = [NSMutableDictionary dictionary];
    
    for (TideInfoJM *info in tideInfoArray) {
        [stateSet addObject:info.state];
    }
    
    for (NSString *stateName in stateSet) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        
        for (TideInfoJM *info in tideInfoArray) {
            if ([info.state isEqualToString:stateName]) {
                [sectionArray addObject:info];
            }
        }
        tideInfoDivideByState[stateName] = sectionArray;
    }
    return [NSDictionary dictionaryWithDictionary:tideInfoDivideByState];
    
}
@end
