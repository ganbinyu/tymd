//
//  MyEntity2.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/25.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyEntity2 : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *image2;
@property (nonatomic,strong) NSString *image3;
@property (nonatomic,strong) NSString *yuedu;
@property (nonatomic,strong) NSString *like;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic) int type;//类型，不同的值，显示的cell样式也不一样

@end
