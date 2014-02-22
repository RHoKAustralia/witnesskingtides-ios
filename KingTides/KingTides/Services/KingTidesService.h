#import <Foundation/Foundation.h>

@interface KingTidesService : NSObject
- (void)uploadPhoto:(NSString *)firstName description:(NSString *)description email:(NSString *)email location:(CLLocation *)location photo:(UIImage *)photo;
@end