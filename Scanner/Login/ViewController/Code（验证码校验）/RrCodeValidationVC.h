//
//  RrCodeValidationVC.h
//  Scanner
//
//  Created by edz on 2020/7/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RrCodeValidationVCType) { // 1 注册短信 2 忘记密码 3 登录验证码
    RrCodeValidationVC_forget =2,
    RrCodeValidationVC_codeLogin =3,
};

@interface RrCodeValidationVC : MainViewController
@property (nonatomic, copy)   NSString *phoneNum; // 手机号码必须要
@property (nonatomic, assign) RrCodeValidationVCType type; // 必须要
@end

NS_ASSUME_NONNULL_END
