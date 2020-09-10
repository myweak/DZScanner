//
//  RrOrderSearchVC.h
//  Scanner
//
//  Created by edz on 2020/8/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrSearchViewController.h"
#import "RrMineOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrOrderSearchVC : RrSearchViewController
@property (nonatomic, copy) void(^showPayNotifiBlock)(RrMineOrderListModel *);//付款提醒

@end

NS_ASSUME_NONNULL_END
