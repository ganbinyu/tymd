//
//  MyCell3_1.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/26.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEntity2.h"
#import "YDImageView.h"

@interface MyCell3_1 : UITableViewCell

@property (strong, nonatomic) IBOutlet YDImageView *imageView1;

@property (strong, nonatomic) IBOutlet UILabel *leb1;
@property (strong, nonatomic) IBOutlet UILabel *leb2;

- (void)setCell:(MyEntity2*)entity;
@end
