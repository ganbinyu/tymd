//
//  MyCell2_1.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/25.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEntity2.h"
#import "YDImageView.h"

@protocol MyCell2_1Delegate<NSObject>
- (void)getBtn:(NSString*)str;
@end

@interface MyCell2_1 : UITableViewCell
@property (strong, nonatomic) IBOutlet YDImageView *imageView1;

@property (strong, nonatomic) IBOutlet UILabel *leb1;
@property (strong, nonatomic) IBOutlet UILabel *leb2;
@property (strong, nonatomic) IBOutlet YDImageView *imageView2;

@property (strong, nonatomic) IBOutlet UILabel *leb3;
@property (strong, nonatomic) IBOutlet UILabel *leb4;
@property (strong, nonatomic) IBOutlet UIImageView *like1;
@property (strong, nonatomic) IBOutlet UIImageView *like2;
@property (strong, nonatomic) IBOutlet UIView *hei2;
@property (strong, nonatomic) IBOutlet UIView *beijing2;

@property (nonatomic,strong) NSString *ID1;
@property (nonatomic,strong) NSString *ID2;

@property (nonatomic,assign) id<MyCell2_1Delegate>delegate;

- (void)setCell:(NSMutableArray*)array;
@end
