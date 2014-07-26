//
//  DownloadOperation.m
//  KingTides
//
//  Created by linchuang on 24/07/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import "DownloadOperation.h"
#import "KingTidesService.h"

@implementation DownloadOperation


-(id)initWithTideInfo:(TideInfo*) tideInfo;
{
    if (self = [super init])
    {
        if ([tideInfo isKindOfClass: [TideInfo class]]) {
            self.tideInfo=tideInfo;
        }
        else
            self.tideInfo=nil;
    }
    return self;
}

#pragma mark - Main
- (void)main
{
    NSLog(@"Downloading...");
    if (self.isCancelled) {
        return;
    }
    /*
     - (void)retrieveTideData:(void (^)(id retrievedData))success failure: (void (^)(NSError *error))failure;
     */
    if (self.tideInfo==nil)
    {
        [[KingTidesService sharedService] retrieveTideData:^(id retrievedData)
         {
             if ([retrievedData isKindOfClass:[NSArray class]])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.delegate downloadSuccessfully:self download:retrievedData];
                 });
                 
             }
             
             
             
         }
                                                   failure: ^(NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.delegate downloadFailed:self error:error];
             });
             
             
             
         }
         ];

    }
    else
    {
        //reserve for future download of pictures
    }
}


@end
