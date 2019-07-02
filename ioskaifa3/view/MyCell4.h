//
//  MyCell4.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/27.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEntity2.h"
#import "YDImageView.h"

@interface MyCell4 : UITableViewCell
@property (strong, nonatomic) IBOutlet YDImageView *imageView1;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *leb2;
@property (strong, nonatomic) IBOutlet UILabel *leb1;

- (void)setCell:(MyEntity2*)entity;
@end
