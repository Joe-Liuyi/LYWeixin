//
//  LYXMPPHelper.h
//  LYWeiXin
//
//  Created by Joe on 16/7/1.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LYXMPPStatus) {
    LYXMPPStatusLoginSuccess,
    LYXMPPStatusLoginError, // 账号密码错误
    LYXMPPStatusLoginTimeOut
};

@interface LYXMPPHelper : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

+ (instancetype)sharedManager; 
- (void)loginWithCompleted:(void(^)(LYXMPPStatus status))block;
- (void)loginWithAccount:(NSString *)account password:(NSString *)password completed:(void(^)(LYXMPPStatus status))block;
- (void)loginOut;

- (BOOL)isLogin;
- (BOOL)isConnect;
@end
