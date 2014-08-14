#import "KingTidesViewController.h"
#import "KingTideLocationViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"
#import "Notifications.h"
#import "UIImageView+AFNetworking.h"
#import "TideInfo.h"
#import "KingTidesService.h"
#import "MBProgressHUD.h"


#define kHeightOfSearchBar 40
#define kHeightOfCell 40
#define kIndicatingWindowShowingTime 1


@interface KingTidesViewController ()
@property(nonatomic,strong) NSDictionary* tideInfoDivideByState;
@property(nonatomic,strong) UISearchBar* searchBar;
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) NSArray *locations;
-(void)showIndication:(UIView*) view message:(NSString*) info duration:(unsigned int) sleepTime;
-(void)setupSearchBar;

//-(BOOL)parseJSONData:(NSArray*)JSONData;
//-(NSArray*)calculateNumbersOfJSON;

@end

@implementation KingTidesViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
  }
  return self;
}

-(void)showIndication:(UIView*) view message:(NSString*) info duration:(unsigned int) sleepTime
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:view] ;
    [self.view addSubview:HUD];
    HUD.labelText = info;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(sleepTime);
    } completionBlock:^{
        [HUD removeFromSuperview];
        //[HUD release];
        //HUD = nil;
    }];
    
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.opaque = NO;
  self.tableView.separatorStyle=UITableViewStylePlain;
  //  self.tableView.separatorStyle= UITableViewStyleGrouped;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default-background.jpg"]];
  [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"TideList"
                                                    forKey:kGAIScreenName] build]];
  [[KingTidesService sharedService] retrieveTideData:
   ^(id retrievedData)
    {
        
        if ([retrievedData isKindOfClass:[NSArray class]])
        {
            NSMutableArray* recordArray= [NSMutableArray array];
            for (NSDictionary* dict in retrievedData)
            {
                //binding the key value with property of TideInfo
                TideInfo *model = [MTLJSONAdapter modelOfClass:[TideInfo class]
                                                 fromJSONDictionary:dict
                                                              error:nil];
                [recordArray addObject:model];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tideInfoDivideByState=[TideInfo groupDataByState:[NSArray arrayWithArray:recordArray ]];
                [[self tableView] reloadData];
            });

            
        }
   
    }
    failure: ^(NSError *error)
    {
        [self showIndication:self.view message:@"Fail! Please try again" duration:kIndicatingWindowShowingTime];

    }];
        
  
    [self setupSearchBar];
    //hide the fussy cell
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    
    

}
-(void)setupSearchBar
{
    CGRect rect= [[self view] frame];
    self.searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, kHeightOfSearchBar)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.placeholder=@"TAS SA WA NT QLD NSW VIC";
    self.searchBar.hidden=NO;
    self.searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    self.searchBar.alpha=0;
    self.searchBar.opaque=YES;
    [self.searchBar sizeToFit];
   
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dismissView {
  [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)search
{
    [[self view] addSubview:self.searchBar];
    [UISearchBar animateWithDuration:0.25 animations:^{
        self.searchBar.alpha=1;
        self.searchBar.opaque=NO;
    }];
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightOfCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //@"TAS SA WA NT QLD NSW VIC"
    NSArray* stateArray=@[@"nsw",@"NSW",@"vic",@"VIC",@"QLD",@"qld",@"nt",@"NT",@"wa",@"WA",@"SA",@"sa",@"tas",@"TAS"];
    
    NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""]) {
        rowsOfSection=[self.tideInfoDivideByState objectForKey:@"nsw"];
    }
    else
    {
        if([stateArray containsObject:self.searchBar.text])
        {
            NSString* searchString=[self.searchBar.text lowercaseString];
            rowsOfSection=[self.tideInfoDivideByState objectForKey:searchString];
        }
        else
        {
            [self showIndication:self.view message:@"input error" duration:kIndicatingWindowShowingTime];
            return 0;
        }
    }
        
        
    
    
    return [rowsOfSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    CGRect frame = cell.textLabel.frame;
    frame.size.height = 20;
    
    cell.textLabel.frame = frame;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor colorWithRed:(68.0f/255.0f) green:(168.0f/255.0f) blue:(218.0f/255.0f) alpha:1];
    NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""])
    {
        rowsOfSection=[self.tideInfoDivideByState objectForKey:@"nsw"];
    }
    else
    {
        NSArray* stateArray=@[@"nsw",@"NSW",@"vic",@"VIC",@"QLD",@"qld",@"nt",@"NT",@"wa",@"WA",@"SA",@"sa",@"tas",@"TAS"];
        if ([stateArray containsObject:[self.searchBar.text lowercaseString]])
        {
            rowsOfSection=[self.tideInfoDivideByState objectForKey:[self.searchBar.text lowercaseString] ];
        }
        else
        {
            [self showIndication:self.view message:@"input error" duration:kIndicatingWindowShowingTime];
            return nil;
        }
            

        
    }
    TideInfo* info=[rowsOfSection objectAtIndex:indexPath.row];
    cell.textLabel.text=info.location;
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    return  cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""])
    {
        return @"NSW State";
    }
    else
        return [NSString stringWithFormat:@"%@ State",[[[self searchBar] text] uppercaseString ]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  // This will create a "invisible" footer
  return kHeightOfSearchBar;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KingTideLocationViewController *detailViewController = [[KingTideLocationViewController alloc] init];
    NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""])
    {
        rowsOfSection=[self.tideInfoDivideByState objectForKey:@"nsw"];
    }
    else
        rowsOfSection=[self.tideInfoDivideByState objectForKey:[self.searchBar.text lowercaseString ]];
    TideInfo* info= [rowsOfSection objectAtIndex:indexPath.row];
    detailViewController.locationName=info.location;
    detailViewController.description=info.description;
    detailViewController.tideOccurs=info.hightTideOccurs;
    detailViewController.eventStarts=info.eventStarts;
    detailViewController.eventEnds=info.eventEnds;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
    [searchBar setShowsCancelButton:YES animated:YES];
    searchBar.showsScopeBar = NO;
    searchBar.selectedScopeButtonIndex = 0;
    searchBar.placeholder=@"";
    [searchBar sizeToFit];
    
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(searchText);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [ searchBar resignFirstResponder];
    // The above statement will disable "Cancel" button. We need to enable it
    for (id subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            [subview setEnabled:YES];
        }
    }
    
    [UISearchBar animateWithDuration:0.25 animations:^{
        self.searchBar.alpha=0;
        self.searchBar.opaque=NO;
    }];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [UISearchBar animateWithDuration:0.25 animations:^{
        self.searchBar.alpha=0;
        self.searchBar.opaque=YES;
    }];
    [[self tableView] reloadData];
    [searchBar resignFirstResponder];
    // The above statement will disable "Cancel" button. We need to enable it
    for (id subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            [subview setEnabled:YES];
        }
    }
}




@end
