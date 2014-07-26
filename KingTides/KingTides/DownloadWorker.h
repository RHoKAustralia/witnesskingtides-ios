//
//  DownloadWorker.h
//  KingTides
//
//  Created by linchuang on 24/07/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TideInfo.h"
#import "DownloadOperation.h"
#import "KingTidesService.h"

@interface DownloadWorker : NSObject

//@property (nonatomic,strong) NSCache* dataCache;

+ (DownloadWorker *)sharedDownloadWorker;
-(id)initWithclient:(KingTidesService *)client;
- (void)queueDownloadOperation:(TideInfo*)tideInfoDownloadOperation;


/*
 + (ResilientUploader *)sharedUploader;
 //- (void)save:(Upload *)upload;
 - (void)queueSavedUploads;
 */


//- (void)queueSavedUploads;

@end
