//
//  MyView2.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/31.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyView2.h"

@implementation MyView2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)weibo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getXinlang:)]) {
        [self.delegate getXinlang:@"新浪"];
    }
}
- (IBAction)qq:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getQQ:)]) {
        [self.delegate getQQ:@"QQ"];
    }
}
- (IBAction)qqkongjian:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getKongjian:)]) {
        [self.delegate getKongjian:@"Kongjian"];
    }
}
- (IBAction)youxiang:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getMail:)]) {
        [self.delegate getMail:@"邮箱"];
    }
}
- (IBAction)weixin:(id)sender {
    NSLog(@"weixin");
    if (self.delegate && [self.delegate respondsToSelector:@selector(getWX:)]) {
        [self.delegate getWX:@"微信"];
    }
}
- (IBAction)pengyouquan:(id)sender {
    NSLog(@"pengyouquan");
    if (self.delegate && [self.delegate respondsToSelector:@selector(getPengyou:)]) {
        [self.delegate getPengyou:@"朋友圈"];
    }
}

@end
