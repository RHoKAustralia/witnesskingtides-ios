//
//  DownloadWorker.m
//  KingTides
//
//  Created by linchuang on 24/07/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import "DownloadWorker.h"
#import "Notifications.h"
@interface DownloadWorker() <DownloadOperationProtocol>
@property(nonatomic,strong) NSOperationQueue* retrieveOperationQueue;
//- (void)enqueForDownloadOperation:(NSString*)downloadURL;

@end

@implementation DownloadWorker
+(DownloadWorker*)sharedDownloadWorker
{
    static DownloadWorker* worker=nil;
    static dispatch_once_t taken;
    dispatch_once(&taken, ^{
        worker= [[DownloadWorker alloc] initWithclient:[KingTidesService sharedService]];
    });
    return worker;
}
//?
- (void)queueDownloadOperation:(TideInfo*)tideInfoDownloadOperation
{
    DownloadOperation *operation = [[DownloadOperation alloc] initWithTideInfo:tideInfoDownloadOperation];
    operation.delegate = self;
    //operation.tideInfo=tideInfoDownloadOperation;
    [self.retrieveOperationQueue addOperation:operation];
}

-(id)initWithclient:(KingTidesService *)client

{
    if (self = [super init])
    {
        self.retrieveOperationQueue = [[NSOperationQueue alloc] init];
        self.retrieveOperationQueue.maxConcurrentOperationCount = 1;
        [self.retrieveOperationQueue setSuspended:client.isReachable];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queueForDownloads)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
        __weak DownloadWorker* weakSelf = self;
        
        [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable)
            {
                [weakSelf.retrieveOperationQueue setSuspended:YES];
            } else
            {
                [weakSelf.retrieveOperationQueue setSuspended:NO];
                [self queueForDownloads];
            }
        }];
    }
    return self;
}

- (void)queueForDownloads
{
    for(DownloadOperation* op in [[self retrieveOperationQueue] operations])
    {
        if (![op isCancelled]&& ![op isFinished] )
        {
            [op start];
        }
        
    }
    
}

#pragma DownloadOperationProtocol

- (void)downloadSuccessfully:(DownloadOperation *)operation download:(id )downloadedContent

{
    if (![operation.tideInfo isKindOfClass:[TideInfo class]]&& [downloadedContent isKindOfClass:[NSArray class]])// downloadedContent is a kind of data structure of JSON
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadSuccessfully object:self userInfo:@{@"downloadJSON" : downloadedContent}];
    }
    
        
    
    
    
}
- (void)downloadFailed:(DownloadOperation *)operation error:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUploadFailed object:self userInfo:@{@"Error" : error}];
    NSLog(@"Failed to with error description: %@",  error.localizedDescription);
}

@end
