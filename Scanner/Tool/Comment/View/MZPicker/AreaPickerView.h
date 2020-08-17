//
//  MZPickerView.h
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/30.
//  Copyright © 2018年 Simple. All rights reserved.
//
#define  KFileNameAllAddress @"AllAdress"

#import <UIKit/UIKit.h>
#import "RrAddressModel.h"
typedef void (^ShowPickerViewRegionBlock)(RrAddressModel * provinceModel , RrAddressModel * cityMdoel , RrAddressModel * areaModel);

@interface AreaPickerView : UIView

@property (nonatomic, copy) ShowPickerViewRegionBlock showPickerViewRegionBlock;
// 更新地区
+ (void)updateArea;

+ (void)saveArrayToData:(NSArray *)array; // [@"areaName"] // areaCode
/*!
 @brief showPickerViewRegionBlock 选择地区回调
 */

- (instancetype) initWithShowPickerView:(ShowPickerViewRegionBlock)showPickerViewRegionBlock;

/*!
 @brief 显示选择器
 */
- (void) show;


@end
