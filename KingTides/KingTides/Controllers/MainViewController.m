
#import "MainViewController.h"
#import "PhotoSelectionViewController.h"
#import "WBSuccessNoticeView.h"
#import "WBStickyNoticeView.h"


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
  [[NSNotificationCenter defaultCenter] addObserverForName:@"UploadSuccess" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    WBSuccessNoticeView *successNoticeView = [[WBSuccessNoticeView alloc] initWithView:self.view title:NSLocalizedString(@"incidentUpload:Successful:Title", @"Successfully reported incident.")];
    successNoticeView.alpha = 0.9;
    [successNoticeView show];
  }];
  [[NSNotificationCenter defaultCenter] addObserverForName:@"UploadFailed" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    WBStickyNoticeView *noticeView = [[WBStickyNoticeView alloc] initWithView:self.view title:NSLocalizedString(@"incidentUpload:Failed:Title", @"Could not upload incident at this time.")];
    noticeView.alpha = 0.9;
    noticeView.sticky = NO;
    [noticeView show];
  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}



@end
