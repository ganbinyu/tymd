//
//  MyViewController7.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/27.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController7.h"
#import "MyTabBarController.h"
#import "MyCell7.h"
#import "MyViewController8.h"
#import "MyView1.h"
#import "MyView2.h"


@interface MyViewController7 ()<UIWebViewDelegate,UIAlertViewDelegate,MyView2Delegate>
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) UIView *viewTab;
@property (nonatomic,strong) MyView1 *v;
@property (nonatomic,strong) MyView2 *v2;
@property (nonatomic,strong) UIButton *fenxiang;
@property (nonatomic,strong) UIButton *pinglun;

//定义网页字体大小
#define FontMax 140 //大号字体
#define FontMid 110 //中号字体
#define FontMin 80  //小号字体

@end

@implementation MyViewController7

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建QQ授权对象
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    //获取自定义分栏
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *leb = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20, 20, 40, 30)];
    leb.text = @"内容详情";
    leb.font = [UIFont systemFontOfSize:22];
    [leb setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:leb];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 35);
    [btn setImage:[UIImage imageNamed:@"btn_back@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:left animated:YES];
    
    self.leb.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:217/255.0 alpha:1.0];
    self.myTableView.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:217/255.0 alpha:1.0];
    
    self.arrayData = [NSMutableArray array];
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/GetHtmlCode.action";
    NSString *body = [NSString stringWithFormat:@"id=%@",self.wenzhangID];
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSDictionary *dic2 = dic[@"content"];
        NSString *strURL = dic2[@"content"];
        NSString *title = dic2[@"title"];
        
        [self.arrayData addObject:strURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{ //主线程显示
            self.leb.text = title;
            [self.myTableView reloadData];
        });
    }];
    
    //评论按钮
    self.pinglun = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pinglun.frame = CGRectMake(20, h-64-38, 20, 20);
    [self.pinglun setBackgroundImage:[UIImage imageNamed:@"message@2x"] forState:UIControlStateNormal];
    [self.pinglun addTarget:self action:@selector(pinglunClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pinglun];
    
    //分享按钮
    self.fenxiang = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fenxiang.frame = CGRectMake(w-20-20, self.pinglun.frame.origin.y, 20, 20);
    [self.fenxiang setBackgroundImage:[UIImage imageNamed:@"share@2x"] forState:UIControlStateNormal];
    [self.fenxiang addTarget:self action:@selector(fengxiangClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fenxiang];
    
    //xib文件
    self.v = [[NSBundle mainBundle] loadNibNamed:@"MyView1" owner:self.view options:nil][0];
    self.v.frame = CGRectMake(0, 0, w, h);
    self.v.hidden = YES;
    self.v.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Vclicked)];
    [self.v addGestureRecognizer:tap];
    [window addSubview:self.v];
    
    self.v2 = [[NSBundle mainBundle] loadNibNamed:@"MyView2" owner:self.view options:nil][0];
    self.v2.frame = CGRectMake(0, h, w, 170);
    self.v2.delegate = self;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Vclicked2)];
    [self.v2 addGestureRecognizer:tap2];
    [window addSubview:self.v2];
    
    //侧滑手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

//评论按钮
- (void)pinglunClicked {
    //创建一个归档文件夹
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[library lastObject] stringByAppendingPathComponent:@"name.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *name = dic[@"name"];
    NSString *ID = dic[@"ID"];
    if (name.length > 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MyViewController8 *vc8 = [main instantiateViewControllerWithIdentifier:@"MyViewController8"];
        vc8.wenzhangID = self.wenzhangID;
        vc8.dlID =ID;
        vc8.name = name;
        [self.navigationController pushViewController:vc8 animated:YES];
    }
    else {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"你还没登陆，请先登陆。" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"现在登陆", nil];
        al.tag = 901;
        [al show];
    }
    
}

//分享按钮
- (void)fengxiangClicked {
    self.v.hidden = NO;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.v2.frame = CGRectMake(0, h-170, w, 170);
    }];

}

//黑色背景图片点击了
- (void)Vclicked {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    self.v.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.v2.frame = CGRectMake(0, h, w, 170);
    }];
}
//分享框点击了
- (void)Vclicked2 {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    self.v.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.v2.frame = CGRectMake(0, h, w, 170);
    }];
}

//返回按钮
- (void)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

//模式对话框的委托代理
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 901) {
        if (0 == buttonIndex)
        {
            //
        }
        
        if (1 == buttonIndex)
        {
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController *vc6 = [main instantiateViewControllerWithIdentifier:@"NAViewController1"];
            [self presentViewController:vc6 animated:YES completion:^{
                
            }];
        }
    }
    if (alertView.tag == 900) {
        if (buttonIndex == 1) {
            NSString *qqAddress = [QQApiInterface getQQInstallUrl];
            NSLog(@"QQ下载地址：%@", qqAddress);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqAddress]];
        }
    }
    
    if (alertView.tag == 902) {
        //如果点击了设置邮箱就跳转到设置邮箱
        if (buttonIndex==1)
        {
            NSString *recipients = @"mailto:first@example.com";
            NSString *email = [recipients stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    //获取自定义分栏
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *viewTab = [window viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        viewTab.frame = CGRectMake(0, h, w, 49);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
//设置表格视图每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayData && [self.arrayData count]) {
        return [self.arrayData count];
    }
    
    return 0;
}

//设置表格视图每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell7";//定义一个可重用标识，在故事板里设置的！
    MyCell7 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self.arrayData && indexPath.row < [self.arrayData count])  {
        [cell setCell:[self.arrayData objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.height-49-64;
}

#pragma mark - MyView2Delegate
- (void)getXinlang:(NSString *)xinlang {
    NSLog(@"新浪");
    WBMessageObject *msg = [WBMessageObject message];//创建分享对象
    msg.text = @"巴黎时装";
    [self messageToSina:msg];//上传内容到新浪服务器
    [self Vclicked];
}


//上传内容到新浪服务器
- (void)messageToSina:(WBMessageObject*)object
{
    //开始调转官方客户端进行分享
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:object];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;//如果官方客户端没安装，则打开安装界面
    [WeiboSDK sendRequest:request];
}

//分享到qq
- (void)getQQ:(NSString *)qq {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1106128142" andDelegate:self];
    if ([self support]) {
        //        NSString *url = @"https://itunes.apple.com/us/app/精致衣品/id1225470043?l=zh&ls=1&mt=8";
        NSString *url = @"http://www.yidaapple.com";//分享跳转URL
        NSString *previewImageUrl = @"http://y.photo.qq.com/img?s=kAZozbmxG&l=y.jpg";//分享图预览图URL地址
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title: @"巴黎时装" description :@"追逐时尚，更懂生活。掌控时尚前沿，做最fashion的人！" previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];//将内容分享到qq
        //        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];//将内容分享到qzone
        if (sent == EQQAPISENDSUCESS) {
            NSLog(@"分享成功!");
        } else {
            NSLog(@"分享失败，错误码:%d。[钱老师提醒：错误码7表示EQQAPIAPPSHAREASYNC，不用理会，不影响分享结果]", sent);
            /**
             EQQAPISENDSUCESS = 0,
             EQQAPIQQNOTINSTALLED = 1,
             EQQAPIQQNOTSUPPORTAPI = 2,
             EQQAPIMESSAGETYPEINVALID = 3,
             EQQAPIMESSAGECONTENTNULL = 4,
             EQQAPIMESSAGECONTENTINVALID = 5,
             EQQAPIAPPNOTREGISTED = 6,
             EQQAPIAPPSHAREASYNC = 7,
             EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
             EQQAPISENDFAILD = -1,
             //qzone分享不支持text类型分享
             EQQAPIQZONENOTSUPPORTTEXT = 10000,
             //qzone分享不支持image类型分享
             EQQAPIQZONENOTSUPPORTIMAGE = 10001,
             */
        }
    }
    [self Vclicked];
}

//分享到qq空间
- (void)getKongjian:(NSString *)kongjian {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1106128142" andDelegate:self];
    if ([self support]) {
        //        NSString *url = @"https://itunes.apple.com/us/app/精致衣品/id1225470043?l=zh&ls=1&mt=8";
        NSString *url = @"http://www.yidaapple.com";//分享跳转URL
        NSString *previewImageUrl = @"http://y.photo.qq.com/img?s=kAZozbmxG&l=y.jpg";//分享图预览图URL地址
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title: @"巴黎时装" description :@"追逐时尚，更懂生活。掌控时尚前沿，做最fashion的人！" previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //        QQApiSendResultCode sent = [QQApiInterface sendReq:req];//将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];//将内容分享到qzone
        if (sent == EQQAPISENDSUCESS) {
            NSLog(@"分享成功!");
        } else {
            NSLog(@"分享失败，错误码:%d。[钱老师提醒：错误码7表示EQQAPIAPPSHAREASYNC，不用理会，不影响分享结果]", sent);
            /**
             EQQAPISENDSUCESS = 0,
             EQQAPIQQNOTINSTALLED = 1,
             EQQAPIQQNOTSUPPORTAPI = 2,
             EQQAPIMESSAGETYPEINVALID = 3,
             EQQAPIMESSAGECONTENTNULL = 4,
             EQQAPIMESSAGECONTENTINVALID = 5,
             EQQAPIAPPNOTREGISTED = 6,
             EQQAPIAPPSHAREASYNC = 7,
             EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
             EQQAPISENDFAILD = -1,
             //qzone分享不支持text类型分享
             EQQAPIQZONENOTSUPPORTTEXT = 10000,
             //qzone分享不支持image类型分享
             EQQAPIQZONENOTSUPPORTIMAGE = 10001,
             */
        }
    }
    [self Vclicked];
}

//判断是否安装了QQ应用
- (BOOL)support {
    BOOL isSpupport = YES;
    if ([QQApiInterface isQQInstalled]) {//判断是否安装了QQ应用
        if ([QQApiInterface isQQSupportApi]) {//判断当前版本QQ是否支持此api
            isSpupport = YES;
        } else {
            isSpupport = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"当前QQ版本太低，现在最新?" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"现在更新", nil];
            [alert show];
        }
    } else {
        isSpupport = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"分享内容前必须安装QQ应用，是否安装?" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"现在安装", nil];
        alert.tag = 900;
        [alert show];
    }
    return isSpupport;
}

#pragma mark - TencentSessionDelegate
//登录成功时回调
- (void)tencentDidLogin {
}

//登录失败时回调
- (void)tencentDidNotLogin:(BOOL)cancelled {
}

//没有网络时回调
- (void)tencentDidNotNetWork {
    NSLog(@"无网络连接，请设置网络");
}

#pragma mark - 应用内邮件发送
- (void)getMail:(NSString *)Mail {
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])//设备是否支持邮箱发送
        {
            [self displayMailComposerSheet];
        }
        else
        {
            //您的设备未设置邮件账户不能发送邮件
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的设备未设置邮件账户不能发送邮件"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置邮箱",nil];
            alert.tag = 902;
            [alert show];
        }
    }
    else
    {
        NSLog(@"系统版本太低，不支持邮件功能");
    }
    [self Vclicked];
}

-(void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;//设置邮箱委托
    [picker setToRecipients:[NSArray arrayWithObjects:@"349225445@qq.com", nil]];//设置收件人
    //[picker setCcRecipients:[NSArray arrayWithObjects:@"qzlei200718@163.com", nil]];//设置抄送人
    //[picker setBccRecipients:[NSArray arrayWithObjects:@"qzlei200718@gmail.com", nil]];//设置密送人
    [picker setSubject:@"巴黎服装"];//设置邮箱标题
    
#if 0
    //设置邮件内容(txt格式)
    NSString *emailBody = @"这是邮件的详细信息";
    [picker setMessageBody:emailBody isHTML:NO];
#endif
    
#if 1
    //设置邮件内容(html格式,注意子体范围大小为1〜7,默认为3)
    NSString *htmlBody = @"<HTML><font color='red' size=7>巴黎服装</font><BR/><font color='blue' size=6>追逐时尚，更懂生活。掌控时尚前沿，做最fashion的人！</font><BR/><font color='green' size=6>https://itunes.apple.com/us/app/巴黎时装/id1230892731?l=zh&ls=1&mt=8</font></HTML>";
    [picker setMessageBody:htmlBody isHTML:YES];
#endif
    
#if 1
    //添加一个图片(如果图片是png格式的，用@"image/png")
    NSData *myData = UIImagePNGRepresentation([UIImage imageNamed:@"jingzhiyipinlogoshare.jpg"]);
    [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"jingzhiyipinlogoshare.jpg"];
#endif
    
    [self presentViewController:picker animated:YES completion:^{}];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //取消邮件发送
            break;
        case MFMailComposeResultSaved:
            //保存邮件草稿
            break;
        case MFMailComposeResultSent:
        {
            //邮件发送成功
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"邮件发送成功"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            
            break;
        case MFMailComposeResultFailed:
        {
            //邮件发送失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误！"
                                                            message:@"邮件发送失败，请稍后重试！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误！"
                                                            message:@"邮件发送失败，请稍后重试！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//分享到微信
- (void)getWX:(NSString *)wx {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"巴黎服装";
    message.description = @"追逐时尚，更懂生活。掌控时尚前沿，做最fashion的人！";
    [message setThumbImage:[UIImage imageNamed:@"jingzhiyipinlogoshare.jpg"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"https://itunes.apple.com/us/app/巴黎时装/id1230892731?l=zh&ls=1&mt=8";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;//发送消息的类型，包括文本消息和多媒体消息两种(两者只能选择其一，不能同时发送文本和多媒体消息)
    req.message = message;
    req.scene = WXSceneSession;//WXSceneSession表示会话；WXSceneTimeline表示朋友圈；WXSceneFavorite表示收藏
    
    [WXApi sendReq:req];
    [self Vclicked];
}

//分享到朋友圈
- (void)getPengyou:(NSString *)pengyou {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"巴黎服装";
    message.description = @"追逐时尚，更懂生活。掌控时尚前沿，做最fashion的人！";
    [message setThumbImage:[UIImage imageNamed:@"jingzhiyipinlogoshare.jpg"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"https://itunes.apple.com/us/app/巴黎时装/id1230892731?l=zh&ls=1&mt=8";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;//发送消息的类型，包括文本消息和多媒体消息两种(两者只能选择其一，不能同时发送文本和多媒体消息)
    req.message = message;
    req.scene = WXSceneTimeline;//WXSceneSession表示会话；WXSceneTimeline表示朋友圈；WXSceneFavorite表示收藏
    
    [WXApi sendReq:req];
    [self Vclicked];
}



@end
