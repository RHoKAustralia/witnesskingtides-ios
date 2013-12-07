
#import <UIKit/UIKit.h>

@interface PhotoDetailsViewController : UIViewController

@property (nonatomic, strong)IBOutlet UIImageView *imageView;

- (void)updatePhoto:(UIImage *)image;
@end
