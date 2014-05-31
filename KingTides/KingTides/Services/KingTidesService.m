#import <CoreLocation/CoreLocation.h>
#import "KingTidesService.h"
#import "NSDate+Formatting.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPSessionManager.h"
#import "NSData+Base64.h"
#import "Upload.h"
#import "FBTweakInline.h"



@interface KingTidesService()
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@property(nonatomic, strong) NSString *endPoint;
@end

@implementation KingTidesService

- (id)init {
  if (self = [super init]) {
    self.endPoint = FBTweakValue(@"Serverside", @"Endpoints", @"WKT", @"http://witnesskingtides.azurewebsites.net/api/");
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.endPoint]];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
  }
  return self;
}

+ (KingTidesService *)sharedService {
  static KingTidesService *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[KingTidesService alloc] init];
  });

  return _sharedClient;
}

- (void) uploadPhoto:(Upload *)upload
             success:(UploadSuccessBlock)success
             failure:(FailureBlock)failure {
  NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:upload];
  [self.manager POST:@"photo" parameters:JSONDictionary success:^(NSURLSessionDataTask *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    success();
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    failure(error);
  }];
}

- (void)retrieveTideData:(void (^)(NSArray *list))success {

}

- (BOOL)isReachable {
  return self.manager.reachabilityManager.isReachable;
}

- (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block {
  [self.manager.reachabilityManager setReachabilityStatusChangeBlock:block];
}

@end