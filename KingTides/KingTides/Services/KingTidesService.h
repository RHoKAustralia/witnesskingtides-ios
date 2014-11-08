#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"
#import "TideInfoJM.h"

@class CLLocation;
@class Upload;

@interface KingTidesService : NSObject

typedef void (^UploadSuccessBlock)();
typedef void (^FailureBlock)(NSError *error);

+ (KingTidesService *)sharedService;

- (void)uploadPhoto:(Upload *)upload success:(UploadSuccessBlock)success failure:(FailureBlock)failure;

- (void)retrieveTideData:(void (^)(NSArray *list))success failure: (void (^)(NSError *error))failure;
- (BOOL)isReachable;

- (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block;
@end