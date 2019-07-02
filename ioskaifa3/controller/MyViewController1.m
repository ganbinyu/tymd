//
//  MyViewController1.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController1.h"
#import "AFpostRequest.h"
#import "MyEntity1.h"
#import "MyCell1.h"
#import "MyViewController7.h"
#import "MyViewController6.h"

@interface MyViewController1 ()
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSString *a;
@property (nonatomic,strong) NSMutableArray *arrarData2;
@property (nonatomic) int b;
@property (nonatomic,strong) NSString *c;

@property (nonatomic,strong) SDRefreshHeaderView *refreshHeaderView;//下啦刷新控件
@property (nonatomic,strong) SDRefreshFooterView *refreshFooterView;//上拉刷新控件

@end

@implementation MyViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-75, 20, 150, 30)];
    image.image = [UIImage imageNamed:@"fashionweek@2x"];
    [self.navigationItem setTitleView:image];
    
    //准备数据源
    self.arrayData = [NSMutableArray array];
    self.b = 1;
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/Articles.action";
//    NSString *body = [NSString stringWithFormat:@"npc=0&type=时尚搭配"];
    NSString *body = @"npc=0&type=时尚搭配";
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        for (NSDictionary *dic3 in array) {
            NSString *title = dic3[@"title"];
            NSString *image = dic3[@"imglink"];
            NSString *yuedu = [NSString stringWithFormat:@"阅读%@",dic3[@"readarts"]];
            NSString *like = [NSString stringWithFormat:@"喜欢%@",dic3[@"likecount"]];
            NSString *date = dic3[@"date"];
            NSString *ID = dic3[@"ID"];
            
            //保存到实体对象
            MyEntity1 *en = [[MyEntity1 alloc] init];
            en.title = title;
            en.image = image;
            en.yuedu = yuedu;
            NSRange rang = [like rangeOfString:@"0"];
            if (rang.location != NSNotFound) {
                en.like = @"";
            }
            else {
                en.like = like;
            }
            en.date = date;
            en.ID = ID;
            
            [self.arrayData addObject:en];
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    }];
    
    //判断是否已经登陆
    //创建一个归档文件夹
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[library lastObject] stringByAppendingPathComponent:@"name.plist"];
    NSLog(@"%@",filePath);
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.a = dic[@"ZD"];
    
    if ([self.a isEqualToString:@"0"]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    else {
       //
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//不向四周延展
    //添加下拉刷新控件
    self.refreshHeaderView = [SDRefreshHeaderView refreshView];
    [self.refreshHeaderView addToScrollView:self.myTableView];
    __weak MyViewController1 *wealSelf = self;
    self.refreshHeaderView.beginRefreshingOperation = ^{
        [wealSelf reloadNetworkData:YES];
    };
    
    //添加上拉刷新控件
    self.refreshFooterView = [SDRefreshFooterView refreshView];
    [self.refreshFooterView addToScrollView:self.myTableView];
    self.refreshFooterView.beginRefreshingOperation = ^{
        [wealSelf reloadNetworkData:NO];
    };
    
}
//头像按钮
- (IBAction)touxiang:(id)sender {
    //创建一个归档文件夹
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[library lastObject] stringByAppendingPathComponent:@"name.plist"];
    NSLog(@"%@",filePath);
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *name = dic[@"name"];
    if (name.length > 0) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.label.text = @"已经登陆";
        [self.HUD showAnimated:YES];
        [self.HUD hideAnimated:YES afterDelay:1.0];
    }
    else {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc6 = [main instantiateViewControllerWithIdentifier:@"NAViewController1"];
        [self presentViewController:vc6 animated:YES completion:^{
            
        }];
    }
}

//加载网络数据
//参数flag=YES表示下拉刷新，flag=NO表示上拉刷新
- (void)reloadNetworkData:(BOOL)flag {
    if (flag) {//下拉刷新
        self.c = @"1";
        self.arrarData2 = [NSMutableArray array];
        self.b = 1;
        for (int i=0;i<[self.arrayData count];i++) {
            if (i > 9) {
                [self.arrarData2 addObject:[self.arrayData objectAtIndex:i]];
            }
        }
        
        for (int j=0; j<self.arrarData2.count; j++) {
            MyEntity1 *aaa= [self.arrarData2 objectAtIndex:j];
            [self.arrayData removeObject:aaa];
        }
        
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
        
    } else {//上拉刷新
        
        //创建一个归档文件夹
        NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[library lastObject] stringByAppendingPathComponent:@"name.plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *name = dic[@"name"];
        if (name.length > 0) {
            self.b += 1;
            self.c = @"1";
            [self gengxin];
        }
        else {
            if (self.b <= 2) {
                self.b += 1;
                self.c = @"1";
                [self gengxin];
            }
            else {
                self.c = @"0";
                [self refreshData];
            }
        }
    }
    
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
    if ([self.c isEqualToString:@"1"]) {
        self.HUD.label.text = @"加载完成";
    }
    else {
        self.HUD.label.text = @"浏览更多内容，请先登陆";
    }
    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:1.5];
    
}

//上拉刷新数据
- (void)gengxin {
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/Articles.action";
    NSString *body = [NSString stringWithFormat:@"npc=%d&type=时尚搭配",self.b];
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        for (NSDictionary *dic3 in array) {
            NSString *title = dic3[@"title"];
            NSString *image = dic3[@"imglink"];
            NSString *yuedu = [NSString stringWithFormat:@"阅读%@",dic3[@"readarts"]];
            NSString *like = [NSString stringWithFormat:@"喜欢%@",dic3[@"likecount"]];
            NSString *date = dic3[@"date"];
            NSString *ID = dic3[@"ID"];
            
            //保存到实体对象
            MyEntity1 *en = [[MyEntity1 alloc] init];
            en.title = title;
            en.image = image;
            en.yuedu = yuedu;
            NSRange rang = [like rangeOfString:@"0"];
            if (rang.location != NSNotFound) {
                en.like = @"";
            }
            else {
                en.like = like;
            }
            en.date = date;
            en.ID = ID;
            
            [self.arrayData addObject:en];
        }
    }];
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //获取自定义分栏
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *viewTab = [window viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        viewTab.frame = CGRectMake(0, h-49, w, 49);
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

#pragma mark - UITableViewDataSource

//设置表格有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayData count];
}

//设置表格视图每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.arrayData && [self.arrayData count]) {
//        return [self.arrayData count];
//    }
    
    return 1;
}

//设置表格视图每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell1";//定义一个可重用标识，在故事板里设置的！
    MyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self.arrayData && indexPath.row < [self.arrayData count])  {
        [cell setCell:[self.arrayData objectAtIndex:indexPath.section]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (self.arrayData && indexPath.row < [self.arrayData count])  {
        MyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell setCell:[self.arrayData objectAtIndex:indexPath.section]];
        height = cell.height;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.arrayData count])
    {
        MyEntity1 *en = [self.arrayData objectAtIndex:indexPath.section];
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MyViewController7 *vc7 = [main instantiateViewControllerWithIdentifier:@"MyViewController7"];
        vc7.wenzhangID = en.ID;
        [self.navigationController pushViewController:vc7 animated:YES];
    }
}



//设置组视图(或组标题)的高度 (这里需要讲解下！)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;//组视图(或组标题)的高度可以修改
}

//设置组尾视图(或组尾标题)的高度 (这里需要讲解下！)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;//组尾视图(或组尾标题)的高度可以修改
}


@end
