//
//  UIButton+BMExtension.h
//  BMDeliverySpecialists
//
//  Created by Transuner on 16/5/10.
//  Copyright © 2016年 吴冰. All rights reserved.
//
#import <UIKit/UIKit.h>


typedef void(^TapButtonActionBlock) (UIButton *button) ;



@interface UIButton (BMExtension)

/**
 *  快速创建文字Button
 *
 *  @param frame           frame
 *  @param title           title
 *  @param backgroundColor 背景颜色
 *  @param titleColor      文字颜色
 *  @param tapAction       回调
 */
+ (instancetype)dd_buttonCustomButtonWithFrame:(CGRect)frame
                                         title:(NSString *)title
                               backgroundColor:(UIColor *)backgroundColor
                                    titleColor:(UIColor *)titleColor
                                     tapAction:(TapButtonActionBlock)tapAction;
/**
 *   快速创建图片Button
 *
 *  @param frame       frame
 *  @param imageString 按钮的背景图片
 *  @param tapAction   回调
 */
+ (instancetype)dd_buttonSystemButtonWithFrame:(CGRect)frame
                   NormalBackgroundImageString:(NSString *)imageString
                                     tapAction:(TapButtonActionBlock)tapAction;

/**
 *  快捷回调block  （添加按钮点击事件监听）
 *
 *  @param frame       frame
 *  @param tapAction   回调
 */
+ (instancetype)dd_buttonSystemButtonWithFrame:(CGRect)frame
                                     tapAction:(TapButtonActionBlock)tapAction;


//  创建普通按钮
+ (instancetype)dd_buttonCustomButtonWithFrame:(CGRect)frame
                                         title:(NSString *)title
                                     titleFont:(UIFont *)font
                                    titleColor:(UIColor *)titleColor
                                     tapAction:(TapButtonActionBlock)tapAction;

@end
