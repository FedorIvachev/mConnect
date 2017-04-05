

#import "ApiCallViewController.h"

@interface ApiCallViewController ()

@end

@implementation ApiCallViewController

- (void)dealloc {
    [self.callingRequest cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.methodName.text = self.callingRequest.methodName;
    self.callingRequest.debugTiming = YES;
    self.callingRequest.requestTimeout = 10;

    __weak __typeof(self) welf = self;
    [self.callingRequest executeWithResultBlock:^(VKResponse *response) {
        welf.callResult.text = [NSString stringWithFormat:@"Result: %@", response];
        welf.callingRequest = nil;
        NSLog(@"%@", response.request.requestTiming);
    }                                errorBlock:^(NSError *error) {
        welf.callResult.text = [NSString stringWithFormat:@"Error: %@", error];
        welf.callingRequest = nil;
    }];
}

@end
