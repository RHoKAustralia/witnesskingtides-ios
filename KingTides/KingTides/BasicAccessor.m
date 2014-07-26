//
//  BasicAccessor.m
//  NewsReader
//
//  Created by linchuang on 16/07/2014.
//  Copyright (c) 2014 Fairfax Media. All rights reserved.
//

#import "BasicAccessor.h"


@implementation JSONReportForRecognition

- (void)dealloc
{
    [_name release];
    [_items release];
    [super dealloc];
}


@end


@implementation Hypothesis

- (void)dealloc
{
    [_type release];
    [_headLine release];
    [_slugLine release];
    [_thumbnailImageHref release];
    [_webHref release];
    [_tinyUrl release];
    [_dateLine release];
    [super dealloc];
}

@end





