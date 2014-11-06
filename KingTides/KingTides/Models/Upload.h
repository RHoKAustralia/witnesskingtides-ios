#import "MTLModel+NSCoding.h"
#import "MTLJSONAdapter.h"

@class CLLocation;

@interface Upload : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *uploadDescription;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *fileId;

- (id)initWithName:(NSString *)firstName andEmail:(NSString *)email andDescription:(NSString *)description andDate:(NSDate *)date andLocation:(CLLocation *)location andImage:(UIImage *)image;

+ (void)removeUpload:(Upload *)upload;

+ (NSArray *)loadUnsaved;

- (void)saveToDisk;
@end