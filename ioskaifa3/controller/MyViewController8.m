//
//  MyViewController8.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/30.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController8.h"
#import "AFNetWorkingRequest.h"
#import "MyEntity8.h"
#import "MyCell8.h"

@interface MyViewController8 ()<UITextViewDelegate>
@property (nonatomic) int a;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIImageView *pinglunImage;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;

@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) NSMutableArray *arrayData2;
@property (nonatomic) int b;
@property (nonatomic,strong) NSString *c;
@property (nonatomic,strong) SDRefreshHeaderView *refreshHeaderView;//下啦刷新控件
@property (nonatomic,strong) SDRefreshFooterView *refreshFooterView;//上拉刷新控件

@end

@implementation MyViewController8

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *leb = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20, 20, 40, 30)];
    leb.text = @"评论";
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
    self.btn2.frame = CGRectMake(0, 0, 75, 35);
    [self.btn2 setTitle:@"发表评论" forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(btn2Clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.btn2];
    [self.navigationItem setRightBarButtonItem:right animated:YES];
    
    self.a = 1;
    self.arrayData = [NSMutableArray array];
    NSString *str = @"http://112.74.108.147:8080/Yidaforum/user/commentlist.do";
    NSDictionary *body = @{@"articleid":self.wenzhangID,@"pageno":@"1"};
    AFNetWorkingRequest *request = [AFNetWorkingRequest json];
    [request downloadJson:str body:body block:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"result"];
        if ([dic isKindOfClass:[NSNull class]]) {
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"第一个抢沙发，评论吧";
            [self.HUD showAnimated:YES];
            [self.HUD hideAnimated:YES afterDelay:1.0];

        }
        else {
            NSArray *array = dic[@"commentlist"];
            for (NSDictionary *dic in array) {
                NSNumber *date = dic[@"utime"];
                NSString *content = dic[@"content"];
                NSString *name = dic[@"nickname"];
                NSString *image = [NSString stringWithFormat:@"Icon_%d",self.a];
                
                if ([content isKindOfClass:[NSNull class]]) {//判断空值
                    
                } else {
                    MyEntity8 *en = [[MyEntity8 alloc] init];
                    en.name = name;
                    en.date = date;
                    en.content = content;
                    en.image = image;
                    [self.arrayData addObject:en];
                    self.a++;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }
    }];
    
    //底部评论图片
    self.pinglunImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinglunClicked)];
    [self.pinglunImage addGestureRecognizer:tap];
    
    self.myTextView.hidden = YES;
    self.myTextView.delegate = self;
    
    self.myTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.myTextView.layer.borderWidth =1.0;
    self.myTextView.layer.cornerRadius =5.0;
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//不向四周延展
    
    //添加上拉刷新控件
    self.refreshFooterView = [SDRefreshFooterView refreshView];
    [self.refreshFooterView addToScrollView:self.myTableView];
    __weak MyViewController8 *wealSelf = self;
    self.refreshFooterView.beginRefreshingOperation = ^{
        [wealSelf reloadNetworkData:NO];
    };

}

//底部评论图片按钮
- (void)pinglunClicked {
    [self.myTextView becomeFirstResponder];
}

//返回按钮
- (void)btn {
    [self.navigationController popViewControllerAnimated:YES];
//    self.tabBarController.tabBar.hidden = YES;
}

//发表评论
- (void)btn2Clicked {
    
    if (self.myTextView.text.length > 0) {
        NSString *str = @"http://112.74.108.147:8080/Yidaforum/user/articlecomment.do";
        NSDictionary *body = @{@"userid":self.dlID,@"articleid":self.wenzhangID,@"content":self.myTextView.text};
        AFNetWorkingRequest *request = [AFNetWorkingRequest json];
        [request downloadJson:str body:body block:^(NSDictionary *obj) {
            
            //获取当前时间为毫秒
            NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
            long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
            
            MyEntity8 *en = [[MyEntity8 alloc] init];
            en.name = self.name;
            en.content = self.myTextView.text;
            en.date = [NSNumber numberWithLongLong:theTime];;
            
            [self.arrayData insertObject:en atIndex:0];
            self.a = 1;
            for (MyEntity8 *en in self.arrayData) {
                NSString *image = [NSString stringWithFormat:@"Icon_%d",self.a];
                en.image = image;
                self.a++;
            }
            
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.label.text = @"发表成功";
            [self.HUD showAnimated:YES];
            [self.HUD hideAnimated:YES afterDelay:1.0];
            
            dispatch_async(dispatch_get_main_queue(), ^{ //主线程显示
                [self.myTableView reloadData];
                self.myTextView.text = @"";
                [self.btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            });
        }];
        [self.myTextView resignFirstResponder];
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.myTextView.hidden = NO;
    self.myTextView.frame = CGRectMake(0, self.view.bounds.size.height-height-80, self.view.bounds.size.width, 80);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.myTextView.hidden = YES;
    self.myTextView.frame = CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 80);
}

//加载网络数据
//参数flag=YES表示下拉刷新，flag=NO表示上拉刷新
- (void)reloadNetworkData:(BOOL)flag {
    if (flag) {//下拉刷新
        
    } else {//上拉刷新
        self.b += 1;
        NSString *str = @"http://112.74.108.147:8080/Yidaforum/user/commentlist.do";
        NSDictionary *body = @{@"articleid":self.wenzhangID,@"pageno":[NSString stringWithFormat:@"%d",self.b]};
        AFNetWorkingRequest *request = [AFNetWorkingRequest json];
        [request downloadJson:str body:body block:^(NSDictionary *obj) {
            NSString *code = obj[@"code"];
            if ([code isEqualToString:@"200"]) {
                NSDictionary *dic = obj[@"result"];
                if ([dic isKindOfClass:[NSNull class]]) {
                    self.c = @"0";
                }
                else {
                    self.c = @"1";
                    NSArray *array = dic[@"commentlist"];
                    for (NSDictionary *dic in array) {
                        NSNumber *date = dic[@"utime"];
                        NSString *content = dic[@"content"];
                        NSString *name = dic[@"nickname"];
                        NSString *image = [NSString stringWithFormat:@"Icon_%d",self.a];
                        
                        if ([content isKindOfClass:[NSNull class]]) {//判断空值
                            //
                        } else {
                            MyEntity8 *en = [[MyEntity8 alloc] init];
                            en.name = name;
                            en.date = date;
                            en.content = content;
                            en.image = image;
                            [self.arrayData addObject:en];
                            self.a++;
                        }
                    }
                }
            }
        }];
    }
    
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
}


//收回刷新动画
- (void)refreshData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTableView reloadData];//刷新表视图
    });
    
    //收回动画
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.mode = MBProgressHUDModeText;
//    self.HUD.label.text = @"加载完成";
    if ([self.c isEqualToString:@"0"]) {
        self.HUD.label.text = @"没有更多了";
    }
    else {
        self.HUD.label.text = @"加载完成";
    }
    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:1.0];
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

#pragma mark - UITableViewDataSource
//设置表格视图每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayData && [self.arrayData count]) {
        return [self.arrayData count];
    }
    
    return 0;
}

//设置表格视图每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell8";//定义一个可重用标识，在故事板里设置的！
    MyCell8 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self.arrayData && indexPath.row < [self.arrayData count])  {
        [cell setCell:[self.arrayData objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        CGFloat height = 0;
        if (self.arrayData && indexPath.row < [self.arrayData count])  {
            MyCell8 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell8"];
            [cell setCell:[self.arrayData objectAtIndex:indexPath.row]];
            height = cell.height;
        }
    return height;
}

////文本框委托代理
//#pragma mark - UITextFieldDelegate
//
////文本改变时调用
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"%u",textField.text.length);
//    if (textField.text.length > 0) {
//        [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
//    else {
//        [self.btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    }
//    return YES;
//}
//
////点击return键时调用的方法
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField.text.length > 0) {
//        [textField resignFirstResponder];//辞去第一响应
//        self.MyTextField.hidden = YES;
//        [self btn2Clicked];
//    }
//    else {
//        NSLog(@"请先登录");
//    }
//
//    return YES;
//}

//文本视图委托代理
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"已经开始输入了...");
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"已经结束输入了...");
}

//文本内容变化时调用
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str = textView.text;//文本内容变化时调用
    NSLog(@"%@", str);
    if (textView.text.length == 0) {
        [self.btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else {
        [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

//点击return键或delete键时调用
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果点击了return键，则收起键盘
    if ([text isEqualToString:@"\n"])
    {
        NSLog(@"return键点击了");
//        [textView resignFirstResponder];//辞去第一响应
        [self btn2Clicked];
    }
    
    //如果点击了delete键
    if ([text isEqualToString:@""])
    {
        NSLog(@"delete键点击了");
    }
    
    return YES;
}


@end
