//
//  RrMineMessageVC.m
//  Scanner
//
//  Created by edz on 2020/8/7.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineMessageVC.h"
#import "RrMineMessageModel.h"
#import "CheckUserInfoVC.h"
#import "RrMineOrderListDetailVC.h"
#import "RrMineMessageCell.h"

@interface RrMineMessageVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) NSInteger pageNum; //分页
@property (nonatomic, assign) BOOL isHeadRefreshing; // 头部刷新
@property (nonatomic, strong)  NSMutableArray *notReadArray; //未读数据
@property (nonatomic, strong)  NSMutableArray *readArray;//已读数据
@property (nonatomic, strong)  NSMutableArray *dataArray;//未排序的数据model

@end

@implementation RrMineMessageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTabelView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addTabelView{
    @weakify(self)
    self.pageNum = 1;
    self.isHeadRefreshing = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        self.isHeadRefreshing = YES;
        [self getMessageURL];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isHeadRefreshing = NO;
        [self getMessageURL];
    }];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.listArr.count;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KCell_H+17;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RrMineMessageModel *model = self.listArr[indexPath.row];
    if ([model.msgStatus intValue] == 1000) {
        MZCommonCell *cell = [MZCommonCell blankClearCell];
        static  UILabel *titleLabel ;
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
            titleLabel.textColor = [UIColor c_GrayColor];
            titleLabel.font = KFont20;
            titleLabel.textAlignment = NSTextAlignmentRight;
            titleLabel.right = KFrameWidth - 17;
            titleLabel.bottom = KCell_H+17;
       
        }
        titleLabel.text = @"已读";
        [cell.contentView addSubview:titleLabel];
        return cell;
        
    }
    RrMineMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrMineMessageCell_ID];
    cell.mianLabel.text = model.content;
    cell.timeLabel.text = [model.createTime dateStringFromTimeYMDHMS];
    if([model.typeJson.type isEqualToString:@"AUDIT_SUCCESS"] ||
       [model.typeJson.type isEqualToString:@"ORDERS_DELIVERY"] ||
       [model.typeJson.type isEqualToString:@"ORDERS_THROUGH"]) {
        cell.imageViews.hidden = YES;
        cell.mianLabel_x.constant = 17;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RrMineMessageModel *model = self.listArr[indexPath.row];
    if ([model.msgStatus intValue] == 1000) {
        return;
    }
    if ([model.msgStatus intValue] == 0) {//0 未读 1 已读
        [typeJsonMdoel patchMessageUrlWithID:model.ID succeesBlock:^(BOOL succee) {
            if (succee) {
                self.pageNum = 1;
                self.isHeadRefreshing = YES;
                [self getMessageURL];
            }
        }];
    }
    
    
    
    if ([model.typeJson.type isEqualToString:@"AUDIT_SUCCESS"] ||
        [model.typeJson.type isEqualToString:@"AUDIT_FAIL"]) {// 关联代理商审核成功, //AUDIT_FAIL关联代理商审核失败
        CheckUserInfoVC *userVc =[CheckUserInfoVC new];
        userVc.title = @"个人资料";;
        [self.navigationController pushViewController:userVc animated:YES];
    }else if([model.typeJson.type isEqualToString:@"ORDERS_DELIVERY"] ||
             [model.typeJson.type isEqualToString:@"ORDERS_REJECTED"] ||
             [model.typeJson.type isEqualToString:@"ORDERS_THROUGH"]) {//订单发货 //ORDERS_REJECTED订单审核驳回 //ORDERS_THROUGH订单审核通过
        RrMineOrderListDetailVC *detailVc =[RrMineOrderListDetailVC new];
        detailVc.outTradeNo = model.typeJson.prod;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}


// MARK: 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无相关数据";
    
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



- (UITableView *)tableView{
    
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, (KFrameHeight-64)) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 73;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor mian_BgColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNibString:NSStringFromClass([RrMineMessageCell class]) cellIndentifier:KRrMineMessageCell_ID];

    }
    return _tableView;
}

#pragma mark - 网络url
- (void)getMessageURL{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@(self.pageNum) forKey:@"pageNum"];
    [parameter setValue:@(20) forKey:@"pageSize"];
    [parameter setValue:@(-1) forKey:@"status"];//消息状态 -1 所有 0 未读 1 已读
    
    @weakify(self)
    [[RRNetWorkingManager sharedSessionManager] getMessageList:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self);
        if (!error) {
            
            if (self.isHeadRefreshing) {
                self.dataArray = [NSMutableArray arrayWithArray:responseModel.list];
            }else{
                [self.dataArray addObjectsFromArray:responseModel.list];
            }
            
            RrDataPageModel *pageModel =  responseModel.pageData;
            if ([pageModel.total integerValue] == self.dataArray.count && self.dataArray.count !=0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            if (responseModel.list.count >0) {
                self.pageNum ++;
            }
            [self sortListArr]; //数据处理
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.tableView reloadData];
            });
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }, [RrMineMessageModel class])];
}


- (void)sortListArr{
    self.readArray = [NSMutableArray array];
    self.notReadArray = [NSMutableArray array];
    NSMutableArray *countArr = [self.dataArray mutableCopy];
    for (RrMineMessageModel *model in countArr) {
        if ([model.msgStatus intValue] == 0) {//未读
            [self.notReadArray addObject:model];
        }else{
            [self.readArray addObject:model];
        }
    }
    self.listArr = [NSMutableArray array];

    if (self.notReadArray.count >0) {
            [self.listArr addObjectsFromArray:self.notReadArray];

    }
   if (self.readArray.count >0) {
       RrMineMessageModel *model  =  [RrMineMessageModel new];
       model.msgStatus = @(1000); //已读 标题
       [self.listArr addObject:model];
       [self.listArr addObjectsFromArray:self.readArray];
    }

    
}


@end
