//
//  MainTabBarVC.m
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//



#import "MainTabBarVC.h"
#import "ViewController.h"
@interface MainTabBarVC () <JJTabBarControllerDelegate,JJBarViewDelegate>
@property (nonatomic, strong) LoginVC *login;

@property (nonatomic, assign) NSInteger      previousClickedTag;//记录上次点击item 的  index
@property (nonatomic, strong) NSDate         *lastSelectedDate; //记录最后一次点击item 的时间
@property (nonatomic, strong) LXNavigationController *oldNavigVC; // 记录上一个navi (扫描除外)
@end

@implementation MainTabBarVC

- (LoginVC *)login{
    if (!_login) {
        _login = [LoginVC new];
    }
    return _login;
}

- (LXScanViewController *)scanVC{
    if (!_scanVC) {
        _scanVC = [LXScanViewController new];
    }
    return _scanVC;;
}

- (OrderViewController *)orderVC{
    if (!_orderVC) {
        _orderVC = [OrderViewController new];
    }
    return _orderVC;;
}

- (MineViewController *)mineVC{
    if (!_mineVC) {
        _mineVC = [MineViewController new];
    }
    return _mineVC;;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JJTabBarView *tabBarView = [[JJTabBarView alloc] initWithFrame:CGRectMake(0, 0, KTabar_Width, 44)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    tabBarView.delegate = self;
    
    LXNavigationController *navSp = [[LXNavigationController alloc] initWithRootViewController: self.scanVC];
    self.scanVC.title = @"3D扫描";
    self.scanVC.tabBarItem.image = [UIImage imageNamed:@"saomiao"];
    
    
    
    LXNavigationController *navSp2 = [[LXNavigationController alloc] initWithRootViewController:self.orderVC];
    self.orderVC.title = @"定制下单";
    self.orderVC.tabBarItem.image = [UIImage imageNamed:@"order-icon-n"];
    self.orderVC.tabBarItem.selectedImage = [UIImage imageNamed:@"order-icon-y"];
    
    
    self.mineVC.title = @"我的";
    self.mineVC.tabBarItem.image = [UIImage imageNamed:@"mine-icon-n"];
    self.mineVC.tabBarItem.selectedImage = [UIImage imageNamed:@"mine-icon-y"];
    LXNavigationController *navSp3 = [[LXNavigationController alloc] initWithRootViewController: self.mineVC];
    
    self.mineVC.hidenLeftTaBar = NO;
    self.orderVC.hidenLeftTaBar = NO;
    self.scanVC.hidenLeftTaBar = NO;
    
    _tabBarController = [[JJTabBarController alloc] initWithTabBar:tabBarView andDockPosition:JJTabBarDockLeft];
    _tabBarController.delegate = self;
    _tabBarController.tabBarChilds = @[navSp, navSp2, navSp3];
    _tabBarController.selectedTabBarIndex = 1;
    [self addChildViewController:_tabBarController];
    [self.view addSubview:_tabBarController.view];
    [_tabBarController didMoveToParentViewController:self];
    
}

#pragma mark - JTabBarControllerDelegate


- (UIButton *)tabBarController:(JJTabBarController *)tabBarController tabBarButtonForTabBarChild:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, KTabar_Width, KTabar_Width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, -40, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-20, 25, 0, 0);
    if (index == 0){
        btn.imageEdgeInsets = UIEdgeInsetsMake(-20, 25, 0, 0);
    }
    btn.tag = index;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor c_iconNorColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor c_iconSelectColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarControllerTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)tabBarControllerTap:(UIButton *)tabarBtn{
    NSInteger index = tabarBtn.tag;
    //再次点击同一个item时发送通知出去 对应的VC捕获并判断
    if (self.previousClickedTag == index) {
        // 获取当前点击时间
        NSDate *currentDate = [NSDate date];
        CGFloat timeInterval = currentDate.timeIntervalSince1970 - _lastSelectedDate.timeIntervalSince1970;
        // 两次点击时间间隔少于 0.5S 视为一次双击
        if (timeInterval < 0.5) {
            // 通知首页刷新数据
            if(index == 0){
                NSLog(@"是双击。。。通知首页刷新");
            }else if(index == 1){
                if ([self.orderVC.navigationController.viewControllers count] >1) {
                    [self.orderVC.navigationController popToRootViewControllerAnimated:YES];
                }
            }else if (index == 2){
                if ([self.mineVC.navigationController.viewControllers count] >1) {
                    [self.mineVC.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            // 双击之后将上次选中时间置为1970年0点0时0分0秒,用以避免连续三次或多次点击
            _lastSelectedDate = [NSDate dateWithTimeIntervalSince1970:0];
            
        }
        // 若是单击将当前点击时间复制给上一次单击时间
        _lastSelectedDate = currentDate;
    }
    self.previousClickedTag = index;
}

#pragma mark - JJTabBarControllerDelegate
- (BOOL)tabBarController:(JJTabBarController *)tabBarController willSelectTabBarChild:(UIViewController *)childViewController forIndex:(NSInteger)index
{
    if (index == 0) {
        ViewController *scanVc = [ViewController viewController];
        self.hidenLeftTaBar = YES;
        [self.oldNavigVC pushViewController:scanVc animated:YES];
        return NO;
    }else{
        self.oldNavigVC = (LXNavigationController*)childViewController;
    }
    
    return YES;
}
- (void)tabBarController:(JJTabBarController *)tabBarController didSelectTabBarChild:(UIViewController *)childViewController forIndex:(NSInteger)index{

    
}
//设置 item 位置
- (void)barView:(JJBarView *)barView layoutChild:(UIView *)childView withFrame:(CGRect)frame{
    CGFloat item_h = KTabar_Width;
    NSInteger offset_index = [barView.childViews indexOfObject:childView];
    childView.frame = CGRectMake(0, barView.frame.size.height -item_h*barView.childViews.count-iPH(44)+offset_index *item_h , frame.size.width, item_h);
    
}

@end

