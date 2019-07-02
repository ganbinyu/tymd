//
//  MyTabBarController.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()
@property (nonatomic,strong) UIImageView *image;
@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.image = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.image.image = [UIImage imageNamed:@"fashionweekstart"];
    [self.view addSubview:self.image];
    [self performSelector:@selector(hidden) withObject:nil afterDelay:1.0];
}

- (void)hidden {
    self.image.alpha = 0.5;
    [UIView animateWithDuration:0.8 animations:^{
        self.image.transform = CGAffineTransformMakeScale(2.0, 2.0);//对视图进行比例缩放(比如:缩小到原来的0.5倍)
        self.image.alpha = 0.0;
    } completion:^(BOOL finished) {
        //
    }];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    UIImageView *tabBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, h-49, w, 49)];
    tabBar.tag = 1000;
    tabBar.userInteractionEnabled = YES;
    tabBar.image = [UIImage imageNamed:@"bottombar"];
    [self.view addSubview:tabBar];
    
    NSArray *ary = @[@"时尚",@"明星",@"街拍",@"单品",@"更多"];
    
    for (int i =0;i<5;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(w/5), 0, w/5, 49);
        btn.tag = 8888+i;
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [tabBar addSubview:btn];
        
        UIView *view1 = [[UIView alloc] init];
        view1.frame = CGRectMake(0, 45, w/5, 2);
        view1.backgroundColor = [UIColor clearColor];
        [btn addSubview:view1];
    }
    
    //默认选中第一个
    UIButton *firstBtn = (UIButton*)[tabBar.subviews firstObject];
    firstBtn.selected = YES;
    UIView *view = [firstBtn.subviews firstObject];
    view.backgroundColor = [UIColor whiteColor];
    
}

- (void)buttonClicked:(UIButton*)btn {
    //设置选中按钮
    for (UIButton *button in btn.superview.subviews) {
        button.selected = (button != btn) ? NO : YES;
        UIView *view = [button.subviews firstObject];
        view.backgroundColor = [UIColor clearColor];
    }

    //切换视图控制器
    long currentIndex = btn.tag - 8888;
    self.selectedIndex = currentIndex;
    UIView *view = [btn.subviews firstObject];
    view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
