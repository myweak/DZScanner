//
//  RrMineOrderListCell.h
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrMineOrderListCell_ID @"RrMineOrderListCell_ID"
#import <UIKit/UIKit.h>
#import "RrMineOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RrMineOrderListCellBlock)(BOOL onTapLeft, BOOL onTapRight) ;

@interface RrMineOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contenViewBg;
//订单编号
@property (weak, nonatomic) IBOutlet UILabel *outRradeNoLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTiemLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNamePhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *feeLabel;


@property (nonatomic, copy) RrMineOrderListCellBlock backBlock;
@property (nonatomic, strong) RrMineOrderListModel *model;

@end

NS_ASSUME_NONNULL_END
