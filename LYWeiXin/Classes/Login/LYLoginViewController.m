//
//  LYLoginViewController.m
//  LYWeiXin
//
//  Created by Joe on 16/7/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYLoginViewController.h"

@interface LYLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userLabel.text = [LYXMPPHelper sharedManager].account;
//    _loginBtn.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_pwdField];
}

- (void)textFieldTextDidChange:(NSNotification *)noti {
    _loginBtn.enabled = ![_pwdField.text isEqualToString:@""];
}

- (IBAction)loginBtnClick:(UIButton *)btn {
    [MBProgressHUD showMessage:@"正在登陆ing"];
    [[LYXMPPHelper sharedManager] loginWithAccount:_userLabel.text password:_pwdField.text completed:^(LYXMPPStatus status) {
        [MBProgressHUD hideHUD];
        switch (status) {
            case LYXMPPStatusLoginSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:LYXMPPLoginSuccessNotification object:nil];
                [[UIApplication sharedApplication] delegate].window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
                [MBProgressHUD showSuccess:@"成功登陆"];
                break;
            case LYXMPPStatusLoginError:
                [MBProgressHUD showError:@"账号或密码错误"];
                break;
            case LYXMPPStatusLoginTimeOut:
                [MBProgressHUD showError:@"连接超时, 请重试"];
                break;
            default:
                break;
        }
    }];
}

- (void)dealloc {
    LYLog(@"");
}

@end
