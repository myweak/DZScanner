//
//  RrOrderListDetailVC.h
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"
#import "RrOrderItemsListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RrOrderListDetailVCType_nomal = 0, // 下单
    RrOrderListDetailVCType_show, // 查看详情
} RrOrderListDetailVCType;

@interface RrOrderListDetailVC : MainViewController
@property (nonatomic, strong) RrOrderItemsListModel *productModel;
@property (nonatomic, assign) RrOrderListDetailVCType type;
@end

NS_ASSUME_NONNULL_END
