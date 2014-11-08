//
//  TideInfo.h
//  KingTides
//
//  Created by linchuang on 23/07/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TideInfo : MTLModel<MTLJSONSerializing>
{
}
//@property(nonatomic,strong) NSString* tideID;
@property(nonatomic,strong) NSString* location;
@property(nonatomic,strong) NSString* state;
@property(nonatomic,strong) NSString* description;
@property(nonatomic,strong) NSString* hightTideOccurs;
@property(nonatomic,strong) NSString* eventStart;
@property(nonatomic,strong) NSString* eventEnd;
@property(nonatomic,strong) NSNumber* latitude;
@property(nonatomic,strong) NSNumber* longtitude;
//@property(nonatomic,strong) NSString* picURL;//reserve for furture use
//@property(nonatomic,strong) NSNumber* version;
//+(NSArray*)parseJSON:(NSArray *)JSONData;
+ (NSDictionary*)groupDataByState:(NSArray*)tideInfoArray;
+ (NSDictionary *)JSONKeyPathsByPropertyKey;


@end


