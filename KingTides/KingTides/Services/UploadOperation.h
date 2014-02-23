@class UploadOperation;
@class Upload;

@protocol UploadOperationProtocol <NSObject>
- (void)uploadSuccessful:(UploadOperation *)operation upload:(Upload *)upload;
- (void)uploadFailed:(UploadOperation *)operation error:(NSError *)error upload:(Upload *)upload;
@end

@interface UploadOperation : NSOperation

@property (nonatomic, strong) Upload *upload;
@property (nonatomic, weak) id<UploadOperationProtocol> delegate;

- (id)initWithUpload:(Upload *)upload;
@end