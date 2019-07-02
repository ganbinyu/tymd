//
//  MyCell7.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/30.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell7 : UITableViewCell<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
//@property (nonatomic,strong) NSString *content;//保存网页内容
@property (nonatomic) int fontSize;//网页字体大小
@property (nonatomic,strong) NSString *color;//网页前景色
@property (nonatomic,strong) NSString *backgroundColor;//网页背景颜色
- (void)setCell:(NSString*)str;
@end
