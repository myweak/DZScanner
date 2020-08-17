//
//  RrPostOrderListDetailVC.h
//  Scanner
//
//  Created by edz on 2020/7/17.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"
#import "RrOrderItemsListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RrPostOrderListDetailVC : MainViewController
@property (nonatomic, strong) RrOrderItemsListModel *productModel;
@end

NS_ASSUME_NONNULL_END
