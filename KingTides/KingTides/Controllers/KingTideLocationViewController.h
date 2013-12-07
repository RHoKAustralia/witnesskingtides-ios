
#import <UIKit/UIKit.h>

@interface KingTideLocationViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, strong) IBOutlet UITextView *tideDetailsTextView;

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *description;

@end
