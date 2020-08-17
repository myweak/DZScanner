//
//  RrChangeWordVC.h
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrChangeWordVC : MainViewController
@property (nonatomic, copy)   NSString *phoneNum; // 手机号码必须要
@property (nonatomic, copy)   NSString *phoneCode; // 验证码必须要

@end

NS_ASSUME_NONNULL_END
