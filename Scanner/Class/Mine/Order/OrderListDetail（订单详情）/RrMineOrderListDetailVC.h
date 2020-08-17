//
//  RrMineOrderListDetailVC.h
//  Scanner
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"
typedef void(^ChangePayTypeBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface RrMineOrderListDetailVC : MainViewController
@property (nonatomic, copy)   NSString *outTradeNo; // 订单号

@end

NS_ASSUME_NONNULL_END
