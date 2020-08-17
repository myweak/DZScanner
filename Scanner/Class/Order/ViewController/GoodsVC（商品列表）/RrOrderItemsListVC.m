//
//  RrOrderItemsListVC.m
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderItemsListVC.h"
#import "RrOrderItemsListCell.h"
#import "RrOrderItemsListModel.h"
#import "RrOrderListDetailVC.h"
@interface RrOrderItemsListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) BOOL isHeadRefreshing; // 头部刷新
@end

@implementation RrOrderItemsListVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTabelView];
}

- (void)setModel:(OrderVCModel *)model{
    _model = model;
    self.tableView.width = self.view.width;
    [self.tableView.mj_header beginRefreshing];
}


- (void)addTabelView{
    self.pageNum = 1;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([RrOrderItemsListCell class]) cellIndentifier:KRrOrderItemsListCell_ID];
    
    @weakify(self)
    self.pageNum = 1;
    self.isHeadRefreshing = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        self.isHeadRefreshing = YES;
        [self postProductListUrl];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isHeadRefreshing = NO;
        [self postProductListUrl];
    }];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}


#pragma  mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 17)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 119;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RrOrderItemsListModel *model = self.listArr[indexPath.section];
    RrOrderItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderItemsListCell_ID forIndexPath:indexPath];
    [cell.lfteImageView sd_setImageWithURL:model.icon.url placeholderImage:KPlaceholderImage_product];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@  %@",model.name,model.productCode];
    cell.subTitleLabel.text = model.productAbstract;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RrOrderItemsListModel *model = self.listArr[indexPath.section];
    RrOrderListDetailVC *detailVc =[RrOrderListDetailVC new];
    detailVc.title = model.name;
    detailVc.productModel = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}


// MARK: 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无相关产品昵";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
        NSFontAttributeName:KFont19,
        NSForegroundColorAttributeName:[UIColor c_GrayNotfiColor],
        NSParagraphStyleAttributeName:paragraph
    };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
// 向上偏移量为表头视图高度/2
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -self.tableView.height/2.0+78;
}


#pragma mark UI
- (UITableView *)tableView{
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 51;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor mian_BgColor];
        [_tableView addLine_left];
        [_tableView addLine_right];
    }
    return _tableView;
}

#pragma mark - 网络 URL
- (void)postProductListUrl{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@(20) forKey:@"pageSize"];
    [parameter setValue:@(self.pageNum) forKey:@"pageNum"];
    [parameter setValue:@(1) forKey:@"status"]; // 产品状态：1：上架，0:下架
    [parameter setValue:self.model.ID forKey:@"categoryId"];//分类主键id
    [parameter setValue:KisAddEGOCache_value forKey:KisAddEGOCache_Key];
    
    @weakify(self)
    [[RRNetWorkingManager sharedSessionManager] postProductList:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self);
        if (!error) {

            if (self.isHeadRefreshing) {
                self.listArr = [NSMutableArray arrayWithArray:responseModel.list];
            }else{
                [self.listArr addObjectsFromArray:responseModel.list];
            }
            
            RrDataPageModel *pageModel =  responseModel.pageData;
            if ([pageModel.total integerValue] == self.listArr.count && self.listArr.count !=0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            if (responseModel.list.count >0) {
                      self.pageNum ++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.tableView reloadData];
            });
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }, [RrOrderItemsListModel class])];
}


@end
