
#import "MainViewController.h"
#import "PhotoSelectionViewController.h"
#import "WBSuccessNoticeView.h"
#import "WBErrorNoticeView.h"
#import "MapViewController.h"
#import "KingTidesViewController.h"
#import "Notifications.h"

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

- (void)viewDidLoad
{
  [super viewDidLoad];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        [self setEdgesForExtendedLayout:UIRectEdgeTop];
//    }
  self.screenName = @"LandingScreen";
  [[NSNotificationCenter defaultCenter] addObserverForName:kUploadedSuccessfully object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    WBSuccessNoticeView *successNoticeView = [[WBSuccessNoticeView alloc] initWithView:self.view title:@"Successfully uploaded photo."];
    successNoticeView.alpha = 0.9;
    [successNoticeView show];
  }];
  [[NSNotificationCenter defaultCenter] addObserverForName:kUploadFailed object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    WBErrorNoticeView *noticeView = [WBErrorNoticeView errorNoticeInView:self.view title:@"Network Error" message: @"Could not upload photo at this time."];
    noticeView.alpha = 0.9;
    noticeView.sticky = NO;
    [noticeView show];
  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)showTakeDialog:(id)sender {
  PhotoSelectionViewController *photoSelectionViewController = [[PhotoSelectionViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoSelectionViewController];
  navController.modalTransitionStyle = photoSelectionViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)showMap:(id)sender {
  MapViewController *mapViewController = [[MapViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
  navController.modalTransitionStyle = mapViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)showKingTides:(id)sender {
  KingTidesViewController *mapViewController = [[KingTidesViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
  navController.modalTransitionStyle = mapViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}

@end
