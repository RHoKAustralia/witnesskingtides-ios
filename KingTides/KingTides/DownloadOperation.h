//
//  DownloadOperation.h
//  KingTides
//
//  Created by linchuang on 24/07/2014.
//  Copyright (c) 2014 Green Cross Australia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TideInfo.h"

@class DownloadOperation;


@protocol DownloadOperationProtocol <NSObject>
- (void)downloadSuccessfully:(DownloadOperation *)operation download:(id )downloadedContent;
- (void)downloadFailed:(DownloadOperation *)operation error:(NSError *)error;
@end


@interface DownloadOperation : NSOperation
@property (nonatomic, weak) id<DownloadOperationProtocol> delegate;
@property(nonatomic,retain) TideInfo* tideInfo;
-(id)initWithTideInfo:(TideInfo*) tideInfo;
@end
