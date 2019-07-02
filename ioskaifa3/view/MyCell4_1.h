//
//  MyCell4_1.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/30.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEntity2.h"
#import "YDImageView.h"

@interface MyCell4_1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *leb1;
@property (strong, nonatomic) IBOutlet UILabel *leb2;
@property (strong, nonatomic) IBOutlet YDImageView *imageView1;
@property (strong, nonatomic) IBOutlet YDImageView *imageView2;
@property (strong, nonatomic) IBOutlet YDImageView *imageView3;

@property (nonatomic) CGFloat height;

- (void)setCell:(MyEntity2*)entity;

@end
