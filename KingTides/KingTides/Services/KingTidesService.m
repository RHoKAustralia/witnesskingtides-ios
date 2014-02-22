#import <CoreLocation/CoreLocation.h>
#import "KingTidesService.h"
#import "NSDate+Formatting.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPSessionManager.h"
#import "NSData+Base64.h"


static NSString *const END_POINT = @"http://witnesskingtides.azurewebsites.net/api/";

@implementation KingTidesService

- (void) uploadPhoto:(NSString *)firstName
         description:(NSString *)description
               email:(NSString *)email
            location:(CLLocation *)location
               photo:(UIImage *)photo {
  AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:END_POINT]];
  NSData *data = UIImageJPEGRepresentation(photo, 1.0);
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  double latitude = 0, longitude = 0;
  if(location) {
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
  }
  NSDictionary *parameters = @{
          @"CreationTime": [[NSDate date] stringByFormattingISO8601Date],
          @"FirstName": firstName,
          @"LastName": @"",
          @"Description":description,
          @"Email":email,
          @"Latitude": [NSNumber numberWithDouble: latitude],
          @"Longitude": [NSNumber numberWithDouble:longitude],
          @"Photo": [data base64EncodedString]
  };
  [manager POST:@"photo" parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadSuccess" object:self userInfo:nil];
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadError" object:self userInfo:nil];
  }];
}

@end