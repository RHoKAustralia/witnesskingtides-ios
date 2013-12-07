#import "PhotoDetailsViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "NSData+Base64.h"

@interface PhotoDetailsViewController ()

@property(nonatomic, strong) UIImage *photo;

@end

@implementation PhotoDetailsViewController

- (id)init {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPhoto)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
  return self;
}

- (void)uploadPhoto {
  NSData *data = UIImageJPEGRepresentation(self.photo, 1.0);
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  NSDictionary *parameters = @{
          @"PhotoDate": [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle],
          @"FirstName": self.nameTextField.text,
          @"LastName": @"",
          @"Description":self.descriptionTextField.text,
          @"Email":self.emailTextField.text,
          @"Latitude": @234,
          @"Longitude": @234,
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
  // Do any additional setup after loading the view from its nib.
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
  // Dispose of any resources that can be recreated.
}

@end
