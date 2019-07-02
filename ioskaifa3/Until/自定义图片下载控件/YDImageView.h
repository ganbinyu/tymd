//
//  YDImageView.h
//  YIDaDemo
//
//  Created by Mr Qian on 16/2/26.
//  Copyright © 2016年 Mr Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YDImageViewDelegate <NSObject>

@optional
- (void)showCacheSize:(NSString*)size;

@end

@interface YDImageView : UIImageView

@property (nonatomic, assign) id<YDImageViewDelegate> delegate;

/**
 @功能：根据URL获取网络图片
 @参数：图片url  默认显示图片
 @返回值：空
 */
- (void)yidaImageURL:(NSString*)strURL placeholderImage:(UIImage*)placeholderImage;

//取消当前图片请求
- (void)cancel;

//清理所有的图片缓存
+ (void)clearAllCaches;

//获取本地图片缓存数据大小
+ (NSString*)imageCacheSize;

@end
