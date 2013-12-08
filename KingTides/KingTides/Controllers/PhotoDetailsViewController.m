#import "PhotoDetailsViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "NSData+Base64.h"
#import "NSDate+Formatting.h"

@interface PhotoDetailsViewController ()

@property(nonatomic, strong) UIImage *photo;
@property(nonatomic, strong) CLLocation *location;

@end

@implementation PhotoDetailsViewController

- (id)init {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPhoto)];
  }
  return self;
}

- (void)uploadPhoto {
  NSData *data = UIImageJPEGRepresentation(self.photo, 1.0);
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  double latitude, longitude = 0;
  if(self.location) {
    latitude = self.location.coordinate.latitude;
    longitude = self.location.coordinate.longitude;
  }
  NSDictionary *parameters = @{
          @"CreationTime": [[NSDate date] stringByFormattingISO8601Date],
          @"FirstName": self.nameTextField.text,
          @"LastName": @"",
          @"Description":self.descriptionTextView.text,
          @"Email":self.emailTextField.text,
          @"Latitude": [NSNumber numberWithDouble:latitude],
          @"Longitude": [NSNumber numberWithDouble:longitude],
          @"Photo": [data base64EncodedString]
  };
  [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadSuccess" object:self userInfo:nil];
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadError" object:self userInfo:nil];
  }];

  [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.imageView.image = self.photo;
}

- (void)updatePhoto:(UIImage *)image {
  self.photo = image;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)updateLocation:(CLLocation *)location {
  self.location = location;
}
@end
