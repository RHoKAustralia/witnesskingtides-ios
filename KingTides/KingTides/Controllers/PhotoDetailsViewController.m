#import "PhotoDetailsViewController.h"

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
