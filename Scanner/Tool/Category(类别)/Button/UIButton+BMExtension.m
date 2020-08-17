//
//  UIButton+BMExtension.m
//  BMDeliverySpecialists
//
//  Created by Transuner on 16/5/10.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "UIButton+BMExtension.h"


#pragma mark 内部类 BMExButton
@interface BMExButton : UIButton
@property (copy, nonatomic) TapButtonActionBlock action;
@end


@implementation BMExButton

- (instancetype)init
{
    if(self = [super init])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)btnClick:(UIButton *)button
{
    if(self.action)
    {
        self.action(self);
    }
}
@end




@implementation UIButton (BMExtension)


//  创建普通按钮
+ (instancetype)dd_buttonCustomButtonWithFrame:(CGRect)frame
                                         title:(NSString *)title
                               backgroundColor:(UIColor *)backgroundColor
                                    titleColor:(UIColor *)titleColor
                                     tapAction:(TapButtonActionBlock)tapAction
{
    BMExButton *btn = [BMExButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
}

//  创建图片按钮
+ (instancetype)dd_buttonSystemButtonWithFrame:(CGRect)frame
                   NormalBackgroundImageString:(NSString *)imageString
                                     tapAction:(TapButtonActionBlock)tapAction
{
    BMExButton *btn = [BMExButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (imageString.length >0) {
        [btn setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    }
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
}
+ (instancetype)dd_buttonSystemButtonWithFrame:(CGRect)frame
                                     tapAction:(TapButtonActionBlock)tapAction{
    BMExButton *btn = [BMExButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.action = tapAction;
    return btn;
}

//  创建普通按钮
+ (instancetype)dd_buttonCustomButtonWithFrame:(CGRect)frame
                                         title:(NSString *)title
                                     titleFont:(UIFont *)font
                                    titleColor:(UIColor *)titleColor
                                     tapAction:(TapButtonActionBlock)tapAction
{
    BMExButton *btn = [BMExButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
}

@end
