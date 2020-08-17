//
//  MZShowAlertView.h
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/19.
//  Copyright © 2018年 Simple. All rights reserved.
//

typedef void (^CancelButtonBlock)(void);
typedef void (^alertButtonBlock)(NSString *text);
typedef void (^ButtonActonBlock)(NSInteger buttonIndex);
typedef BOOL (^MZShowAlertViewActonBlock)(NSInteger buttonIndex);

#import <UIKit/UIKit.h>

@interface MZShowAlertView : UIView
@property (nonatomic, copy) alertButtonBlock alertBlock;
@property (nonatomic, copy) ButtonActonBlock buttonActonBlock;
@property (nonatomic, copy) CancelButtonBlock cancelButtonBlock;
@property (nonatomic, copy) MZShowAlertViewActonBlock  ShowAlertViewActonBlock;
@property (nonatomic ,strong) UILabel  * contentLabel;    // 内容


/**
 *  点击背景消失； 默认NO：不消失
 */
@property (nonatomic, assign) BOOL tapEnadle;

/*!
 @brief     初始化视图  - 常规弹窗
 
 @param     title       标题
 @param     content     内容
 @param     buttonArrays 确定按钮数组
 @param     alertButtonBlock  点击回调事件
 */
- (instancetype) initWithAlerTitle:(NSString *)title
                           Content:(NSString *)content
                       buttonArray:(NSArray *)buttonArrays
                   blueButtonIndex:(NSInteger) buttonIndex
                  alertButtonBlock:(ButtonActonBlock)alertButtonBlock;

- (instancetype) initWithAddViewAlerTitle:(NSString *)title
                              ContentView:(UIView *)contentView
                              buttonArray:(NSArray *)buttonArrays
                          blueButtonIndex:(NSInteger) buttonIndex
                         alertButtonBlock:(ButtonActonBlock)alertButtonBlock;


/*!
 @brief     初始化视图  - 图片弹窗
 
 @param     imageStr      展示图片
 @param     alertButtonBlock  点击回调事件
 */
- (instancetype) initWithAlerImageStr:(NSString *)imageStr
                     alertButtonBlock:(ButtonActonBlock)alertButtonBlock;

/*!
 @brief     初始化视图  - 常规内容textView滚动弹窗
 
 @param     title       标题
 @param     content     textView内容
 */
- (instancetype) initWithAlerTitle:(NSString *)title
                           Content:(NSString *)content;
/*!
 @brief 显示弹窗
 */
- (void) show;
/*!
 @brief 消失弹框
 */
- (void) disMiss;


@end
