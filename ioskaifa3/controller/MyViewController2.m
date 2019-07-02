//
//  MyViewController2.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController2.h"
#import "MyEntity2.h"
#import "MyCell2_1.h"
#import "UIImageView+AFNetworking.h"
#import "YDImageView.h"
#import "MyViewController7.h"


@interface MyViewController2 ()<MyCell2_1Delegate>
@property (nonatomic,strong) MyEntity2 *entou;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic) int b;
@property (nonatomic,strong) NSMutableArray *arrayData2;
@property (nonatomic,strong) SDRefreshHeaderView *refreshHeaderView;//下啦刷新控件
@property (nonatomic,strong) SDRefreshFooterView *refreshFooterView;//上拉刷新控件
@property (nonatomic,strong) NSString *c;
@end

@implementation MyViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *leb = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20, 20, 40, 30)];
    leb.text = @"街拍";
    leb.font = [UIFont systemFontOfSize:22];
    [leb setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:leb];
    
//    self.arrayData = [NSMutableArray array];
    
    self.b = 1;
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/Articles.action";
    NSString *body = @"npc=0&type=潮流街拍";
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        NSDictionary *dic1 = array[0];
        NSString *title = dic1[@"title"];
        NSString *image = dic1[@"imglink"];
        NSString *ID = dic1[@"ID"];
        self.entou = [[MyEntity2 alloc] init];
        self.entou.title = title;
        self.entou.image = image;
        self.entou.ID = ID;
        
        dispatch_async(dispatch_get_main_queue(), ^{ //主线程显示
            CGFloat W = [UIScreen mainScreen].bounds.size.width;
            UIView *touView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, 300)];
//            UIImageView *touImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, 250)];
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image]];
//            touImage.image = [UIImage imageWithData:data];
//            [touView addSubview:touImage];
            
            //设置tableView头视图
            YDImageView *touImage = [[YDImageView alloc] initWithFrame:CGRectMake(0, 0, W, 250)];
            [touImage yidaImageURL:image placeholderImage:[UIImage imageNamed:@"defaultimg"]];
            [touView addSubview:touImage];
            
            UILabel *leb = [[UILabel alloc] initWithFrame:CGRectMake(5, touImage.frame.size.height, W-10, 50)];
            leb.textAlignment = NSTextAlignmentLeft;
            leb.font = [UIFont systemFontOfSize:19];
            leb.numberOfLines = 2;
            leb.text = title;
            [touView addSubview:leb];
            
            self.myTableView.tableHeaderView = touView;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touClicked:)];
            [touView addGestureRecognizer:tap];
        });
        
        
        NSMutableArray *ary = [NSMutableArray array];
        for (int i = 1;i < array.count;i++) {
            NSDictionary *dic = array[i];
            NSString *title = dic[@"title"];
            NSString *image = dic[@"imglink"];
            NSString *like = [NSString stringWithFormat:@"%@",dic[@"likecount"]];
            NSString *yuedu = [NSString stringWithFormat:@"%@",dic[@"readarts"]];
            NSString *ID = dic[@"ID"];
            MyEntity2 *en = [[MyEntity2 alloc] init];
            en.title = title;
            en.image = image;
            en.like = like;
            en.yuedu = yuedu;
            en.ID = ID;
            
            [ary addObject:en];
        }
        
        NSMutableArray *ary1 = [NSMutableArray arrayWithObjects:ary[0],ary[1], nil];
        NSMutableArray *ary2 = [NSMutableArray arrayWithObjects:ary[2],ary[3], nil];
        NSMutableArray *ary3 = [NSMutableArray arrayWithObjects:ary[4],ary[5], nil];
        NSMutableArray *ary4 = [NSMutableArray arrayWithObjects:ary[6],ary[7], nil];
        NSMutableArray *ary5 = [NSMutableArray arrayWithObjects:ary[8], nil];
        
        self.arrayData = [NSMutableArray arrayWithObjects:ary1,ary2,ary3,ary4,ary5, nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
        
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//不向四周延展
    //添加下拉刷新控件
    self.refreshHeaderView = [SDRefreshHeaderView refreshView];
    [self.refreshHeaderView addToScrollView:self.myTableView];
    __weak MyViewController2 *wealSelf = self;
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

//头视图点击
- (void)touClicked:(UITapGestureRecognizer*)gesture {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyViewController7 *vc7 = [main instantiateViewControllerWithIdentifier:@"MyViewController7"];
    vc7.wenzhangID = self.entou.ID;
    [self.navigationController pushViewController:vc7 animated:YES];
}

//加载网络数据
//参数flag=YES表示下拉刷新，flag=NO表示上拉刷新
- (void)reloadNetworkData:(BOOL)flag {
    if (flag) {//下拉刷新
        self.b = 1;
        self.c = @"1";
        self.arrayData2 = [NSMutableArray array];
        for (int i=0;i<[self.arrayData count];i++) {
            if (i == 4) {
                NSMutableArray *array = [self.arrayData objectAtIndex:i];
                if (array.count == 2) {
                    [array removeLastObject];
                }
            }
            if (i > 4) {
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
    NSString *body = [NSString stringWithFormat:@"npc=%d&type=潮流街拍",self.b];
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        NSMutableArray *ary = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            NSString *title = dic[@"title"];
            NSString *image = dic[@"imglink"];
            NSString *like = [NSString stringWithFormat:@"%@",dic[@"likecount"]];
            NSString *yuedu = [NSString stringWithFormat:@"%@",dic[@"readarts"]];
            NSString *ID = dic[@"ID"];
            
            //保存到实体对象
            MyEntity2 *en = [[MyEntity2 alloc] init];
            en.title = title;
            en.image = image;
            en.like = like;
            en.yuedu = yuedu;
            en.ID = ID;
            
            [ary addObject:en];
        }
        NSMutableArray *ary0 = [self.arrayData lastObject];
        if (ary0.count < 2) {
            [ary0 addObject:ary[0]];
        }
        NSMutableArray *ary1 = [NSMutableArray arrayWithObjects:ary[1],ary[2], nil];
        NSMutableArray *ary2 = [NSMutableArray arrayWithObjects:ary[3],ary[4], nil];
        NSMutableArray *ary3 = [NSMutableArray arrayWithObjects:ary[5],ary[6], nil];
        NSMutableArray *ary4 = [NSMutableArray arrayWithObjects:ary[7],ary[8], nil];
        NSMutableArray *ary5 = [NSMutableArray arrayWithObjects:ary[9], nil];
        
        [self.arrayData addObjectsFromArray:@[ary1,ary2,ary3,ary4,ary5]];
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
    static NSString *cellIdentifier = @"cell2_1";//定义一个可重用标识，在故事板里设置的！
    MyCell2_1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    if (self.arrayData && indexPath.row < [self.arrayData count])  {
        [cell setCell:[self.arrayData objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat height = 0;
//    if (self.arrayData && indexPath.row < [self.arrayData count])  {
//        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCustomCell"];
//        [cell setCellWithInfo:self.arrayData[indexPath.row]];
//        height = cell.height;
//    }
    return 192;
}


- (void)getBtn:(NSString *)str {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyViewController7 *vc7 = [main instantiateViewControllerWithIdentifier:@"MyViewController7"];
    vc7.wenzhangID = str;
    [self.navigationController pushViewController:vc7 animated:YES];
}

@end
