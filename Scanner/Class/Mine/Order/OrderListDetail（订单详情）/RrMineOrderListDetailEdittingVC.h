//
//  RrMineOrderListDetailEdittingVC.h
//  Scanner
//
//  Created by edz on 2020/7/31.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"
#import "RrDidProductDeTailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RrMineOrderListDetailEdittingVC : MainViewController
@property (nonatomic, strong) RrDidProductDeTailModel *model;
@property (nonatomic, copy)   NSString *outTradeNo; // 订单号。没有 model 数据 就传订单号 去查询

@end

NS_ASSUME_NONNULL_END
