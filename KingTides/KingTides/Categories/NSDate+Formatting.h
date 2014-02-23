

@interface NSDate (Formatting)

- (NSString *)stringByFormattingISO8601Date;

@end

@interface NSString (Formatting)

- (NSDate *)dateByFormattingISO8601Date;

@end
