//
//  MyViewController6.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController6.h"
#import "MyViewController6_1.h"
#import "AFpostRequest.h"

@interface MyViewController6 ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation MyViewController6

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.a = @"1";
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [_textField1 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_textField2 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _textField2.secureTextEntry = YES; // 文本输入框设置密码样式
    [self.denglu.layer setCornerRadius:10];//设置按钮圆角半径
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(20, 30, 50, 30);
    [btn1 setTitle:@"返回" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(self.view.bounds.size.width-20-50, 30, 50, 30);
    [btn2 setTitle:@"注册" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.imageView addGestureRecognizer:tap];
}

//返回
- (void)btn1 {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//登陆按钮
- (IBAction)denglu:(id)sender {
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    
    if (![self.textField1 hasText] || ![self.textField2 hasText]) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"用户名,昵称和密码不能为空";
        [self.HUD showAnimated:YES];
        
        [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        
        return;
    }
    
    NSString *str = @"http://112.74.108.147:8080/Yidaforum/user/userlogin.do";
    NSDictionary *body = @{@"username":self.textField1.text,@"passwd":self.textField2.text};
    AFpostRequest *request = [AFpostRequest json];
    [request downloadJson:str body:body finish:^(NSDictionary* obj) {
        NSString *code = obj[@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *dic = obj[@"result"];
            NSString *name = dic[@"nickname"];
            NSString *ID = dic[@"id"];
            NSDictionary *adic = @{@"name":name,@"ID":ID,@"ZD":self.a};
            //创建一个归档文件夹
            NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[library lastObject] stringByAppendingPathComponent:@"name.plist"];
            NSLog(@"%@",filePath);
            BOOL directory = NO;
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&directory]) {
                [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            }
            [adic writeToFile:filePath atomically:YES];
            
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"正在登陆";
            [self.HUD showAnimated:YES];
            
            [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:1];
        }
        else {
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"帐号或密码错误";
            [self.HUD showAnimated:YES];
            
            [self.HUD hideAnimated:YES afterDelay:1];//1秒后隐藏等待提示框
        }
    }];
    
}
- (void)hiddenHUD {
    [self.HUD hideAnimated:YES];//隐藏等待提示框
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
//自动登陆按钮
- (IBAction)zidongDL:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"复选框_默认@2x"] forState:UIControlStateNormal];
        self.a = @"0";
        NSLog(@"%@",self.a);
    }
    else {
        [sender setImage:[UIImage imageNamed:@"复选框_选中@2x"] forState:UIControlStateNormal];
        self.a = @"1";
        NSLog(@"%@",self.a);
    }
}


//注册
- (void)btn2 {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyViewController6_1 *vc6_1 = [main instantiateViewControllerWithIdentifier:@"MyViewController6_1"];
//    vc6_1.textField1.text = self.textField1.text;
//    vc6_1.textField3.text = self.textField2.text;
    NSArray *array = @[self.textField1,self.textField2];
    vc6_1.array = array;
    [self.navigationController pushViewController:vc6_1 animated:YES];
    
}
- (IBAction)eye:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _textField2.secureTextEntry = NO; // 文本输入框设置密码样式
    }
    else {
        _textField2.secureTextEntry = YES; // 文本输入框设置密码样式
    }
}

//背景图片点击
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"123");
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
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
