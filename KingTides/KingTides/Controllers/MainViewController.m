
#import "MainViewController.h"
#import "PhotoSelectionViewController.h"


@interface MainViewController()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)showTakePhotoDialog:(id)sender {
  PhotoSelectionViewController *photoSelectionViewController = [[PhotoSelectionViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoSelectionViewController];
  navController.modalTransitionStyle = photoSelectionViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
