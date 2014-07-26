//
//  BasicAccessor.h
//  NewsReader
//
//  Created by linchuang on 16/07/2014.
//  Copyright (c) 2014 Fairfax Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSONReportForRecognition : NSObject
{
}

@property (nonatomic, assign) long identifier;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSMutableArray* items;

@end


@interface Hypothesis : NSObject
{
}

@property (nonatomic, assign) long identifier;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* headLine;
@property (nonatomic, retain) NSString* slugLine;
@property (nonatomic, retain) NSString* thumbnailImageHref;
@property (nonatomic, retain) NSString* webHref;
@property (nonatomic, retain) NSString*  tinyUrl;
@property (nonatomic, retain) NSString* dateLine;

@end

