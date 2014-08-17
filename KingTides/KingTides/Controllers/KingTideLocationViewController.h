
#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface KingTideLocationViewController : GAITrackedViewController

@property (nonatomic, strong) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, strong) IBOutlet UITextView *tideDetailsTextView;

@property (nonatomic,copy)NSString*  locationName;
@property (nonatomic,copy)NSString*  description;
@property (nonatomic,copy)NSString*  tideOccurs;
@property (nonatomic,copy)NSString*  eventStarts;
@property (nonatomic,copy)NSString*  eventEnds;



@end
