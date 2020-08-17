//
//  UILabel+Additions.h
//  AntHouse
//
//  Created by 飞礼科技 on 2017/12/25.
//  Copyright © 2017年 Nathan Ou. All rights reserved.
//
typedef void (^LabelTapActonBlock)(NSInteger index);

#import <UIKit/UIKit.h>

@interface UILabel (Additions)
/**
 *  字间距
 */
@property (nonatomic,assign)CGFloat characterSpace;

/**
 *  行间距
 */
@property (nonatomic,assign)CGFloat lineSpace;
/**
 *  段落后面的间距
 */
@property (nonatomic,assign)CGFloat paragraphSpacing;
/**
 *  行数限制
 */
@property (nonatomic,assign)NSInteger KNumberLine;

/**
 行首缩进 headSpace 字符数
 */
@property (nonatomic,assign)NSInteger headSpace;


/**
 *  关键字
 */
@property (nonatomic,copy)NSString *keywords;
@property (nonatomic,strong)UIFont *keywordsFont;
@property (nonatomic,strong)UIColor *keywordsColor;
//
@property (nonatomic,strong)NSArray *keywords_arr;
@property (nonatomic,strong)NSArray *keywordsFont_arr;
@property (nonatomic,strong)NSArray *keywordsColor_arr;
/**
 *  下划线
 */
@property (nonatomic,copy)NSString *underlineStr;
@property (nonatomic,strong)UIColor *underlineColor;

/**
 *  计算label宽高，必须调用
 *
 *  @param maxWidth 最大宽度
 *
 *  @return label的rect
 */
- (CGRect)getLableHeightWithMaxWidth:(CGFloat)maxWidth;

/** 更新设置 */
- (void)reloadUIConfig;

/** 根据宽度左右对齐 */
- (void)changeAligLeftAndRight;

/**
 *  设置label富文本
 *
 *  @param string label文本
 *
 * @param fontRange label字体range
 
 *  @param color label颜色
 *
 * @param colorRange label字体color
 */
- (void)setAttributedString:(NSString *)string font:(UIFont *)font fontRange:(NSRange)fontRange color:(UIColor *)color colorRange:(NSRange)colorRange;
- (void)setAttributedString:(NSString *)string lineSpacing:(NSInteger)lineSpacing font:(UIFont *)font fontRange:(NSRange)fontRange color:(UIColor *)color colorRange:(NSRange)colorRange;
@end
