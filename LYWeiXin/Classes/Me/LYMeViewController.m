//
//  LYMeViewController.m
//  LYWeiXin
//
//  Created by Joe on 16/7/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYMeViewController.h"
#import "XMPPvCardTemp.h"

@interface LYMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatAccountLabel;

@end

@implementation LYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _avatarImageView.layer.borderWidth = 0.5;
    _avatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    XMPPvCardTemp *temp = [LYXMPPHelper sharedManager].vCard.myvCardTemp;
    
    _avatarImageView.image = [UIImage imageWithData:temp.photo];
    
    _nickNameLabel.text = temp.nickname;
    
    _wechatAccountLabel.text = [NSString stringWithFormat:@"微信号: %@", [LYXMPPHelper sharedManager].account];
}

@end
