//
//  MyCell8.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/31.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyCell8.h"

@implementation MyCell8

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(MyEntity8*)entity {
    //设置圆角图片
    self.imageView1.layer.cornerRadius = self.imageView1.frame.size.width *0.5;
    self.imageView1.layer.masksToBounds =YES;
    self.imageView1.image = [UIImage imageNamed:entity.image];
    self.name.text = entity.name;
    
    //微秒转换成年月日
    NSNumber *num = entity.date;
    long long llNun = num.longLongValue;
    NSString *date = [self timerToDate:llNun];
    self.date.text = date;
    
    self.height = 0.0;
    //重新设置title的frame
    CGRect r = self.content.frame;
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    self.content.frame = CGRectMake(r.origin.x, r.origin.y, W-2*r.origin.x, r.size.height);
    self.content.text = entity.content;
    
    // 动态计算内容的高度
    NSDictionary *attribute = @{NSFontAttributeName:self.content.font};
    CGSize size = [self.content.text boundingRectWithSize:CGSizeMake(self.content.frame.size.width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.content.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, size.height);
    
    //动态计算总高度
    self.height += self.content.frame.origin.y+self.content.frame.size.height + 10;
}

//把 微秒 转换成 具体日期
- (NSString*)timerToDate:(long long)utime {
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:utime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy年MM月dd号 HH:mm:ss";
    dateFormatter.dateFormat = @"MM月dd号";
    NSMutableString *str = [NSMutableString stringWithString:[dateFormatter stringFromDate:date]];
    //如果是今年，则只去掉年
    if (str && str.length >= 4) {
        NSDate *currentDate = [NSDate date];
        NSString *sub = [currentDate.debugDescription substringToIndex:4];
        if ([str containsString:sub]) {
            [str deleteCharactersInRange:NSMakeRange(0, 5)];
            //如果月份前有0，比如：04月15号 19:06:12，则改成 4月15号 19:06:12
            char c =[str characterAtIndex:0];
            if (c == '0') {
                [str deleteCharactersInRange:NSMakeRange(0, 1)];
            }
        }
    }
    
    return str;
}

@end
