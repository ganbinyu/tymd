//
//  MyViewController3.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "MyViewController3.h"
#import "MyEntity2.h"
#import "MyCell3.h"
#import "MyCell3_1.h"
#import "UIImageView+AFNetworking.h"
#import "MyViewController7.h"

@interface MyViewController3 ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *ary;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) UIScrollView *sc;
@property (nonatomic,strong) UIPageControl *pa;
@property (nonatomic) int a;
@property (nonatomic,strong) UILabel *leb;
@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSString *c;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSMutableArray *arrayData2;
@property (nonatomic) int b;
@property (nonatomic,strong) SDRefreshHeaderView *refreshHeaderView;//下啦刷新控件
@property (nonatomic,strong) SDRefreshFooterView *refreshFooterView;//上拉刷新控件
@end

@implementation MyViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *leb = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20, 20, 40, 30)];
    leb.text = @"明星";
    leb.font = [UIFont systemFontOfSize:22];
    [leb setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:leb];
    
    //准备数据源
    self.b = 1;
    self.arrayData = [NSMutableArray array];
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/Articles.action";
    NSString *body = @"npc=0&type=明星衣品";
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    self.ary = [NSMutableArray array];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        for (int i =0;i<array.count;i++) {
            NSDictionary *dic = array[i];
            NSString *title = dic[@"title"];
            NSString *image = dic[@"imglink"];
            NSString *context = dic[@"content168"];
            NSString *ID = dic[@"ID"];
            
            MyEntity2 *en = [[MyEntity2 alloc] init];
            en.title = title;
            en.image = image;
            en.content = context;
            en.ID = ID;
            
            if (i < 5) {
                [self.ary addObject:en];
            }
            
            if (i%2 != 0) {
                en.type = 1;
            }
            else {
                en.type = 2;
            }
            
            if (i > 4) {
                [self.arrayData addObject:en];
            }
        }
        
        //主线程刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            
            //设置tableview头视图
            self.titleArray = [NSMutableArray array];
            CGFloat W = [UIScreen mainScreen].bounds.size.width;
            CGFloat H = [UIScreen mainScreen].bounds.size.height;
            
            UIView *touView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, H/3)];
            
            
             self.sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, W, H/3)];
            self.sc.delegate = self;
            self.sc.pagingEnabled = YES;
            if (self.ary && self.ary.count > 0) {
                for (int i=1;i<=self.ary.count;i++) {
                    W = self.sc.bounds.size.width;
                    H = self.sc.bounds.size.height;
                    MyEntity2 *en = self.ary[i-1];
                    [self.titleArray addObject:en.title];
                    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i*W, 0, W, H)];
                    [image setImageWithURL:[NSURL URLWithString:en.image] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
                    image.userInteractionEnabled = YES;
                    image.tag = 1000 + i;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
                    [image addGestureRecognizer:tap];
                    [self.sc addSubview:image];
                }
                
                //第一张图片
                UIImageView *fistView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, self.sc.frame.size.height)];
                MyEntity2 *fistEn = [self.ary lastObject];
                [fistView setImageWithURL:[NSURL URLWithString:fistEn.image] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
//                fistView.userInteractionEnabled = YES;
//                fistView.tag = 1004;
                [self.sc addSubview:fistView];
                //最后一张图片
                UIImageView *lastView = [[UIImageView alloc] initWithFrame:CGRectMake(6*W, 0, W, self.sc.frame.size.height)];
                MyEntity2 *lastEN = [self.ary firstObject];
                [lastView setImageWithURL:[NSURL URLWithString:lastEN.image] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
//                lastView.userInteractionEnabled = YES;
//                lastView.tag = 1000;
                [self.sc addSubview:lastView];
                
                self.sc.contentSize = CGSizeMake(W*(self.ary.count + 2), 0);
                [touView addSubview:self.sc];
                self.sc.contentOffset = CGPointMake(self.sc.frame.size.width, 0);
                self.myTableView.tableHeaderView = touView; //设置tableView的头视图
                
                //半透明图片
                UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.sc.frame.size.height-30, self.sc.frame.size.width, 30)];
                view3.backgroundColor = [UIColor blackColor];
                view3.alpha = 0.5;
                [touView addSubview:view3];
                
                UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, self.sc.frame.size.height-30, self.sc.frame.size.width, 30)];
                view4.backgroundColor = [UIColor clearColor];//透明
                [touView addSubview:view4];
                
                //图片标题
                self.leb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view3.frame.size.width-90, 30)];
                [self.leb setTextColor:[UIColor whiteColor]];
                self.leb.text = lastEN.title;
                [view4 addSubview:self.leb];
                
                
                //网页控制器
                self.pa = [[UIPageControl alloc] initWithFrame:CGRectZero];
//                int pages = self.sc.contentSize.width/self.sc.frame.size.width-2;
                int pages = 5;
                NSLog(@"%d",pages);
                CGSize size = [self.pa sizeForNumberOfPages:pages];
                self.pa.frame = CGRectMake(view3.frame.size.width-80, 0, size.width, size.height);
                self.pa.pageIndicatorTintColor = [UIColor grayColor];
                self.pa.currentPageIndicatorTintColor = [UIColor whiteColor];
                    self.pa.numberOfPages = pages;
                [view4 addSubview:self.pa];
                
                
                //添加时间器
                self.a = 1;
                [self performSelector:@selector(time) withObject:nil afterDelay:0];//马上调用
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(time) userInfo:nil repeats:YES];
            }
        });
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//不向四周延展
    //添加下拉刷新控件
    self.refreshHeaderView = [SDRefreshHeaderView refreshView];
    [self.refreshHeaderView addToScrollView:self.myTableView];
    __weak MyViewController3 *wealSelf = self;
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

//定时器
- (void)time {
    NSLog(@"%d",self.a);
    if (self.a <= 4) {
        [UIView animateWithDuration:1.5 animations:^{
            self.sc.contentOffset = CGPointMake(self.a*self.sc.frame.size.width, 0);
        } completion:^(BOOL finished) {
            self.leb.text = self.titleArray[self.a-2];
            self.pa.currentPage = self.a-2;
        }];
        
    }
    if (self.a == 5) {
        [UIView animateWithDuration:1.5 animations:^{
            self.sc.contentOffset = CGPointMake(self.a*self.sc.frame.size.width, 0);
        } completion:^(BOOL finished) {
            [self.sc setContentOffset:CGPointMake(0, 0)];
            self.leb.text = self.titleArray[4];
            self.pa.currentPage = 5;
        }];
        self.a = 0;
    }
//    if (self.a > 5) {
////        [self.sc setContentOffset:CGPointMake(0, 0)];
////        [UIView animateWithDuration:1.5 animations:^{
////            self.sc.contentOffset = CGPointMake(self.sc.frame.size.width, 0);
////            self.leb.text = self.titleArray[1];
////        }];
////        self.pa.currentPage = 1;
////        self.a = 1;
//        [UIView animateWithDuration:1.5 animations:^{
//            self.sc.contentOffset = CGPointMake(self.sc.frame.size.width, 0);
//        } completion:^(BOOL finished) {
//            self.leb.text = self.titleArray[1];
//            self.pa.currentPage = 1;
//        }];
//        self.a = 1;
//    }
    self.a ++;
}

- (void)imageClick:(UITapGestureRecognizer*)gesture {
    int a = (int)gesture.view.tag - 1000;
    MyEntity2 *en = self.ary[a-1];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyViewController7 *vc7 = [main instantiateViewControllerWithIdentifier:@"MyViewController7"];
    vc7.wenzhangID = en.ID;
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

//上拉刷新数据
- (void)gengxin {
    NSString *str = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/Articles.action";
    NSString *body = [NSString stringWithFormat:@"npc=%d&type=明星衣品",self.b];
    NSString *url = [NSString stringWithFormat:@"%@/%@",str,body];
    AFpostRequest *request = [AFpostRequest json];
    [request downloadGetJson:url finish:^(NSDictionary *obj) {
        NSDictionary *dic = obj[@"root"];
        NSArray *array = dic[@"list"];
        for (int i =0;i<array.count;i++) {
            NSDictionary *dic = array[i];
            NSString *title = dic[@"title"];
            NSString *image = dic[@"imglink"];
            NSString *context = dic[@"content168"];
            NSString *ID = dic[@"ID"];
            
            MyEntity2 *en = [[MyEntity2 alloc] init];
            en.title = title;
            en.image = image;
            en.content = context;
            en.ID = ID;
            
            if (i%2 != 0) {
                en.type = 1;
            }
            else {
                en.type = 2;
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pages = scrollView.contentOffset.x/self.sc.frame.size.width-1;
    NSLog(@"%d",pages);
    if (pages < 5 && pages >= 0) {
//        self.a = pages+1;
        self.leb.text = self.titleArray[pages];
        self.pa.currentPage = pages;
    }
    if (pages == 5) {
//        self.a = 1;
        self.leb.text = self.titleArray[0];
        self.pa.currentPage = 0;
        self.sc.contentOffset = CGPointMake(self.sc.frame.size.width, 0);
    }
    if (pages == -1) {
//        self.a = 4;
        self.leb.text = self.titleArray[4];
        self.pa.currentPage = 5;
        self.sc.contentOffset = CGPointMake(5*self.sc.frame.size.width, 0);
    }
    [self.pa updateCurrentPageDisplay];
}

#pragma mark - UITableViewDataSource
//设置表格视图每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayData && [self.arrayData count]) {
        return [self.arrayData count];
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayData && indexPath.row < [self.arrayData count])  {
        MyEntity2 *en = [self.arrayData objectAtIndex:indexPath.row];
        if (en.type == 1) {
            static NSString *cellIdentifier = @"cell3";
            MyCell3 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setCell:[self.arrayData objectAtIndex:indexPath.row]];
            return cell;
        } else if (en.type == 2) {
            static NSString *cellIdentifier2 = @"cell3_1";
            MyCell3_1 *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            [cell2 setCell:[self.arrayData objectAtIndex:indexPath.row]];
            return cell2;
        }
    }
    //如果以上都没有，则返回默认cell。防止程序闪退
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 133;
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
