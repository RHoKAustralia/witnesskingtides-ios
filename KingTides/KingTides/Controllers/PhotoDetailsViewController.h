
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PhotoDetailsViewController : UIViewController

@property (nonatomic, strong)IBOutlet UIImageView *imageView;
@property (nonatomic, strong)IBOutlet UITextField *nameTextField;
@property (nonatomic, strong)IBOutlet UITextField *emailTextField;
@property (nonatomic, strong)IBOutlet UITextField *descriptionTextField;

- (void)updatePhoto:(UIImage *)image;

- (void)updateLocation:(CLLocation *)location;
@end
