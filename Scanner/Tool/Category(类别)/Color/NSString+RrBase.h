//
//  NSString+RrBase.h
//  Scanner
//
//  Created by rrdkf on 2020/6/29.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RrBase)

// 字符串转base64（加密）
- (NSString *)base64String;

// base64转字符串（解密）
- (NSString *)textFromBase64String;

@end

NS_ASSUME_NONNULL_END
