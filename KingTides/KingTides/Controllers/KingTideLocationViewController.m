#import "KingTideLocationViewController.h"

@interface KingTideLocationViewController ()


@end

@implementation KingTideLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.screenName = @"KingTideLocation";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.locationNameLabel.text = self.locationName;
  self.screenName = [NSString stringWithFormat:@"KingTideLocation: %@", self.locationName];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
