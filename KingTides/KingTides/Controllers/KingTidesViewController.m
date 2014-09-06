#import "KingTidesViewController.h"
#import "KingTideLocationViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"
#import "KingTidesService.h"
#import "MBProgressHUD.h"

#define kHeightOfCell 40
#define kIndicatingWindowShowingTime 1
#define kDefaultSelectedState 0;

@interface KingTidesViewController ()
@property(nonatomic,strong) NSDictionary* tideInfoDivideByState;
@property(nonatomic,strong) NSArray* locations;
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UISegmentedControl*stateFilter;
-(void)showIndication:(UIView*) view message:(NSString*) info duration:(unsigned int) sleepTime;
@end

@implementation KingTidesViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.stateFilter = [[UISegmentedControl alloc] initWithItems:@[@"QLD", @"NSW", @"VIC", @"TAS", @"WA", @"SA", @"NT"]];
    [self.stateFilter sizeToFit];
    [self.stateFilter addTarget:self
                         action:@selector(stateChanged:)
               forControlEvents:UIControlEventValueChanged];
    self.stateFilter.selectedSegmentIndex = kDefaultSelectedState;
    self.navigationItem.titleView = self.stateFilter;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
  }
  return self;
}

- (void)showIndication:(UIView *)view message:(NSString *)info duration:(unsigned int)sleepTime {
  MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
  [self.view addSubview:HUD];
  HUD.labelText = info;
  HUD.mode = MBProgressHUDModeText;
  [HUD showAnimated:YES whileExecutingBlock:^{
      sleep(sleepTime);
  } completionBlock:^{
      [HUD removeFromSuperview];
  }];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.opaque = NO;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default-background.jpg"]];
  [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"TideList"
                                                    forKey:kGAIScreenName] build]];
  [[KingTidesService sharedService] retrieveTideData:
                  ^(NSArray *list) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tideInfoDivideByState = [TideInfo groupDataByState:[NSArray arrayWithArray:list]];
                        self.locations = self.tideInfoDivideByState[self.selectedState];
                        [[self tableView] reloadData];
                    });
                  }
                  failure:^(NSError *error) {
                    [self showIndication:self.view message:@"Failed to retrieve current tides. Please try again another time." duration:kIndicatingWindowShowingTime];
                  }];

  //hide the fussy cell
  UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tableView setTableFooterView:v];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dismissView {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kHeightOfCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  CGRect frame = cell.textLabel.frame;

  cell.textLabel.frame = frame;
  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.textColor = [UIColor whiteColor];
  cell.textLabel.backgroundColor = [UIColor colorWithRed:(68.0f / 255.0f) green:(168.0f / 255.0f) blue:(218.0f / 255.0f) alpha:1];
  TideInfo *info = self.locations[indexPath.row];
  cell.textLabel.text = info.location;
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  KingTideLocationViewController *detailViewController = [[KingTideLocationViewController alloc] init];
  TideInfo *info = self.locations[indexPath.row];
  detailViewController.locationName = info.location;
  detailViewController.description = info.description;
  detailViewController.tideOccurs = info.hightTideOccurs;
  detailViewController.eventStarts = info.eventStarts;
  detailViewController.eventEnds = info.eventEnds;
  [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)stateChanged:(id)stateChanged {
  self.locations = self.tideInfoDivideByState[self.selectedState];
  [self.tableView reloadData];
}

- (NSString *)selectedState {
  return [[self.stateFilter titleForSegmentAtIndex:self.stateFilter.selectedSegmentIndex] lowercaseString];
}

@end
