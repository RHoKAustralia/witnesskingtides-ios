#import "PhotoDetailsViewController.h"
#import "ResilientUploader.h"
#import "Upload.h"

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
  ResilientUploader *uploader = [ResilientUploader sharedUploader];
  Upload *upload = [[Upload alloc] initWithName:self.nameTextField.text
                                       andEmail:self.emailTextField.text
                                 andDescription:self.descriptionTextView.text
                                        andDate:[NSDate date]
                                    andLocation:self.location
                                       andImage:self.imageView.image];
  [uploader save:upload];
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
