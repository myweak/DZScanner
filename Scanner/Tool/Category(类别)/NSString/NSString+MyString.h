//
//  NSString+MyString.h
//  KinHop
//
//  Created by weibin on 14/11/25.
//  Copyright (c) 2014年 cwb. All rights reserved.
//

#import <Foundation/Foundation.h>
// 空字符串 解决方案
static inline BOOL checkStrEmty(NSString *string){
    if (string == nil || ![string isKindOfClass:[NSString class]] || [string containsString:@"null"])
        return YES;
    else{
        NSString *target = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (target.length > 0) {
            return NO;
        }else
            return YES;
    }
}

// 时间格式化
static inline NSString *NAStringFromDate(NSString *dateFormat, NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}


@interface NSString (MyString)

+ (NSString *)MD5WithString:(NSString *)string;

+ (NSString *)stringBySpaceTrim:(NSString *)string;
//替换@为#
- (NSString *)replacingAtWithOctothorpe;
- (NSString *)replacingOctothorpeWithAt;
- (NSString *)replacingEnterWithNull;

//将\\转成空格
- (NSString *)replacingWithNull;
- (NSString *)replacingAddWithNull;

+ (BOOL)containsChinese:(NSString *)string;
+ (NSString*)stringByNull:(NSString*)string;
+ (BOOL)isNull:(NSString *)string;
+ (BOOL)isEmptyAfterSpaceTrim:(NSString *)string;

- (BOOL)isBlank;

+ (BOOL)isPureInt:(NSString*)string;////判断是否为整形：

+ (BOOL)isPureFloat:(NSString*)string;//判断浮点型

//手机号添加空格
+ (NSString *)addBlank:(NSString *)phone;

+ (NSString *)addBlankWithStr:(NSString *)str;

//浮点型数据不四舍五入
+(NSString *)notRounding:(double)price afterPoint:(int)position;

- (NSString *)replacingPWithNull;

- (NSString *)stringByAppendingString:(NSString *)string width:(float)width height:(float)height;

//获取设备MAC地址
+ (NSString *)getMacAddress;

+(NSString *)cardSecurityString:(NSString *)string andFirstShowIndex:(NSInteger)index;

// 字符串隐藏最后count位数据
+(NSString *)showSecurityString:(NSString *)string andSurplusCount:(int)count;

// 判断密码正确性，8位，非纯数字
+ (BOOL)JudgePasswordCorrect:(NSString *)Password;

// 提现金额判断 0-9，小数点
+ (BOOL)JudgeWithdawalMoney:(NSString *)Money;

// 交易密码 6位，非纯数
+ (BOOL)JudgePayPasswordCorrect:(NSString *)Password;

// 手机验证
+ (BOOL)checkPhoneNumInput:(NSString *)Phone;

#pragma marks 字母或数字
+(BOOL)numberOrLetterChangeformat:(NSString *)string;

//格式化金额  三位一个逗号
+(NSString*)strmethodComma:(NSString*)string;

+(NSString *)countNumAndChangeformat:(NSString *)num;

// 每3位插入空格
+ (NSString *)insertBlankAndChangeformat:(NSString *)num;

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;


//+ (void)isBindBankCard:(UIView *)view;

//格式化转入转出说明的文本格式
+(NSMutableAttributedString *)ExplainTextForMatByLimit:(NSString *)StringLimit AndnNote:(NSString *)StringNote;

+(float) heightForString:(UITextView *)textView andWidth:(float)width;

+ (NSString*)jsonStringOfObj:(NSDictionary*)dic;

//拉伸图片
+(UIImage *)stretchImageWithUIImage:(UIImage *)image;

+ (BOOL)UnlockPasswordOpen;

-(NSString *)convertToDecimalStyle;

- (NSString*)URLDecodedString;

//获取设备型号
+ (NSString *)getMacModel;

+ (NSString *)reviseString:(NSString *)string;

// 2个字符串10进制 异或 pan 源字符串
+ (NSString *)pin10Xor:(NSString *)pan withPinv:(NSString *)pinv;

// 2个字符串异或 pan 源字符串
+ (NSString *)pinXor:(NSString *)pan withPinv:(NSString *)pinv;

+ (int)charToint:(char)tempChar;

- (NSString *)tokenString;
/** 卖座的token */
- (NSString *)mzToken;
/** utf-8编码 */
- (NSString *)utf8String;

//验证email
-(BOOL)isValidateEmail;

/**
 大数字缩写（@"34503" -> @"3.4万"）
 */
- (NSString *)getLargeNumbersAbbreviation;

- (UIColor *)getColor;
- (UIColor *)getColorWithAlpha:(CGFloat)alpha;
// 判断金额是否有效
- (BOOL)checkMoneyIsValidCurrency;
//金额输入格式判断
-(BOOL)inputShouldNumberText;

+(NSString *)NA_UUIDString;

//app版本格式化 1.0--》100
- (NSString *)appVersionNumberFormat;

//手机号码格式化 135*****324
- (NSString *)phoneNumberFormat;
//仅包含数字
- (BOOL)containsOnlyNumbers;

// 时间戳 ---> 2020-3-4 16:05:05
- (NSString *)dateStringFromTimeYMDHMS;


// 移除所有空格、换行字符 用于从通讯录拷贝电话登录带有特殊的字符
- (NSString *)stringWithoutSpaceAndEnter;

//根据文件名获取大小
- (float)getFolderNameOfSize;
//根据文件名清除 文件
- (void)clearFolderNameAtCache;

@end
