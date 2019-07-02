//
//  AppDelegate.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "AppDelegate.h"
#define KAppKey @"2220174728" //新浪微博appkey

@interface AppDelegate ()

@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WeiboSDK registerApp:KAppKey];//注册新浪微博
    [WXApi registerApp:@"wx9473105dcd8b6c5b"];//注册微信appid
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 重载application方法来响应新浪微博方法的回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //url的内容：wb2113091345://response?id=245D9074-CD2D-4C78-8399-ABE2258D946E&sdkversion=2.5
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return  [WXApi handleOpenURL:url delegate:self];
}

//新浪
#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    // ...
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess){
        NSLog(@"分享成功");
        self.HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"分享成功";
        [self.HUD showAnimated:YES];
        [self.HUD hideAnimated:YES afterDelay:1.0];
    }
    else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel){
        NSLog(@"你取消了分享");
        self.HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"取消分享";
        [self.HUD showAnimated:YES];
        [self.HUD hideAnimated:YES afterDelay:1.0];
    }
    else{
        NSLog(@"分享失败原因：%d", (int)response.statusCode);
    }
}

#pragma mark - WXApiDelegate
//微信分享结果回调
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = @"哦, 分享失败了";
        if (resp.errCode == 0)//错误码
        {
            strMsg = @"分享成功";
        }
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = strMsg;
        [self.HUD showAnimated:YES];
        [self.HUD hideAnimated:YES afterDelay:1.0];
    }
}


@end
