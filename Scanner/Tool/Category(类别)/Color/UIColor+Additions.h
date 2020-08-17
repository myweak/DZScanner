//
//  UIColor+Additions.h
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iToast.h"

static inline void showMessage(NSString *msgString){
   [iToast showCenter_ToastWithText:msgString];
};

static inline void showTopMessage(NSString *msgString){
   [iToast showTop_ToastWithText:msgString];
};


NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Additions)

// 蒙版透明背景灰色
+(instancetype)c_alpha_bgWhiteColor;

+ (instancetype)c_mainBackColor; // 主文字黑

+ (instancetype)c_ThemeColor;
+ (instancetype)mian_BgColor;

+ (instancetype)c_iconNorColor;
+ (instancetype)c_iconSelectColor;

+ (instancetype)c_GreenColor;  //绿色

+ (instancetype)c_lineColor; // 灰色线
+ (instancetype)c_BgGrayColor; // 背景灰
+ (instancetype)c_GrayColor; //文字灰
+ (instancetype)c_GrayNotfiColor; // 文字提醒灰

+ (instancetype)c_redColor; // 文字红

+ (instancetype)c_mianblackColor; // cell 左边主标题 黑色

+ (instancetype)c_btn_Bg_Color; // 按钮背景色号  金额 颜色
@end

NS_ASSUME_NONNULL_END
