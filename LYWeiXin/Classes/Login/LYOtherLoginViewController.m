//
//  LYOtherLoginViewController.m
//  LYWeiXin
//
//  Created by Joe on 16/7/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYOtherLoginViewController.h"
#import "LYXMPPHelper.h"

@interface LYOtherLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LYOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _accountTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kAccount];
    _passwordTextField.text = @"liu6569567";
    [self textFieldTextDidChange:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_accountTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_passwordTextField];
}

- (void)textFieldTextDidChange:(NSNotification *)noti {
    _loginBtn.enabled = ![_accountTextField.text isEqualToString:@""] && ![_passwordTextField.text isEqualToString:@""];
    UITextField *textField = noti.object;
    if (textField == _accountTextField) {
//        LYLog(@"_accountTextField");
    } else {
//        LYLog(@"_passwordTextField");
    }
}

- (IBAction)login:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在登陆ing"];
    [[LYXMPPHelper sharedManager] loginWithAccount:_accountTextField.text password:_passwordTextField.text completed:^(LYXMPPStatus status) {
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

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
