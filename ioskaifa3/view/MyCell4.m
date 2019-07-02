//
//  MyCell4.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/27.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyCell4.h"
#import "UIImageView+AFNetworking.h"

@implementation MyCell4

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
    
    self.title.text = entity.title;
    self.leb2.text = entity.yuedu;
    
    self.leb1.text = [self getTimer:entity.date];
    
    
}

//把微秒转成几月前，几天前，几小时前，几分钟前
- (NSString*)getTimer:(NSString *)timer {
    NSString *strTimer = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
    // 截止时间data格式
    NSDate *expireDate = [dateFormatter dateFromString:timer];
    // 当前时间data格式
    NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth
    |NSCalendarUnitDay/*|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond*/;
    // 对比时间差
    if (expireDate && nowDate) {
        NSDateComponents *dateCom = [calendar components:unit fromDate:expireDate toDate:nowDate options:0];
        // 伪代码
        int year = (int)dateCom.year;//年差额
        int month = (int)dateCom.month;//月差额
        int day = (int)dateCom.day;//日差额
        int hour = (int)dateCom.hour;//小时差额
        //int min = (int)dateCom.minute;//分钟差额
        //int second = (int)dateCom.second;//秒差额
        //NSLog(@"年差额%d 月差额%d 日差额%d 小时差额%d 分钟差额%d 秒差额%d",year,month,day,hour,min,second);
        if (year > 0) {
            strTimer = @"很久以前";
        } else if (year == 0) {
            if (month > 0) {
                strTimer = [NSString stringWithFormat:@"%d月前",month];
            } else {
                if (day > 0) {
                    strTimer = [NSString stringWithFormat:@"%d天前",day];
                } else {
                    if (hour > 0) {
                        strTimer = [NSString stringWithFormat:@"%d小时前",hour];
                    } else {
                        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                        dateFormatter2.dateFormat = @"HH:mm:ss";
                        NSString *nowDateStr2 = [dateFormatter2 stringFromDate:[NSDate date]];
                        NSArray *ary = [nowDateStr2 componentsSeparatedByString:@":"];
                        NSMutableString *strMin = [NSMutableString stringWithString:ary[1]];
                        if ([strMin hasPrefix:@"0"]) {
                            [strMin deleteCharactersInRange:NSMakeRange(0, 1)];
                        }
                        strTimer = [NSString stringWithFormat:@"%@分钟前",strMin];
                    }
                }
            }
        }
    }
    
    return strTimer;
}


@end
