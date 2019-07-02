//
//  MyViewController9.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/9/3.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController9.h"

@interface MyViewController9 ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic,strong) UIView *viewTab;
@property (strong, nonatomic) IBOutlet UITextField *myTextField1;
@property (strong, nonatomic) IBOutlet UITextField *myTextField2;
@property (strong, nonatomic) IBOutlet UITextField *myTextField3;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (strong, nonatomic) IBOutlet UIView *myView;

@end

@implementation MyViewController9

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    //获取自定义分栏
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.viewTab = [window viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        self.viewTab.frame = CGRectMake(0, h, w, 55);
    }];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *leb = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20, 20, 40, 30)];
    leb.text = @"意见反馈";
    leb.font = [UIFont systemFontOfSize:22];
    [leb setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:leb];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 35);
    [btn setImage:[UIImage imageNamed:@"btn_back@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:left animated:YES];
    
    //发表评论
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2.frame = CGRectMake(0, 0, 60, 35);
    [self.btn2 setTitle:@"提交" forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(btn2Clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.btn2];
    [self.navigationItem setRightBarButtonItem:right animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cliced1)];
    [self.myView addGestureRecognizer:tap];
    
    self.myTextField1.text = self.name;
    self.myTextField1.enabled = NO;
    
    self.myTextField3.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.myTextField3.delegate = self;
    
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //侧滑手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

//返回按钮
- (void)btn {
    [self.navigationController popViewControllerAnimated:YES];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewTab.frame = CGRectMake(0, h-55, w, 55);
    }];
}

- (void)cliced1 {
    [self.myTextField2 resignFirstResponder];
    [self.myTextField3 resignFirstResponder];
}

//提交按钮
- (void)btn2Clicked {
    [self.myTextField2 resignFirstResponder];
    [self.myTextField3 resignFirstResponder];
    if (![self.myTextField2 hasText] || ![self.myTextField3 hasText]) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"手机号和内容不能为空";
        [self.HUD showAnimated:YES];
        
        [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        return;
    }
    
    BOOL a = [self verifyMobile:self.myTextField2.text];
    if (!a) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"手机不合法";
        [self.HUD showAnimated:YES];
        [self.HUD hideAnimated:YES afterDelay:1.0];
        return;

    }
    
    NSString *url = @"http://112.74.108.147:6100/api/complaint";
    NSDictionary *body = @{@"a":self.name,@"b":self.myTextField2.text,@"c":self.myTextField3.text};
    AFpostRequest *reuqes = [AFpostRequest json];
    [reuqes downloadJson:url body:body finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"z"];
        NSString *str = dic[@"a"];
        if ([str isEqualToString:@"200"]) {
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"发送成功";
            [self.HUD showAnimated:YES];
            [self.HUD hideAnimated:YES afterDelay:1.0];
        }
    }];
    
}

#pragma mark --- 验证手机号是否合法

- (BOOL)verifyMobile:(NSString *)mobilePhone{
    
    NSString *express = @"^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9])[0-9]{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@", express];
    
    BOOL boo = [pred evaluateWithObject:mobilePhone];
    
    return boo;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //获取自定义分栏
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *viewTab = [window viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        viewTab.frame = CGRectMake(0, h, w, 49);
    }];
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
//键盘弹出
- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    /* 获取键盘的高度 */
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    
    NSLog(@"%f",keyboardRect.size.height);
    if (self.myTextField3.frame.origin.y + self.myTextField3.frame.size.height > self.view.bounds.size.height - keyboardRect.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(0, 64+(self.view.bounds.size.height - keyboardRect.size.height) -(self.myTextField3.frame.origin.y + self.myTextField3.frame.size.height), self.view.bounds.size.width, self.view.bounds.size.height);
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

//键盘退出
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    /* 输入框下移 */
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

//文本框委托代理
#pragma mark - UITextFieldDelegate
//输入开始时调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"开始输入。。。");
    [textField becomeFirstResponder];
}

//输入结束时调用
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"输入结束...");
    [textField resignFirstResponder];
}


//文本改变时调用
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@", textField.text);//文本变化内容
    NSLog(@"%u",textField.text.length);
    return YES;
}

//点击了clear键时调用
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"clear button被点击了...");
    return YES;
}

//点击return键时调用的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"return键点击了...");
    [textField resignFirstResponder];//辞去第一响应
    [self btn2Clicked];
    return YES;
}


@end
