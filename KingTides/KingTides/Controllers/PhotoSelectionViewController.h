
#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface PhotoSelectionViewController : GAITrackedViewController

@property (nonatomic, strong)IBOutlet UIImageView *imageView;
@property (nonatomic, strong)IBOutlet UIImageView *placeHolderImageView;
@property (nonatomic, strong)IBOutlet UIButton *takeImageButton;

- (IBAction)takePhoto:(id)sender;

@end
