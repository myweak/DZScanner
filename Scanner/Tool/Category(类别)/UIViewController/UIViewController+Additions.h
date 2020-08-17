//
//  UIViewController+Additions.h
//  MiZi
//
//  Created by Simple on 2018/7/16.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)
- (void)addBackButton;
- (void)addBackNilButton;
- (void)addTheMeColorTitle:(NSString *)titileName;
- (void)backBarButtonPressed:(id)backBarButtonPressed; // 导航栏返回按钮 事件监听

-(void)addPsuhVCAnimationFromTop; // 添加从底部弹起动画 push

@property (nonatomic, assign) BOOL hidenLeftTaBar;// 隐藏左边的标签栏
//-(void)setHidenLeftTaBar:(BOOL)hidenLeftTaBar; // 隐藏左边的标签栏


+ (UIViewController *)visibleViewController;
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc;

- (UIButton *)buttonOfBackButtonIsBlack:(BOOL)isBlack;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions;

+ (void)showCusttomAlertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions;



@end
