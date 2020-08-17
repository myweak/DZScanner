//
//  RrOrderItemsListVC.h
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"
#import "OrderVCModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RrOrderItemsListVC : MainViewController
@property (nonatomic, strong) OrderVCModel *model;
@property (nonatomic, strong)  NSMutableArray *listArr;
@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
