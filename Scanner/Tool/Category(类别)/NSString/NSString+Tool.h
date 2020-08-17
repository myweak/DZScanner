//
//  NSString+Tool.h
//  Scanner
//
//  Created by rrdkf on 2020/6/20.
//  Copyright © 2020 Occipital. All rights reserved.
//



#import <Foundation/Foundation.h>

static inline BOOL checkStringIsEmty(NSString * _Nullable string){
    if (string == nil || [string isEqual:[NSNull null]] || ![string isKindOfClass:[NSString class]] || [string containsString:@"null"]) {
        return YES;
    } else {
        NSString *target = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (target.length > 0) {
            return NO;
        } else {
            return YES;
        }
    }
}
NS_ASSUME_NONNULL_BEGIN

@interface NSString (Tool)
+ (instancetype)NA_UUIDString;


// 正则判断手机号码地址格式
- (BOOL)isMobileNumber;
// 生成URL
- (NSURL *)url;

// 图片资源。添加固定服务器地址
- (NSURL *)imageUrlStr;

// 计算
- (CGSize)dd_stringCalculateSize:(CGSize)maxSize font:(UIFont *)font;

//获取 Bundle 路径
+ (NSString *)BundlePath;

// 检查密码 6 -20位字母加数字组成
- (BOOL)checkPassWorld;
#pragma marks 字母或数字
- (BOOL)numberOrLetterChangeformat;
//判断是否有中文
-(BOOL)hasChinese;
@end

NS_ASSUME_NONNULL_END
