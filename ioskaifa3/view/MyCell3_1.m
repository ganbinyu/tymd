//
//  MyCell3_1.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/26.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyCell3_1.h"
#import "UIImageView+AFNetworking.h"

@implementation MyCell3_1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(MyEntity2*)entity {
    
    [self.imageView1 yidaImageURL:entity.image placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    self.leb1.text = entity.title;
    self.leb2.text = entity.content;
}

@end
