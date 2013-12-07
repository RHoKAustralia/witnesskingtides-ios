#import "NSDate+Formatting.h"

@implementation NSDateFormatter (Formatting)

+ (NSDateFormatter*)iso8601DateFormatter {
  static NSDateFormatter *iso8601DateFormatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    iso8601DateFormatter = [[NSDateFormatter alloc] init];
    [iso8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
  });

  return iso8601DateFormatter;
}

@end

@implementation NSDate (Formatting)

- (NSString *)stringByFormattingISO8601Date {
  return [[NSDateFormatter iso8601DateFormatter] stringFromDate:self];
}

@end