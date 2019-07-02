//
//  MyCell7.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/30.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyCell7.h"

//定义网页字体大小
#define FontMax 140 //大号字体
#define FontMid 110 //中号字体
#define FontMin 80  //小号字体

@implementation MyCell7

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(NSString*)str {
    self.color = @"#0D1931";
    self.backgroundColor = @"#E9E9E0";
    self.fontSize = FontMid;//中号字体
    self.webView.delegate = self;
    
    [self.webView loadHTMLString:str baseURL:nil];
    [self updateWebCSS];
}

- (void)updateWebCSS {
    //修改图片宽度 方式一
    NSString *S = [NSString stringWithFormat:@"\
                   var maxWidth = %f;\
                   var images = document.images;\
                   for(var i = 0; i < images.length; i++) {\
                   var img = images[i];\
                   if (img.width > maxWidth) {\
                   img.width = maxWidth;\
                   }\
                   }\
                   ",self.webView.bounds.size.width-20];
    [self.webView stringByEvaluatingJavaScriptFromString:S];
    
    //修改网页字体颜色
    NSString *S2 = [NSString stringWithFormat:@"document.body.style.color='%@'", self.color];
    [self.webView stringByEvaluatingJavaScriptFromString:S2];
    
    //修改网页背景色
    NSString *S3 = [NSString stringWithFormat:@"document.body.style.background='%@'", self.backgroundColor];
    [self.webView stringByEvaluatingJavaScriptFromString:S3];
    
    //修改网页里字体的大小(webkit的css样式是基于safari和chrome的浏览器才有效)
    NSString *S4 = [NSString stringWithFormat:@"document.body.style.webkitTextSizeAdjust= '%d%%'", self.fontSize];
    [self.webView stringByEvaluatingJavaScriptFromString:S4];
    
    //动态获取webview的内容总高度
    NSString *strHeight = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    NSLog(@"%f", strHeight.floatValue);
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateWebCSS];//更新网页样式
}


@end
