//
//  MyCell2_1.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/25.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyCell2_1.h"

@implementation MyCell2_1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCell:(NSMutableArray*)array {
    
    if (array.count == 2) {
        self.imageView2.hidden = NO;
        self.hei2.hidden = NO;
        self.beijing2.hidden = NO;
        
        MyEntity2 *en1 = array[0];
        self.ID1 = en1.ID;
        [self.imageView1 yidaImageURL:en1.image placeholderImage:[UIImage imageNamed:@"defaultimg"]];
            self.leb2.text = en1.yuedu;
        
        if ([en1.like isEqualToString:@"0"]) {
            self.leb1.hidden = YES;
            self.like1.hidden = YES;
        }
        else {
            self.like1.hidden = NO;
            self.leb1.hidden = NO;
            self.leb1.text = en1.like;
        }

        MyEntity2 *en2 = array[1];
        self.ID2 = en2.ID;
        [self.imageView2 yidaImageURL:en2.image placeholderImage:[UIImage imageNamed:@"defaultimg"]];
            self.leb4.text = en2.yuedu;
        if ([en2.like isEqualToString:@"0"]) {
            self.leb3.hidden = YES;
            self.like2.hidden = YES;
        }
        else {
            self.like2.hidden = NO;
            self.leb3.hidden = NO;
            self.leb3.text = en2.like;
        }
    }
    else {
        self.imageView2.hidden = YES;
        self.hei2.hidden = YES;
        self.beijing2.hidden = YES;
        MyEntity2 *en1 = array[0];
        self.ID1 = en1.ID;
        [self.imageView1 yidaImageURL:en1.image placeholderImage:[UIImage imageNamed:@"defaultimg"]];
            self.leb2.text = en1.yuedu;

        if ([en1.like isEqualToString:@"0"]) {
            self.leb1.hidden = YES;
            self.like1.hidden = YES;
        }
        else {
            self.like1.hidden = NO;
            self.leb1.hidden = NO;
            self.leb1.text = en1.like;
        }

    }

    
}
- (IBAction)btn1:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBtn:)]) {
        [self.delegate getBtn:self.ID1];
    }
}
- (IBAction)btn2:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBtn:)]) {
        [self.delegate getBtn:self.ID2];
    }
}

@end
