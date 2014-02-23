#import "UploadOperation.h"
#import "Upload.h"
#import "KingTidesService.h"


@implementation UploadOperation

- (id)initWithUpload:(Upload *)upload {
  if (self = [super init]) {
    self.upload = upload;
  }
  return self;
}

#pragma mark - Main
- (void)main {
  NSLog(@"Uploading %@ id: %@", self.upload.firstName, self.upload.fileId);

  [[KingTidesService sharedService] uploadPhoto:self.upload
                                       success:^() {
                                         [Upload removeUpload:self.upload];
                                         [self.delegate uploadSuccessful:self upload:self.upload];
                                       }
                                       failure:^(NSError *error) {
    [self.delegate uploadFailed:self error:error upload:self.upload];
  }];
}

@end