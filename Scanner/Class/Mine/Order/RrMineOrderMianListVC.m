//
//  RrMineOrderMianListVC.m
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineOrderMianListVC.h"
#import "LXScrollView.h"
#import "RrMineOrderListVC.h" // 订单列表
#import "RrOrderSearchVC.h"
@interface RrMineOrderMianListVC ()<LXScrollViewDelegate,LXScrollViewDataSource>
@property (nonatomic, strong) LXScrollView *sortView;
@property (nonatomic, strong) NSMutableArray *listVC;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation RrMineOrderMianListVC

- (void)dealloc{
    self.sortView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";
    self.titleArr = @[
        @"全部",
        @"审批中",
        @"待付款",
        @"待发货",
        @"待收货",
        @"已完成"
    ];
    // titleArr  item 对应的状态id
    NSArray *statusSetArr = @[
        @[],
        @[@(1),@(2)],
        @[@(3)],
        @[@(4),@(5)],
        @[@(6)],
        @[@(7)]
    ];
    @weakify(self)
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        RrMineOrderListVC *listVc = [[RrMineOrderListVC alloc]init];
        [self addChildViewController:listVc];
        listVc.statusSet = statusSetArr[idx];
        [self.listVC addObject:listVc];
    }];
    
    [self.view addSubview:self.sortView];
    self.sortView.selectItemIndex = 0;
    [self.sortView reloadData];
    
    
    //搜索
     [self addNavigationButtonImageRight:@"navi_search_icon" RightActionBlock:^{
         @strongify(self);
         RrOrderSearchVC *searVc =[RrOrderSearchVC new];
         searVc.type = RrSearchVCType_order;
         [self.navigationController pushViewController:searVc animated:YES];
     }];


}

- (NSMutableArray *)listVC{
    if (!_listVC) {
        _listVC = [NSMutableArray array];
    }
    return _listVC;
}

- (LXScrollView *)sortView{
    if (!_sortView) {
        _sortView = [[LXScrollView alloc]initWithFrame:CGRectMake(0, 0, KFrameWidth, KScreenHeight) andBarWidth:KFrameWidth];
        _sortView.delegate = self;
        _sortView.dataSource = self;
        _sortView.type = LXScrollViewItemWidthType_equalAll;
    }
    return _sortView;
}
- (NSArray <NSString *>*)gsSortViewTitles{
    return self.titleArr;
}
- (UIView *)gsSortView:(LXScrollView *)sortView viewForIndex:(NSInteger)index{
    RrMineOrderListVC *listVc = self.listVC[index];
    return listVc.view;
}
- (void)gsSortViewDidScroll:(NSInteger)index{
    NSLog(@"click ======== %ld",index);
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
