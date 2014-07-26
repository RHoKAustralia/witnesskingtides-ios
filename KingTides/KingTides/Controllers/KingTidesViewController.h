//
//  KingTidesViewController.h
//  KingTides
//
//  Created by Andrew Spinks on 8/12/2013.
//  Copyright (c) 2013 Green Cross Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TideInfo.h"
#import "DownloadWorker.h"
@interface KingTidesViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray* tideInfoArray;
@property(nonatomic,strong) DownloadWorker* downloadWorker;
@end
