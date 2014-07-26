#import "KingTidesViewController.h"
#import "KingTideLocationViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"
#import "Notifications.h"

@interface KingTidesViewController ()

@property(nonatomic, strong) NSArray *locations;
-(BOOL)parseJSONData:(NSArray*)JSONData;

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
  self.tableView.opaque = NO;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default-background.jpg"]];
  [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"TideList"
                                                    forKey:kGAIScreenName] build]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivingJSON:) name:kDownloadSuccessfully object:nil];
    
    self.downloadWorker= [DownloadWorker sharedDownloadWorker];
    [self.downloadWorker queueDownloadOperation:nil];//retrieve the JSON data
    self.tideInfoArray= [NSMutableArray array];
    
    

}
-(void)onReceivingJSON:(NSNotification*) note
{
    if ([self parseJSONData:[note.userInfo objectForKey:@"downloadJSON"]]) {
        [[self tableView] reloadData];
    }
    
    
}
-(BOOL)parseJSONData:(NSArray *)JSONData
{
    if (JSONData==nil||![JSONData isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    for(NSDictionary* item in JSONData)
    {
        TideInfo* oneTideInfo= [[TideInfo alloc] init];
        if(![[item objectForKey:@"id"] isKindOfClass: [NSString class]] ||[item objectForKey:@"id"]==nil)
            continue;
        oneTideInfo.tideID=[item objectForKey:@"id"];
        
        if(![[item objectForKey:@"event"] isKindOfClass: [NSDictionary class]] ||[item objectForKey:@"event"]==nil)
            continue;
        NSDictionary* eventInfo=[item objectForKey:@"event"];
        
        
        if ([eventInfo objectForKey:@"location"]==nil ||![[eventInfo objectForKey:@"location"] isKindOfClass:[NSString class]]) {
            continue;
        }
        oneTideInfo.location=[eventInfo objectForKey:@"location"];
        
        if ([eventInfo objectForKey:@"state"]==nil ||![[eventInfo objectForKey:@"state"] isKindOfClass:[NSString class]]) {
            continue;
        }
        oneTideInfo.state=[eventInfo objectForKey:@"state"];
        
        
        if ([eventInfo objectForKey:@"description"]==nil ||![[eventInfo objectForKey:@"description"] isKindOfClass:[NSString class]]) {
            continue;
        }
        oneTideInfo.description=[eventInfo objectForKey:@"description"];
        
        if ([eventInfo objectForKey:@"highTideOccurs"]==nil ||![[eventInfo objectForKey:@"highTideOccurs"] isKindOfClass:[NSString class]]) {
           continue;
        }
        oneTideInfo.hightTideOccurs=[eventInfo objectForKey:@"highTideOccurs"];
        
        if ([eventInfo objectForKey:@"eventStart"]==nil ||![[eventInfo objectForKey:@"eventStart"] isKindOfClass:[NSString class]]) {
            continue;
        }
        oneTideInfo.eventStarts=[eventInfo objectForKey:@"eventStart"];
        
        if ([eventInfo objectForKey:@"eventEnd"]==nil ||![[eventInfo objectForKey:@"eventEnd"] isKindOfClass:[NSString class]]) {
            continue;
        }
        oneTideInfo.eventEnds=[eventInfo objectForKey:@"eventEnd"];
        
        if ([eventInfo objectForKey:@"latitude"]==nil ||![[eventInfo objectForKey:@"latitude"] isKindOfClass:[NSNumber class]]) {
            continue;
        }
        oneTideInfo.latitude=[eventInfo objectForKey:@"latitude"];
        
        if ([eventInfo objectForKey:@"longitude"]==nil ||![[eventInfo objectForKey:@"longitude"] isKindOfClass:[NSNumber class]]) {
            continue;
        }
        oneTideInfo.longtitude=[eventInfo objectForKey:@"longitude"];
        
        if ([eventInfo objectForKey:@"__v"]==nil ||![[eventInfo objectForKey:@"__v"] isKindOfClass:[NSNumber class]]) {
            continue;
        }
        oneTideInfo.version= [eventInfo objectForKey:@"__v"];
        
        [[self tideInfoArray] addObject:oneTideInfo];
        
    }
    return YES;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.locations.count;
    
    return [[self tideInfoArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  cell.textLabel.text = self.locations[(NSUInteger) indexPath.row];
  CGRect frame = cell.textLabel.frame;
  frame.size.height = 20;
  cell.textLabel.frame = frame;
  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.textColor = [UIColor whiteColor];
  cell.textLabel.backgroundColor = [UIColor colorWithRed:(68.0f/255.0f) green:(168.0f/255.0f) blue:(218.0f/255.0f) alpha:1];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  // This will create a "invisible" footer
  return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor clearColor];
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  // This will create a "invisible" footer
  return 40.f;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  KingTideLocationViewController *detailViewController = [[KingTideLocationViewController alloc] init];
  [self.navigationController pushViewController:detailViewController animated:YES];
  detailViewController.locationName = self.locations[(NSUInteger) indexPath.row];
}


@end
