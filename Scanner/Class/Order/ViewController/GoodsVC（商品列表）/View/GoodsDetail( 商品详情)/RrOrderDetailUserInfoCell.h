//
//  RrOrderDetailUserInfoCell.h
//  Scanner
//
//  Created by edz on 2020/7/17.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrOrderDetailUserInfoCell_ID @"RrOrderDetailUserInfoCell_ID"
#import <UIKit/UIKit.h>
#import "RrDidProductDeTailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RrOrderDetailUserInfoCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIView *addressViewBg;

@property (nonatomic, strong) RrDidProductDeTailModel *postModel; //提交数据模型

@end

NS_ASSUME_NONNULL_END
