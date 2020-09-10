//
//  RrOrderRemarkCell.h
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrOrderRemarkCell_ID @"RrOrderRemarkCell_ID"
#import "RrDidProductDeTailModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrOrderRemarkCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLabel; //备注，标题

@property (nonatomic, strong) RrDidProductDeTailModel *postModel; //提交数据模型

@end

NS_ASSUME_NONNULL_END
