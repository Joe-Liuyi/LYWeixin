//
//  LYHomeViewController.m
//  LYWeiXin
//
//  Created by Joe on 16/7/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYHomeViewController.h"
#import "LYXMPPHelper.h"

 
@interface LYHomeViewController ()  
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginBtn;
@property (nonatomic, strong) UIView *loadingTitleView;
@end

@implementation LYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginBtn.title = [[LYXMPPHelper sharedManager] isLogin] ? @"断开" : @"登陆";
    
    _loadingTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 114, 44)];
    [self.view addSubview:_loadingTitleView];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(0, 0, 44, 44);
    [activityView startAnimating];
    [_loadingTitleView addSubview:activityView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 70, 44)];
    loadingLabel.text = @"loading";
    loadingLabel.font = [UIFont systemFontOfSize:16.0];
    loadingLabel.textColor = [UIColor whiteColor];
    [_loadingTitleView addSubview:loadingLabel]; 
    
    self.navigationItem.titleView = _loadingTitleView;
    
    if (![LYXMPPHelper sharedManager].isConnect) {
        [[LYXMPPHelper sharedManager] loginWithCompleted:^(LYXMPPStatus status) {
            switch (status) {
                case LYXMPPStatusLoginSuccess:
                    self.navigationItem.titleView = nil;
                    break;
                case LYXMPPStatusLoginError:
                    
                    break;
                case LYXMPPStatusLoginTimeOut:
                    
                    break;
                default:
                    break;
            }
        }];
    }
}


- (IBAction)login:(UIBarButtonItem *)sender {
    UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
    if ([sender.title isEqualToString:@"登录"]) {
        
    } else {
        sender.title = @"登录";
        [[LYXMPPHelper sharedManager] loginOut];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

    // Configure the cell...

    return cell;
}
*/

@end
