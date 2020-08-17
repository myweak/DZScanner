//
//  RrOrderPayTypeCell.h
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrOrderPayTypeCell_ID  @"RrOrderPayTypeCell_ID"
#import <UIKit/UIKit.h>
#import "RrDidProductDeTailModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^RrOrderPayTypeBlock)(UIButton* actionBtn);

@interface RrOrderPayTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contenViewBg;

@property (weak, nonatomic) IBOutlet UIButton *onLinePayLBtn;
@property (weak, nonatomic) IBOutlet UIButton *offLinePayBtn;
@property (nonatomic, strong) RrDidProductDeTailModel *postModel; //提交数据模型
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtn_bottom;

@property (nonatomic, strong) RrOrderPayTypeBlock  tapPayTypeBlock;

@property (nonatomic, strong) BackBlock  onTapPayTypeBlock;

- (void)changeBtnTypeWithBtn:(UIButton *) sender;
@end

NS_ASSUME_NONNULL_END
