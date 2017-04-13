//
//  LYRegisterViewController.m
//  LYWeiXin
//
//  Created by Joe on 16/7/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYRegisterViewController.h"

@interface LYRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@end

@implementation LYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_accountTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_passwordTextField];
}

- (void)textFieldTextDidChange:(NSNotification *)noti {
    _registerBtn.enabled = ![_accountTextField.text isEqualToString:@""] && ![_passwordTextField.text isEqualToString:@""];
}

- (IBAction)registerBtnDidClicked:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在注册ing"];
    [[LYXMPPHelper sharedManager] registerWithAccount:_accountTextField.text password:_passwordTextField.text completed:^(LYXMPPStatus status) {
        [MBProgressHUD hideHUD];
        switch (status) {
            case LYXMPPStatusRegisterSuccess:
                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD showSuccess:@"注册成功"];
                break;
            case LYXMPPStatusRegisterAccountExist:
                [MBProgressHUD showError:@"用户已存在"];
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
