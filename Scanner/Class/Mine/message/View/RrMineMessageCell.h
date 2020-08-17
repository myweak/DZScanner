//
//  RrMineMessageCell.h
//  Scanner
//
//  Created by edz on 2020/8/12.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrMineMessageCell_ID  @"RrMineMessageCellID"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrMineMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *mianLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianLabel_x;

@end

NS_ASSUME_NONNULL_END
