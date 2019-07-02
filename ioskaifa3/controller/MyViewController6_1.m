//
//  MyViewController6_1.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController6_1.h"
#import "AFpostRequest.h"

@interface MyViewController6_1 ()
@property (strong, nonatomic) IBOutlet UIButton *denglu;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation MyViewController6_1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [_textField1 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_textField2 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_textField3 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _textField3.secureTextEntry = YES; // 文本输入框设置密码样式
    [self.denglu.layer setCornerRadius:10];//设置按钮圆角半径
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.imageView addGestureRecognizer:tap];
    
    //侧滑手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

//密码样式
- (IBAction)eye:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _textField3.secureTextEntry = NO; // 文本输入框设置密码样式
    }
    else {
        _textField3.secureTextEntry = YES; // 文本输入框设置密码样式
    }
}


- (IBAction)zhuce:(id)sender {
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
    
    if (![self.textField1 hasText] || ![self.textField2 hasText] || ![self.textField3 hasText]) {
        NSLog(@"用户名,昵称和密码不能为空");
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"用户名,昵称和密码不能为空";
        [self.HUD showAnimated:YES];
        
        [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        
        return;
    }
    
    //验证用户名（只能是字母组成且为6～12位）
    NSString *nameRegex = @"^[A-Za-z]{6,12}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    if (![test evaluateWithObject:self.textField1.text]) {
        NSLog(@"账号只能由6～12位字母组成");
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"账号只能由6～12位字母组成";
        [self.HUD showAnimated:YES];
        
        [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        return;
    }
    //验证昵称(只能是汉字，字母或二者组合，最少2位)
    NSString *nickRegex = @"^[a-zA-Z\u4e00-\u9fa5]{2,4}$";
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickRegex];
    if (![test2 evaluateWithObject:self.textField2.text]) {
        NSLog(@"昵称为2～4位汉字或字母组合");
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"昵称为2～4位汉字或字母组合";
        [self.HUD showAnimated:YES];
        
        [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        return;
    }
    //验证密码（只能是数字且为6位）
    NSString *secretRegex = @"^\\d{6}$";
    NSPredicate *test3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
    if (![test3 evaluateWithObject:self.textField3.text]) {
        NSLog(@"密码只能由6位数字组成");
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"密码只能由6位数字组成";
        [self.HUD showAnimated:YES];
        
        [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        return;
    }
    
    NSLog(@"恭喜你！你的注册信息合法。");
    
    NSString *str = @"http://112.74.108.147:8080/Yidaforum/user/userregister.do";
    NSDictionary *body = @{@"username":self.textField1.text,@"nickname":self.textField2.text,@"passwd":self.textField3.text};
//    AFpostRequest *request = [[AFpostRequest alloc] init];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadJson:str body:body finish:^(NSDictionary* obj) {
        NSString *code = obj[@"code"];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"注册成功");
            UITextField *f1 = self.array[0];
            UITextField *f2 = self.array[1];
            f1.text = self.textField1.text;
            f2.text = self.textField3.text;
            
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"注册成功";
            [self.HUD showAnimated:YES];
            
            [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:1.5];
        }
        else if ([code isEqualToString:@"203"]) {
            NSLog(@"用户名存在");
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"用户名存在";
            [self.HUD showAnimated:YES];
            
            [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        }
        else {
            NSLog(@"注册失败");
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"注册失败";
            [self.HUD showAnimated:YES];
            
            [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        }
    }];
}

- (void)hiddenHUD {
    [self.HUD hideAnimated:YES];//隐藏等待提示框
    [self.navigationController popViewControllerAnimated:YES];
}

//背景图片点击
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"123");
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
}

//返回按钮
- (IBAction)fanhui:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
