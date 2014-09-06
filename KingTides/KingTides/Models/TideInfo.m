
#import "TideInfo.h"

@interface TideInfo ()

@end

@implementation TideInfo

+ (NSDictionary *)groupDataByState:(NSArray *)tideInfoArray {
  NSMutableSet *stateSet = [NSMutableSet set];
  NSMutableDictionary *tideInfoDivideByState = [NSMutableDictionary dictionary];

  for (TideInfo *info in tideInfoArray) {
    [stateSet addObject:info.state];
  }

  for (NSString *stateName in stateSet) {
    NSMutableArray *sectionArray = [NSMutableArray array];

    for (TideInfo *info in tideInfoArray) {
      if ([info.state isEqualToString:stateName]) {
        [sectionArray addObject:info];
      }
    }
    tideInfoDivideByState[stateName] = sectionArray;
  }
  return [NSDictionary dictionaryWithDictionary:tideInfoDivideByState];

}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
          @"tideID" : @"id",
          @"location" : @"event.location",
          @"state" : @"event.state",
          @"description" : @"event.description",
          @"hightTideOccurs" : @"event.highTideOccurs",
          @"eventStarts" : @"event.eventStart",
          @"eventEnds" : @"event.eventEnd",
          @"latitude" : @"event.latitude",
          @"longtitude" : @"event.longitude",
          @"version" : @"event.__v",
  };
}

@end
