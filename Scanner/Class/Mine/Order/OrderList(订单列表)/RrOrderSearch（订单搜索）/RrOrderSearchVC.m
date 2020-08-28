//
//  RrOrderSearchVC.m
//  Scanner
//
//  Created by edz on 2020/8/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderSearchVC.h"
#import "RrMineOrderListCell.h"
#import "RrMineOrderListModel.h"
#import "RrMineOrderListDetailVC.h" // 订单详情
#import "RrMineOrderListDetailEdittingVC.h" //修改信息

@interface RrOrderSearchVC ()
@property (nonatomic, copy)   NSString *keyWord;
@end

@implementation RrOrderSearchVC

- (void)dealloc{
    self.tableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNibString:NSStringFromClass([RrMineOrderListCell class]) cellIndentifier:KRrMineOrderListCell_ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderListNotification:) name:KNotification_name_updateOrder_list object:nil];
    
    
}

- (void)updateOrderListNotification:(NSNotification *)notify{
    self.pageNum = 1;
    self.isHeadRefreshing =YES;
    [self postHistoryRecordDataWithUrlKeyWord:self.keyWord];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RrMineOrderListModel *model = self.listArr[indexPath.section];
    if (!model) {
        return 294;
    }
    switch ([model.orderStatus intValue]) {
        case 1:// 待完善
        case 3: //待付款
        case 6://制作完成
            return 294;
            
        default:
            return 294-77;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    RrMineOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrMineOrderListCell_ID forIndexPath:indexPath];
    RrMineOrderListModel *model = self.listArr[indexPath.section];
    cell.model = model;
    cell.backBlock = ^(BOOL onTapLeft, BOOL onTapRight) {
        @strongify(self)
        
        if (onTapLeft) {
            
            NSString *content = [NSString stringWithFormat:@"%@  %@",model.express,model.trackingNumber];
            if ([model.orderStatus intValue] == 6) {  //制作完成6
                [self AlertWithTitle:@"物流信息"  message:content andOthers:@[@"复制"] animated:YES action:^(NSInteger index) {
                    showMessage(@"复制成功!");
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = model.trackingNumber;
                }];
            }
            
        }else{
            
            if ([model.orderStatus intValue] == 1) { ////审核被驳回 修改信息
                RrMineOrderListDetailEdittingVC *editVc = [RrMineOrderListDetailEdittingVC new];
                editVc.outTradeNo = model.outTradeNo;
                [self.navigationController pushViewController:editVc animated:YES];
            }
            if ([model.orderStatus intValue] == 3) { //待付款
                if (onTapLeft) {
                    [self AlertWithTitle:@"温馨提示" message:@"是否取消该订单" andOthers:@[@"取消",@"确认"] animated:YES action:^(NSInteger index) {
                        if(index == 1){
                            [self changeOrderStatusUrlWithModel:model SelectOrderStatus:@(0)];
                        }
                    }];
                }else{
                    [self showPayNotifiWithModel:model];
                }
            }else if ([model.orderStatus intValue] == 6) {  //制作完成6
                [self AlertWithTitle:@"温馨提示" message:@"是否确认收货" andOthers:@[@"取消",@"确认"] animated:YES action:^(NSInteger index) {
                    if(index == 1){
                        [self changeOrderStatusUrlWithModel:model SelectOrderStatus:@(7)];
                    }
                }];
            }
            
        }
        
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RrMineOrderListModel *model = self.listArr[indexPath.section];
    RrMineOrderListDetailVC *detailVc = [RrMineOrderListDetailVC new];
    detailVc.outTradeNo = model.outTradeNo;
    [self.navigationController pushViewController:detailVc animated:YES];
}


#pragma mark --网络 Url
//付款提醒
- (void)showPayNotifiWithModel:(RrMineOrderListModel *)model{
    if (checkStrEmty(model.outTradeNo)) {
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] putOrderPayNotifi:@{@"outTradeNo":model.outTradeNo} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            showMessage(@"已发送付款提醒");
        }else{
            showMessage(responseModel.msg);
        }
        [SVProgressHUD dismiss];
    }, nil)];
    
}
/**
 orderStatus=0  取消订单
 orderStatus=2  完善测量数据
 orderStatus=7  确认收货
 */
- (void)changeOrderStatusUrlWithModel:(RrMineOrderListModel *)model SelectOrderStatus:(NSNumber *)orderStatus{
    @weakify(self)
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.outTradeNo forKey:@"outTradeNo"];
    [parameter setValue:orderStatus forKey:@"orderStatus"];
    [[RRNetWorkingManager sharedSessionManager] changeOrderStatus:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.tableView.mj_header beginRefreshing];
            });
        }
        [SVProgressHUD dismiss];
        showMessage(responseModel.msg);
    }, nil)];
    
}

- (void)postHistoryRecordDataWithUrlKeyWord:(NSString *)keyWord
{
    [super postHistoryRecordDataWithUrlKeyWord:keyWord];
    self.keyWord = keyWord;
    @weakify(self)
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@(self.pageNum) forKey:@"pageNum"];
    [parameter setValue:@(20) forKey:@"pageSize"];
    [parameter setValue:keyWord  forKey:@"keyWord"];
    //    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] postUserOrderList:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
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
                [self updateListData];
            });
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
    }, [RrMineOrderListModel class])];
}

@end
