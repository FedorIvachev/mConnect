

#import <UIKit/UIKit.h>
#import <VKSdk.h>

@interface ApiCallViewController : UIViewController
@property(nonatomic, strong) IBOutlet UILabel *methodName;
@property(nonatomic, strong) IBOutlet UITextView *callResult;
@property(nonatomic, strong) VKRequest *callingRequest;
@end
