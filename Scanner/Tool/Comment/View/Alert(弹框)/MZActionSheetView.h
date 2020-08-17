//
//  AHActionSheetView.h
//  MiZi
//
//  Created by 飞礼科技 on 2018/3/14.
//  Copyright © 2018年 Nathan Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CompleteBlock)(NSInteger selectIndex);

@interface MZActionSheetView : UIView
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, strong) NSArray  *listArray;
@property (nonatomic, strong) UILabel  *titleLabel;

//
-(instancetype) initWithActionSheetWithTitle:(NSString *)title
                                   ListArray:(NSArray *)listArray
                          completeSelctBlock:(CompleteBlock) completeBlock;

/**
 标识选中状态 注意：设置 selectIndex 初始值为 小于0

 @param selectIndex  坐标从0 开始
 */
-(void)didSelectRowAtIndex:(NSInteger)selectIndex;
-(void)show;
-(void)disMiss;
/**
 *  点击背景消失； 默认YES：消失
 */
@property (nonatomic, assign) BOOL tapEnadle;

@end
