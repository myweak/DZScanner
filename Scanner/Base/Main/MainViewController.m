//
//  MainViewController.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.title.length) {
        [MobClick beginLogPageView:self.title]; //("Pagename"为页面名称，可自定义)
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.title.length) {
        [MobClick endLogPageView:self.title];
    }
}


- (void)dealloc{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MZAssetsManager shareManager] reset];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor mian_BgColor];
    [self addBackButton];
    [self.view addSubview:self.notNetWorkView];

}





/*!
 @brief     左边按钮
 */
- (void)addNavigationButtonLeft:(NSString *)title
               RightActionBlock:(NaviBtnActionBlock)leftActionBlock{
    _leftActionBlock = [leftActionBlock copy];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:title
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(leftNavigationAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor]; // 临时
    
}

/*!
 @brief     右边按钮
 */
- (void)addNavigationButtonRight:(NSString *)title
                RightActionBlock:(NaviBtnActionBlock)rightActionBlock{
    _rightActionBlock = [rightActionBlock copy];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:title
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(rightNavigationAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor c_GreenColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
}

/*!
 @brief     右边按钮[自定义]---- 预留
 */
- (void)addNavigationButtonRight:(NSString *)title
                     selectTitle:(NSString *)selectTitle
                      nomalColor:(UIColor *)nomalColor
                highLightedColor:(UIColor *)highLightedColor
                         btnFont:(UIFont *)btnFont
                RightActionBlock:(RightDefineActionBlock)rightDefineActionBlock{
    
}

/*!
 @brief     左边按钮【图片】
 */
- (void)addNavigationButtonImageLeft:(NSString *)buttonImage
                    RightActionBlock:(NaviBtnActionBlock)leftActionBlock{
    _leftActionBlock = [leftActionBlock copy];
    UIImage *image = [UIImage imageNamed:buttonImage];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithImage:image
                             style:UIBarButtonItemStylePlain
                             target:self
                             action:@selector(leftNavigationAction)];
    self.navigationItem.leftBarButtonItem = item;
    
}

/*!
 @brief   自定义  右边按钮【图片】
 */
- (UIButton *)addRightNavigationCustomButtonWithActionBlock:(NaviBtnActionBlock)rightActionBlock{
    
    _rightActionBlock = [rightActionBlock copy];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, iPW(200), 44);
//    btn.backgroundColor = [UIColor yellowColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(rightNavigationAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor c_GreenColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    __strong UIButton *strongBtn = btn;
    return strongBtn;
}

/*!
 @brief     右边按钮【图片】
 */
- (void)addNavigationButtonImageRight:(NSString *)buttonImage
                     RightActionBlock:(NaviBtnActionBlock)rightActionBlock{
    _rightActionBlock = [rightActionBlock copy];
    UIImage *image = [UIImage imageNamed:buttonImage];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithImage:image
                             style:UIBarButtonItemStylePlain
                             target:self
                             action:@selector(rightNavigationAction)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - button action
-(void)leftNavigationAction{
    !_leftActionBlock ? :_leftActionBlock();
}
-(void)rightNavigationAction{
    !_rightActionBlock ? :_rightActionBlock();
}


- (UIButton*)addBottomBtnWithTitle:(NSString *)title actionBlock:(void(^)(UIButton *btn))block{
    
    UIButton *btn = [UIButton dd_buttonCustomButtonWithFrame:CGRectMake(0, 0, KFrameWidth, iPH(50)) title:title backgroundColor:[UIColor c_btn_Bg_Color] titleColor:[UIColor whiteColor] tapAction:block];
    btn.titleLabel.font = KFont20;
    btn.bottom = KScreenHeight-64;
    [self.view addSubview:btn];
    return btn;
    
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return YES;
}



- (UITableView *)superTableView{
    
    if (!_superTableView) {//UITableViewStyleGrouped
        _superTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, (KFrameHeight-64)) style:UITableViewStylePlain];
        _superTableView.rowHeight = UITableViewAutomaticDimension;
        _superTableView.estimatedRowHeight = 73;
        _superTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _superTableView.delegate = self;
        _superTableView.dataSource = self;
        _superTableView.backgroundColor = [UIColor mian_BgColor];
        _superTableView.tableHeaderView = [UIView new];
        _superTableView.tableFooterView = [UIView new];
    }
    return _superTableView;
}

- (TZNotNetworkView *)notNetWorkView{
    if(!_notNetWorkView){
        _notNetWorkView = [[TZNotNetworkView alloc] init];
        _notNetWorkView.hidden = YES;
    }
    return _notNetWorkView;
}

//
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return _StatusBarStyle;
//}
//
//
//
////动态更新状态栏颜色
//-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
//    _StatusBarStyle=StatusBarStyle;
//    [self setNeedsStatusBarAppearanceUpdate];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
