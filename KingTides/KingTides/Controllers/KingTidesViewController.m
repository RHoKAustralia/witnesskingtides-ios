#import "KingTidesViewController.h"
#import "KingTideLocationViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"
#import "Notifications.h"
#import "UIImageView+AFNetworking.h"
#define heightOfSearchBar 40
#define heightOfCell 20

@interface KingTidesViewController ()
@property (nonatomic,strong) NSMutableArray* tideInfoArray;
@property(nonatomic,strong) NSMutableArray* stateArray;
@property(nonatomic,strong) NSMutableDictionary* tideInfoDivideByState;
@property(nonatomic,strong) DownloadWorker* downloadWorker;
@property(nonatomic,strong)UISearchBar* searchBar;
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic, strong) NSArray *locations;

-(BOOL)parseJSONData:(NSArray*)JSONData;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivingJSON:) name:kDownloadSuccessfully object:nil];
    
    self.downloadWorker= [DownloadWorker sharedDownloadWorker];
    [self.downloadWorker queueDownloadOperation:nil];//retrieve the JSON data
    self.tideInfoArray= [NSMutableArray array];
    
    self.tideInfoDivideByState=[NSMutableDictionary dictionary];
    self.stateArray= [NSMutableArray array];
    //UISearchBar
    // set toolbar items
    CGRect rect= [[self view] frame];
    
    UISearchBar* mySearchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, heightOfSearchBar)];
    mySearchBar.delegate = self;
    mySearchBar.showsCancelButton = NO;
    mySearchBar.barStyle=UIBarStyleDefault;
    mySearchBar.placeholder=@"ENTER TAS SA WA NT QLD NSW VIC UNDEFINED";
    mySearchBar.hidden=NO;
    mySearchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    mySearchBar.alpha=0;
    //mySearchBar.scopeButtonTitles = @[@"城市搜索", @"全国搜索"];
    [mySearchBar sizeToFit];
    [self setSearchBar:mySearchBar];
    //[[self view] addSubview: [self searchBar]];
    
    

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
        
        if ([eventInfo objectForKey:@"latitude"]==nil ||![[eventInfo objectForKey:@"latitude"] isKindOfClass:[NSNumber class]])
        {
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
    
    //NSMutableArray* stateArray= [NSMutableArray array];
    //if ([self.tideInfoArray count]==0) {
    //    return 0;
    //}
    TideInfo* tide0= [[self tideInfoArray] objectAtIndex:0];
    [self.stateArray addObject:tide0.state];
    
    for (int count2=1;count2< [[self tideInfoArray] count];count2++)
        
    {
        TideInfo* tide2= [[self tideInfoArray] objectAtIndex:count2];
        
        
        if (![self.stateArray containsObject:tide2.state] )
        {
            [self.stateArray addObject:tide2.state];
        }
        
    }
    
    for (NSString* stateNmae in self.stateArray)
    {
        NSMutableArray* sectionArray= [NSMutableArray array];
        //NSInteger countOfRowsInSection=0;
        for (TideInfo* info in [self tideInfoArray]) {
            if ([info.state isEqualToString:stateNmae]) {
                [sectionArray addObject:info];
                //++countOfRowsInSection;
            }
        }
        [self.tideInfoDivideByState setObject:sectionArray forKey:stateNmae];
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
-(void)search
{
    [[self view] addSubview:self.searchBar];
    [UISearchBar animateWithDuration:0.25 animations:^{
        self.searchBar.alpha=1;
    }];
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return heightOfCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""]) {
        rowsOfSection=[self.tideInfoDivideByState objectForKey:@"nsw"];
    }
    else
        rowsOfSection=[self.tideInfoDivideByState objectForKey:self.searchBar.text];
    
    return [rowsOfSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];

    
    
    NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""]) {
        rowsOfSection=[self.tideInfoDivideByState objectForKey:@"nsw"];
    }
    else
        rowsOfSection=[self.tideInfoDivideByState objectForKey:self.searchBar.text];
    
    
    //rowsOfSection=[self.tideInfoDivideByState objectForKey:self.searchBar.text];
    TideInfo* info=[rowsOfSection objectAtIndex:indexPath.row];
    //NSString* tideInfo=[NSString stringWithFormat:@"King tide's description:%@\nhigh tide occur:%@\n start from:%@\n end at%@\n latitude:%f\n longtitude:%f",info.description,info.hightTideOccurs,info.eventStarts,info.eventEnds,[info.latitude floatValue],[info.longtitude floatValue]];
    cell.textLabel.text=info.location;
    //cell.detailTextLabel.text=tideInfo;
    return  cell;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  // This will create a "invisible" footer
  return 40.0f;
}
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""])
    {
        return @"NSW State";
    }
    else
        return [NSString stringWithFormat:@"%@ State",[[self searchBar] text] ];
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor clearColor];
  return view;
}
 */
 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  // This will create a "invisible" footer
  return heightOfSearchBar;
}
 


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  KingTideLocationViewController *detailViewController = [[KingTideLocationViewController alloc] init];
  
    NSMutableArray* rowsOfSection=nil;
    if ([self.searchBar.text isEqualToString:@""]) {
        rowsOfSection=[self.tideInfoDivideByState objectForKey:@"nsw"];
    }
    else
        rowsOfSection=[self.tideInfoDivideByState objectForKey:self.searchBar.text];
    TideInfo* info= [rowsOfSection objectAtIndex:indexPath.row];
    detailViewController.locationName=info.location;
    detailViewController.description=info.description;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    

}

#pragma UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
    
    //可以设置 显示scopeButtonTitles
    [searchBar setShowsCancelButton:YES animated:YES];
    searchBar.showsScopeBar = NO;
    searchBar.selectedScopeButtonIndex = 0;
    //searchBar.scopeButtonTitles = @[@"城市搜索", @"全国搜索"];
    //searchBar.showsScopeBar = YES;
    searchBar.placeholder=@"";
    [searchBar sizeToFit];
    
    
}
/*
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope

{
    
    NSString *s0 = [searchBar.scopeButtonTitles objectAtIndex: selectedScope];
    
    
}
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(searchText);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [ searchBar resignFirstResponder];
    
    // The above statement will disable "Cancel" button. We need to enable it
    for (id subview in searchBar.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    
    [UISearchBar animateWithDuration:0.25 animations:^{
        self.searchBar.alpha=0;
    }];
    
    
    
    //searchBar.placeholder = @"ENTER TAS SA WA NT QLD NSW VIC UNDEFINED ";
    //[searchBar setShowsCancelButton:NO animated:YES];
    //[searchBar sizeToFit];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [UISearchBar animateWithDuration:0.25 animations:^{
        self.searchBar.alpha=0;
    }];
    [[self tableView] reloadData];
    
    [ searchBar resignFirstResponder];
    
    // The above statement will disable "Cancel" button. We need to enable it
    for (id subview in searchBar.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }

    
}




@end
