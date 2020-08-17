//
//  UIView+Line.h
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/17.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^TapBlock)(CGPoint loc,UIGestureRecognizer *tapGesture);

@interface UIView (Line)
// 上
- (void)addLine_top;
// 下
- (void)addLine_bottom;
// 左
- (void)addLine_left;
// 右
- (void)addLine_right;

// 上
- (void)addLine_top:(UIColor *)color W:(CGFloat)W H:(CGFloat)H;
// 下
- (void)addLine_bottom:(UIColor *)color W:(CGFloat)W H:(CGFloat)H;
// 左
- (void)addLine_left:(UIColor *)color H:(CGFloat)H;
// 右
- (void)addLine_right:(UIColor *)color H:(CGFloat)H;

//画线
- (void)addLine:(CGRect)frame;
- (CALayer *)addLineWithFrame:(CGRect)frame color:(UIColor *)color;

// 添加1pt的边框
-(void)addLindeBorderWithColor:(UIColor *)color andRadius:(CGFloat)Radius;


// tap View -------------------------------------
- (void)handleTap:(TapBlock)tapBlock;

- (void)handleTap:(TapBlock)tapBlock delegate:(id)delegate;

- (void)handleLongTap:(TapBlock)tapBlock;

- (void)removeAllGestures;

@end
