//
//  MyView2.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/31.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyView2Delegate<NSObject>
- (void)getMail:(NSString*)Mail;
- (void)getXinlang:(NSString*)xinlang;
- (void)getQQ:(NSString*)qq;
- (void)getKongjian:(NSString*)kongjian;
- (void)getWX:(NSString*)wx;
- (void)getPengyou:(NSString*)pengyou;
@end

@interface MyView2 : UIView

@property (nonatomic,assign) id<MyView2Delegate>delegate;

@end
