#import "KingTideLocationViewController.h"

@interface KingTideLocationViewController ()
@property(nonatomic,strong)NSDateFormatter* dateFormatter;
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
    if (self.dateFormatter==nil)
    {
        self.dateFormatter= [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000z"];
        
        
    }
    NSDate* tideOccurDate=[self.dateFormatter dateFromString:self.tideOccurs];
    NSDate* eventStats=[self.dateFormatter dateFromString:self.eventStarts];
    NSDate* eventEnds=[self.dateFormatter dateFromString:self.eventEnds];

    self.dateFormatter.dateStyle=kCFDateFormatterMediumStyle;
    self.dateFormatter.timeStyle=kCFDateFormatterShortStyle;
    NSString* tideOccurDateString=[self.dateFormatter stringFromDate:tideOccurDate];
    NSString* eventStartsString=[self.dateFormatter stringFromDate:eventStats];
    NSString* eventEndsString=[self.dateFormatter stringFromDate:eventEnds];
    self.locationNameLabel.text = self.locationName;
    self.tideDetailsTextView.text=[NSString stringWithFormat:@"The King Tide will occur on %@.\n\nYou can witness the effect of the King Tide between %@ and %@.",tideOccurDateString,eventStartsString,eventEndsString];
    self.screenName = [NSString stringWithFormat:@"KingTideLocation: %@", self.locationName];
}

@end
