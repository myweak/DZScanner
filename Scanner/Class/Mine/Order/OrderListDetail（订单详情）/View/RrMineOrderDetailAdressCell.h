//
//  RrMineOrderDetailAdressCell.h
//  Scanner
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define KRrMineOrderDetailAdressCell_ID @"RrMineOrderDetailAdressCell_ID"

typedef void(^RrMineOrderListCellBlock)(BOOL onTapLeft, BOOL onTapRight) ;

#import <UIKit/UIKit.h>
#import "RrDidProductDeTailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RrMineOrderDetailAdressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contenViewBg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomViewBg;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, copy) RrMineOrderListCellBlock backBlock;
@property (nonatomic, strong) RrDidProductDeTailModel *model;


/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(RrDidProductDeTailModel *);
- (void)startTime;//开始倒计时

@end

NS_ASSUME_NONNULL_END
