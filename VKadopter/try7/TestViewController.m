

#import "TestViewController.h"
#import "ApiCallViewController.h"

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getUser:(id)sender {
    VKRequest *request = [[VKApi users] get];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Result: %@", response);
    }                    errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)getSubscriptions:(id)sender {
    VKRequest *request = [[VKApi users] getSubscriptions:@{VK_API_EXTENDED : @(1), VK_API_COUNT : @(100)}];
    request.secure = NO;
    [request executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Result: %@", response);

    }                    errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

static NSArray *labels = nil;
static NSString *const AUDIO_GET = @"audio.get";
static NSString *const TEST_CAPTCHA = @"Test captcha";

//Fields
static NSString *const ALL_USER_FIELDS = @"id,first_name,last_name,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,online_mobile,lists,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,common_count,relation,relatives,counters";

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!labels)
        labels = @[AUDIO_GET, TEST_CAPTCHA];
    return labels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestRow"];
    UILabel *label = (UILabel *) [cell viewWithTag:1];
    label.text = labels[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *label = labels[indexPath.row];
    if ([label isEqualToString:TEST_CAPTCHA]) {
        [self testCaptcha];
    }
    else if ([label isEqualToString:AUDIO_GET]) {
        [self callMethod:[VKRequest requestWithMethod:@"audio.get" parameters:nil modelClass:[VKAudios class]]];
    }
}

- (VKUsersArray *)loadUsers {
    __block VKUsersArray *users;
    VKRequest *request = [[VKApi friends] get:@{@"user_id" : @1}];
    request.waitUntilDone = YES;
    [request executeWithResultBlock:^(VKResponse *response) {
        users = response.parsedModel;
    }                    errorBlock:nil];
    return users;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"API_CALL"]) {
        ApiCallViewController *vc = [segue destinationViewController];
        vc.callingRequest = self->callingRequest;
        self->callingRequest = nil;
    }
}

- (void)callMethod:(VKRequest *)method {
    self->callingRequest = method;
    [self performSegueWithIdentifier:@"API_CALL" sender:self];
}

- (void)testCaptcha {
    VKRequest *request = [[VKApiCaptcha new] force];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Result: %@", response);
    }                    errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}







- (void)logout:(id)sender {
    [VKSdk forceLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
