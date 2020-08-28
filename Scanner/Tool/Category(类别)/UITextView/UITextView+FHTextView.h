//
//  UITextView+FHTextView.h
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (FHTextView)
@property (nonatomic,strong) UILabel *placeholderLabel;//占位符
@property (nonatomic,strong) UILabel *wordCountLabel;//计算字数

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic,strong) NSString *placeholder;//占位符
@property (copy, nonatomic) NSNumber *limitLength;//限制字数
- (UIColor *)defaultPlaceholderColor;

// 限制UITextView 小数位数为2位
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
