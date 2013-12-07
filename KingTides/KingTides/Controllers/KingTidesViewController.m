#import "KingTidesViewController.h"
#import "KingTideLocationViewController.h"

@interface KingTidesViewController ()

@property(nonatomic, strong) NSArray *locations;

@end

@implementation KingTidesViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.locations = @[@"HERVEY BAY", @"BUNDABERG", @"WADDY POINT", @"NOOSAVILLE"];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dismissView {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  cell.textLabel.text = self.locations[(NSUInteger) indexPath.row];

  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  KingTideLocationViewController *detailViewController = [[KingTideLocationViewController alloc] init];
  [self.navigationController pushViewController:detailViewController animated:YES];
  detailViewController.locationName = self.locations[(NSUInteger) indexPath.row];
}


@end
