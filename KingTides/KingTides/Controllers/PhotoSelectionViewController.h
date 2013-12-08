
#import <UIKit/UIKit.h>

@interface PhotoSelectionViewController : UIViewController

@property (nonatomic, strong)IBOutlet UIImageView *imageView;
@property (nonatomic, strong)IBOutlet UIImageView *placeHolderImageView;
@property (nonatomic, strong)IBOutlet UIButton *takeImageButton;

- (IBAction)takePhoto:(id)sender;

@end
