#import "KingTideLocationViewController.h"

@interface KingTideLocationViewController ()


@end

@implementation KingTideLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.locationNameLabel.text = self.locationName;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
