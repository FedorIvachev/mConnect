

#import <UIKit/UIKit.h>
#import <VKSdk.h>

@interface TestViewController : UITableViewController {
@private
    VKRequest *callingRequest;
}
@property(nonatomic, strong) IBOutlet UILabel *tokenLabel;
@end
