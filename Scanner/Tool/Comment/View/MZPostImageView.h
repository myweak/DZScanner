//
//  MZPostImageView.h
//  MiZi
//
//  Created by Nathan Ou on 2018/8/7.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZPostImageView : UIView

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void(^deleteButtonActionBlock)(UIImageView *imageView);


@end
