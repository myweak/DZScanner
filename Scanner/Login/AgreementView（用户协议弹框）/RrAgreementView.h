//
//  RrAgreementView.h
//  Scanner
//
//  Created by edz on 2020/8/5.
//  Copyright © 2020 rrdkf. All rights reserved.
//
typedef enum : NSUInteger {
    RrAgreementViewType_privacy  = 0, //隐私政策
    RrAgreementViewType_out, // 隐私保护提示
} RrAgreementViewType;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrAgreementView : UIView
@property (nonatomic, assign) RrAgreementViewType type;
+ (void)showAgreementView;
@end

NS_ASSUME_NONNULL_END
