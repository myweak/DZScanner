//
//  RrOrderItemsListCell.h
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define KRrOrderItemsListCell_ID @"RrOrderItemsListCell_ID"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrOrderItemsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentViewBg;
@property (weak, nonatomic) IBOutlet UIImageView *lfteImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel; // 默认隐藏
@property (weak, nonatomic) IBOutlet UILabel *moneyTitleLabel; //小计

@property (weak, nonatomic) IBOutlet UILabel *stautsLabel; // 默认隐藏

@end

NS_ASSUME_NONNULL_END
