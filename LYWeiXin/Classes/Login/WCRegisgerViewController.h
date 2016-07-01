//
//  WCRegisgerViewController.h
//  WeChat
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WCRegisgerViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
-(void)regisgerViewControllerDidFinishRegister;

@end
@interface WCRegisgerViewController : UIViewController

@property (nonatomic, weak) id<WCRegisgerViewControllerDelegate> delegate;

@end
