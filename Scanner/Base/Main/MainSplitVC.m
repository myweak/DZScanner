//
//  MainSplitVC.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainSplitVC.h"
@interface MainSplitVC ()<MainVCDelegate>
@property (nonatomic, copy) NSArray *vcs;

@end

@implementation MainSplitVC

- (void)loadView{
    [super loadView];
//    [self setupSpliteViewController];
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSpliteViewController];
    }
    return self;
}

#pragma mark 设置SpliteViewController
- (void)setupSpliteViewController
{
    //左侧主视图a
    LXLeftMainVC *tabar = [[LXLeftMainVC alloc] init];
//    [tabar.view.layer removeFromSuperlayer]

    tabar.vcDelegate = self;
    //右侧默认视图
    LXNavigationController *nav1 = [[LXNavigationController alloc]initWithRootViewController:self.mineVC];

    LXNavigationController *nav2 = [[LXNavigationController alloc]initWithRootViewController:self.orderVC ];
    
    LXNavigationController *nav3 = [[LXNavigationController alloc]initWithRootViewController:self.scanVC];

    
    // ==== 注意请看这里 ====
    // mainVC -> 左边主视图，nav1 -> 是右边对应的详情控制器

    self.viewControllers = @[tabar,nav2];
    self.vcs = @[nav1,nav2,nav3];
    
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    self.maximumPrimaryColumnWidth = KTabar_Width;//调整左侧主视图Master Controller的最大显示宽度
}

- (void)didSelectIndex:(NSInteger)index {
    if (self.vcs.count > index) {
        [self showViewController:self.vcs[index] sender:nil];
    }
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


@end
