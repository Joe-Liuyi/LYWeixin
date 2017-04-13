//
//  LYProfileViewController.m
//  LYWeiXin
//
//  Created by Joe on 16/7/2.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "LYProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface LYProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@end

@implementation LYProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.cornerRadius = 5;
    _avatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _avatarImageView.layer.borderWidth = 0.5;
}







- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    XMPPvCardTemp *temp = [LYXMPPHelper sharedManager].vCard.myvCardTemp;
    
    _avatarImageView.image = [UIImage imageWithData:temp.photo];
    _nickNameLabel.text = temp.nickname;
    _wechatAccountLabel.text = [LYXMPPHelper sharedManager].account;
//    NSLog(@"%@", temp.addresses);
//    _addressLabel.text = [
//    _locationLabel.text =
    NSLog(@"\n公司:%@ \n部门:%@ \n职位:%@ \n电话:%@ ", temp.orgName, temp.orgUnits, temp.title, temp.telecomsAddresses);
 
    NSLog(@"\n电话:%@ \n邮件:%@ \n职位:%@ \n电话:%@ ", temp.note, temp.emailAddresses, temp.title, temp.telecomsAddresses);
}



#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
//    }
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/*//获取当前的电子名片信息
 XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
 
 // 图片
 myvCard.photo = UIImagePNGRepresentation(self.haedView.image);
 
 // 昵称
 myvCard.nickname = self.nicknameLabel.text;
 
 // 公司
 myvCard.orgName = self.orgnameLabel.text;
 
 // 部门
 if (self.orgunitLabel.text.length > 0) {
 myvCard.orgUnits = @[self.orgunitLabel.text];
 }
 
 
 // 职位
 myvCard.title = self.titleLabel.text;
 
 
 // 电话
 myvCard.note =  self.phoneLabel.text;
 
 // 邮件
 myvCard.mailer = self.emailLabel.text;
 
 
 //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
 [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myvCard];*/
@end
