//
//  MyViewController4.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController4.h"
#import "MyEntity2.h"
#import "MyCell4.h"
#import "MyCell4_1.h"
#import "MyViewController7.h"

@interface MyViewController4 ()
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSString *c;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSMutableArray *arrayData2;
@property (nonatomic) int b;
@property (nonatomic,strong) SDRefreshHeaderView *refreshHeaderView;//下啦刷新控件
@property (nonatomic,strong) SDRefreshFooterView *refreshFooterView;//上拉刷新控件

@end

@implementation MyViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *leb = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20, 20, 40, 30)];
    leb.text = @"单品";
    leb.font = [UIFont systemFontOfSize:22];
    [leb setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:leb];
    
    //准备数据源
    self.b = 1;
    self.arrayData = [NSMutableArray array];
    
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/Articles.action";
    NSString *body = @"npc=0&type=单品";
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        for (NSDictionary *dic in array) {
            NSString *title = dic[@"title"];
            NSString *date = dic[@"CTIME"];
            NSString *yuedu = [NSString stringWithFormat:@"%@阅读",dic[@"readarts"]];
            NSString *image = dic[@"imglink"];
            NSString *image2 = dic[@"imglink_2"];
            NSString *image3 = dic[@"imglink_3"];
            NSString *ID = dic[@"ID"];
            
            MyEntity2 *en = [[MyEntity2 alloc] init];
            en.title = title;
            en.image = image;
            en.image2 = image2;
            en.image3 = image3;
            en.yuedu = yuedu;
            en.date = date;
            en.ID = ID;
            if (image2.length > 0) {
                en.type = 2;
            }
            else {
                en.type = 1;
            }
            
            [self.arrayData addObject:en];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//不向四周延展
    //添加下拉刷新控件
    self.refreshHeaderView = [SDRefreshHeaderView refreshView];
    [self.refreshHeaderView addToScrollView:self.myTableView];
    __weak MyViewController4 *wealSelf = self;
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

//加载网络数据
//参数flag=YES表示下拉刷新，flag=NO表示上拉刷新
- (void)reloadNetworkData:(BOOL)flag {
    if (flag) {//下拉刷新
        self.b = 1;
        self.c = @"1";
        self.arrayData2 = [NSMutableArray array];
        for (int i=0;i<[self.arrayData count];i++) {
            if (i > 9) {
                [self.arrayData2 addObject:[self.arrayData objectAtIndex:i]];
            }
        }
        
        for (int j=0; j<self.arrayData2.count; j++) {
            MyEntity2 *aaa= [self.arrayData2 objectAtIndex:j];
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

//上拉刷新数据
- (void)gengxin {
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/Articles.action";
    NSString *body = [NSString stringWithFormat:@"npc=%d&type=明星衣品",self.b];
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        for (NSDictionary *dic in array) {
            NSString *title = dic[@"title"];
            NSString *date = dic[@"CTIME"];
            NSString *yuedu = [NSString stringWithFormat:@"%@阅读",dic[@"readarts"]];
            NSString *image = dic[@"imglink"];
            NSString *image2 = dic[@"imglink_2"];
            NSString *image3 = dic[@"imglink_3"];
            NSString *ID = dic[@"ID"];
            
            MyEntity2 *en = [[MyEntity2 alloc] init];
            en.title = title;
            en.image = image;
            en.image2 = image2;
            en.image3 = image3;
            en.yuedu = yuedu;
            en.date = date;
            en.ID = ID;
            if (image2.length > 0) {
                en.type = 2;
            }
            else {
                en.type = 1;
            }
            
            [self.arrayData addObject:en];
        }
    }];
    
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
    if ([self.c isEqualToString:@"1"]) {
        self.HUD.label.text = @"加载完成";
    }
    else {
        self.HUD.label.text = @"浏览更多内容，请先登陆";
    }

    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:1.5];
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
    if (self.arrayData && indexPath.row < [self.arrayData count]) {
        MyEntity2 *en = [self.arrayData objectAtIndex:indexPath.row];
        if (en.type == 1) {
            static NSString *cellIdentifier = @"cell4";//定义一个可重用标识，在故事板里设置的！
            MyCell4 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setCell:en];
            return cell;
        }
        else {
            static NSString *cellIdentifier2 = @"cell4_1";//定义一个可重用标识，在故事板里设置的！
            MyCell4_1 *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            [cell2 setCell:en];
            return cell2;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 0;
    if (self.arrayData && indexPath.row < self.arrayData.count) {
        MyEntity2 *en = self.arrayData[indexPath.row];
        if (en.type == 1) {
            h = 140;
        } else if (en.type == 2) {
            if (self.arrayData && indexPath.row < [self.arrayData count])  {
                MyCell4_1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4_1"];
                [cell setCell:[self.arrayData objectAtIndex:indexPath.row]];
                h = cell.height;
            }
            return h;
        }
    }
    return h;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.arrayData count])
    {
        MyEntity2 *en = [self.arrayData objectAtIndex:indexPath.row];
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MyViewController7 *vc7 = [main instantiateViewControllerWithIdentifier:@"MyViewController7"];
        vc7.wenzhangID = en.ID;
        [self.navigationController pushViewController:vc7 animated:YES];
    }
}

@end
