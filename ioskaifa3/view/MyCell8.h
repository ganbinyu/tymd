//
//  MyCell8.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/31.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEntity8.h"

@interface MyCell8 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (nonatomic) CGFloat height;
- (void)setCell:(MyEntity8*)entity;
@end
