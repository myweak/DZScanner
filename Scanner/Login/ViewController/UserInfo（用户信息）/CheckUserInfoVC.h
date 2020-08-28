//
//  CheckUserInfoVC.h
//  Scanner
//
//  Created by edz on 2020/7/9.
//  Copyright © 2020 rrdkf. All rights reserved.
//


typedef NS_ENUM(NSInteger,CheckUserInfoVCType) {
    CheckUserInfoVCType_check = 0, //审核中
    CheckUserInfoVCType_unCheck , // 审核驳回
    CheckUserInfoVCType_mine,  // 我的界面进入。显示个人资料
    CheckUserInfoVCType_push, //推送
};

#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckUserInfoVC : MainViewController

@property (nonatomic, assign) CheckUserInfoVCType type; // 由外部type确定 改变UI 布局

@end

NS_ASSUME_NONNULL_END
