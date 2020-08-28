//
//  RrEditeTitleVc.h
//  Scanner
//
//  Created by edz on 2020/7/13.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define KRrEditeTitleVc_MerchantsAccount_title   @"关联经销商"

typedef enum : NSUInteger {
    RrEditeTitleVcType_none = 0,
    RrEditeTitleVcType_patchInfo, // 提交用户信息
} RrEditeTitleVcType;
typedef void (^ComplementBlock)(NSString * title);

#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrEditeTitleVc : MainViewController
@property (nonatomic, copy)   ComplementBlock complementBlock;
@property (nonatomic, copy)   NSString *mainTitle;
@property (nonatomic, copy)   NSString *placeholderStr;
@property (nonatomic, assign) RrEditeTitleVcType type;
@property (nonatomic, copy)   NSString *parameterKey; // 提交用户信息 修改的 key
@end

NS_ASSUME_NONNULL_END
