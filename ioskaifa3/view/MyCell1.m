//
//  MyCell1.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/25.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyCell1.h"
#import "UIImageView+AFNetworking.h"

@implementation MyCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(MyEntity1*)entity {
    
    [self.imageView1 yidaImageURL:entity.image placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    
    self.leb2.text = entity.yuedu;
    self.leb3.text = entity.like;
    
    self.height = 0.0;
    
    //重新设置title的frame
    CGRect r = self.title.frame;
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    self.title.frame = CGRectMake(r.origin.x, r.origin.y, W-2*r.origin.x, r.size.height);
    self.title.text = entity.title;
    
    // 动态计算内容的高度
    NSDictionary *attribute = @{NSFontAttributeName:self.title.font};
    CGSize size = [self.title.text boundingRectWithSize:CGSizeMake(self.title.frame.size.width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.title.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, size.height);
    
    //动态计算总高度
    self.height += self.title.frame.origin.y+self.title.frame.size.height + 5 + 16 +5;
}

@end
