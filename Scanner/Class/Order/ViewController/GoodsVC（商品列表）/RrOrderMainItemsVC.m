//
//  RrOrderMainItemsVC.m
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderMainItemsVC.h"
#import "RrOrderItemsListVC.h"
#import "RrOrderItemsListModel.h"
#import "RrProductSearchVC.h"
@interface RrOrderMainItemsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RrOrderItemsListModel *currentListModel;
@property (nonatomic, strong) NSMutableArray *listVCArr;
@property (nonatomic, strong) RrOrderItemsListVC *currentListVc;


@end

@implementation RrOrderMainItemsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftMainView];
    [self addRightSubVCView];
    [self addRightNaviSearchView];
}


- (void)addRightNaviSearchView{
    @weakify(self)
    [self addNavigationButtonImageRight:@"navi_search_icon" RightActionBlock:^{
        @strongify(self);
        RrProductSearchVC *searVc =[RrProductSearchVC new];
        searVc.type = RrSearchVCType_product;
        [self.navigationController pushViewController:searVc animated:YES];
    }];
}

- (void)addRightSubVCView{
    @weakify(self)

    self.listVCArr = [NSMutableArray array];
    for (OrderVCModel *model in self.model.items) {
        RrOrderItemsListVC *listVc = [RrOrderItemsListVC new];
               listVc.view.frame = CGRectMake(self.tableView.width, self.tableView.top, KFrameWidth-self.tableView.width, self.tableView.height);
        listVc.model = model;
        listVc.view.hidden = YES;
        [self addChildViewController:listVc];
        [self.listVCArr addObject:listVc];
    }
    self.currentListVc = [self.listVCArr firstObject];
    self.currentListVc.view.hidden = NO;
    [self.view addSubview:self.currentListVc.view];


    
}

- (void)addLeftMainView{
    self.dataArray = [[NSMutableArray alloc] initWithArray:self.model.items];
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([RrCommonRowCell class]) cellIndentifier:RrCommonRowCell_ID];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}



#pragma  mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    CGFloat cell_h = self.tableView.height/self.dataArray.count;
    return iPH(51);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderVCModel *model = self.dataArray[indexPath.row];
    RrCommonRowCell *cell = [tableView dequeueReusableCellWithIdentifier:RrCommonRowCell_ID forIndexPath:indexPath];
    cell.contenViewBg.backgroundColor = [UIColor clearColor];
    cell.mainTitleLabel.hidden = YES;
    cell.centerLabel.hidden = NO;
    cell.centerLabel.font = KFont19;
    cell.centerLabel.text = model.name;
    
    [cell getCellSelectedBlock:^(BOOL selected, BOOL animated) {
        if (selected) {
            cell.centerLabel.textColor = [UIColor c_GreenColor];
            cell.backgroundColor = [UIColor mian_BgColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.centerLabel.textColor = [UIColor blackColor];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentListVc.view.hidden = YES;
    RrOrderItemsListVC *listVC = self.listVCArr[indexPath.row];
    listVC.view.hidden = NO;
//    listVC.model = model;
    [self.view addSubview:listVC.view];
    self.currentListVc = listVC;
}


#pragma mark UI
- (UITableView *)tableView{
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iPW(188), KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 51;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor c_lineColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView addLine_left];
        [_tableView addLine_right];
    }
    return _tableView;
}

@end
