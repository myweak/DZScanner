//
//  DatepickerView.h
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/31.
//  Copyright © 2018年 Simple. All rights reserved.
//


#import <UIKit/UIKit.h>

/// 回调

typedef void(^DatePickerBlock)(NSString *date);

/// 时间选择器

@interface DatepickerView : UIView

//根据格式选择时间
- (id)initWithDateMode:(UIDatePickerMode)dateMode block:(DatePickerBlock) datePickerBlock;
@property ( nonatomic , assign) UIDatePickerMode dateMode;
//-----

//@property (nonatomic, assign) BOOL isDate;

///
@property (nonatomic, strong) NSString *minTime;
@property (nonatomic, strong) NSString *maxTime;


/// 回调
@property (nonatomic, strong) DatePickerBlock datePickerBlock;
//  点击背景取消 ： 默认取消--yes    YES：不取消
@property (nonatomic, assign) BOOL         isTap;

/// 显示
-(void) show;

@end
