
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"

@interface PhotoDetailsViewController : GAITrackedViewController

@property (nonatomic, strong)IBOutlet UIImageView *imageView;
@property (nonatomic, strong)IBOutlet UITextField *nameTextField;
@property (nonatomic, strong)IBOutlet UITextField *emailTextField;
@property (nonatomic, strong)IBOutlet UITextView *descriptionTextView;

- (void)updatePhoto:(UIImage *)image;

- (void)updateLocation:(CLLocation *)location;
@end
