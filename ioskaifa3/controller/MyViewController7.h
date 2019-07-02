//
//  MyViewController7.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/27.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"//微博
#import <TencentOpenAPI/TencentOAuth.h>//qq
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MFMailComposeViewController.h>//邮箱
#import "WXApi.h"//微信

@interface MyViewController7 : UIViewController<TencentSessionDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) NSString *wenzhangID;
@property (strong, nonatomic) IBOutlet UILabel *leb;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end
