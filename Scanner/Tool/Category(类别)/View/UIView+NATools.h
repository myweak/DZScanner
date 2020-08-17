//
//  UIView+NATools.h
//  Scanner
//
//  Created by edz on 2020/7/8.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (NATools)

//切圆角
- (void)addCornerRadius:(CGFloat)radius;

// 单边 切圆角
- (void)bezierPathWithRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
