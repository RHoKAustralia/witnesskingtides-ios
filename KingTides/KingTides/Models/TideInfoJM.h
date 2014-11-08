//
//  TideInfoJM.h
//  KingTides
//
//  Created by Tarcio Saraiva on 8/11/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import "JSONModel.h"

@interface TideInfoJM : JSONModel
//@property(nonatomic,strong) NSString* tideID;
@property(nonatomic,strong) NSString* location;
@property(nonatomic,strong) NSString* state;
@property(nonatomic,strong) NSString* Description;
@property(nonatomic,strong) NSString* highTideOccurs;
@property(nonatomic,strong) NSString* eventStart;
@property(nonatomic,strong) NSString* eventEnd;
@property(nonatomic,strong) NSNumber* latitude;
@property(nonatomic,strong) NSNumber* longtitude;

+ (NSDictionary*)groupDataByState:(NSArray*)tideInfoArray;
@end
