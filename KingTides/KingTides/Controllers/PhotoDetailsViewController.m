#import "PhotoDetailsViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "NSData+Base64.h"
#import "NSDate+Formatting.h"
#import "KingTidesService.h"

@interface PhotoDetailsViewController ()

@property(nonatomic, strong) UIImage *photo;
@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) KingTidesService *service;
@end

@implementation PhotoDetailsViewController

- (id)init {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPhoto)];
    self.service = [[KingTidesService alloc] init];
  }
  return self;
}

- (void)uploadPhoto {
  [self.service uploadPhoto:self.nameTextField.text
                description:self.descriptionTextView.text
                      email:self.emailTextField.text
                   location:self.location
                      photo:self.imageView.image];

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
