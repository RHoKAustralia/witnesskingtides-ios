#import <CoreLocation/CoreLocation.h>
#import "Upload.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "NSDate+Formatting.h"
#import "MTLValueTransformer.h"
#import "NSData+Base64.h"

static NSString *const kArchiveKey = @"upload";

@interface Upload()

@end

@implementation Upload

- (id)initWithName:(NSString *)firstName andEmail:(NSString *)email andDescription:(NSString *)description andDate:(NSDate *)date andLocation:(CLLocation *)location andImage:(UIImage *)image{
  if (self = [super init]) {
    self.firstName = firstName;
    self.createdDate = date;
    self.email = email;
    self.lastName = @"";
    self.description = description;

    double latitude = 0, longitude = 0;
    if(location) {
      latitude = location.coordinate.latitude;
      longitude = location.coordinate.longitude;
    }
    self.latitude = [NSNumber numberWithDouble: latitude];
    self.longitude = [NSNumber numberWithDouble:longitude];

    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    self.photo = [data base64EncodedString];

    self.fileId = [[NSUUID UUID] UUIDString];
  }
  return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
          @"createdDate" : @"CreationTime",
          @"firstName" : @"FirstName",
          @"lastName" : @"LastName",
          @"description" : @"Description",
          @"email" : @"Email",
          @"latitude" : @"Latitude",
          @"longitude" : @"Longitude",
          @"photo" : @"Photo"
  };
}

+ (NSValueTransformer *)createdDateJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
    return [str dateByFormattingISO8601Date];
  } reverseBlock:^(NSDate *date) {
    return [date stringByFormattingISO8601Date];
  }];
}

- (void)saveToDisk {
  NSString *dataPath = [Upload filenameForId:self.fileId];
  NSMutableData *newIncident = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:newIncident];

  [archiver encodeObject:self forKey:kArchiveKey];
  [archiver finishEncoding];
  [newIncident writeToFile:dataPath atomically:YES];
}

+ (void)removeUpload:(Upload *)upload {
  NSError *deleteError;
  NSLog(@"Removing %@ document path: %@", upload.firstName, [Upload filenameForId:upload.fileId]);
  BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[Upload filenameForId:upload.fileId] error:&deleteError];
  if (!success) {
    NSLog(@"Error removing document path: %@", deleteError.localizedDescription);
  }
}

+ (NSString *)uploadDir {
  NSError *error;
  NSString *uploadDir = [[self getPrivateDocsDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"upload"]];
  [[NSFileManager defaultManager] createDirectoryAtPath:uploadDir withIntermediateDirectories:YES attributes:nil error:&error];
  return uploadDir;
}

+ (NSString *)filenameForId:(NSString *)id {
  return [[self uploadDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", id]];
}

+ (NSArray *)loadUnsaved {
  NSString *uploadDir = [self uploadDir];
  NSError *error;
  NSArray *uploads = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:uploadDir error:&error];
  NSMutableArray *incidentsToUpload = [[NSMutableArray alloc] init];

  for (NSString *fileName in uploads) {
    if ([fileName hasSuffix:@".plist"]) {
      NSData *codedData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [self uploadDir], fileName]];
      NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
      [incidentsToUpload addObject: [unarchiver decodeObjectForKey:kArchiveKey]];
    }
  }
  return incidentsToUpload;
}

+ (NSString *)getPrivateDocsDir {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];

  NSError *error;
  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];

  return documentsDirectory;
}

@end