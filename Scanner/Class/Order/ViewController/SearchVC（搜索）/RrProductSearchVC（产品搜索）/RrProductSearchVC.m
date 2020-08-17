//
//  RrProductSearchVC.m
//  Scanner
//
//  Created by edz on 2020/8/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrProductSearchVC.h"
#import "RrOrderItemsListCell.h"
#import "RrOrderItemsListModel.h"
#import "RrOrderListDetailVC.h"

@interface RrProductSearchVC ()

@end

@implementation RrProductSearchVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerNibString:NSStringFromClass([RrOrderItemsListCell class]) cellIndentifier:KRrOrderItemsListCell_ID];

}
#pragma mark - tableView delegeta
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

#pragma mark - 网络 URL
- (void)postHistoryRecordDataWithUrlKeyWord:(NSString *)keyWord{
    [super postHistoryRecordDataWithUrlKeyWord:keyWord];

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@(20) forKey:@"pageSize"];
    [parameter setValue:@(self.pageNum) forKey:@"pageNum"];
    [parameter setValue:keyWord forKey:@"name"];
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
                [self updateListData];
            });
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }, [RrOrderItemsListModel class])];
    
}


@end
