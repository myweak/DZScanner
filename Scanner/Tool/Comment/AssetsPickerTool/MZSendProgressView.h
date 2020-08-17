//
//  AHSendProgressView.h
//  MiZi
//
//  Created by Nathan Ou on 2017/8/17.
//  Copyright © 2017年 Nathan Ou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZSendProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UILabel *bottomTipLabel;

@property (nonatomic, assign) CGFloat totalProgress;

+ (MZSendProgressView *)showProgressView;

- (void)dismiss;

- (void)dismissWithCompletion:(void(^)(void))block;

@end
