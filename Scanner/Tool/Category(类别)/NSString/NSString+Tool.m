//
//  NSString+Tool.m
//  Scanner
//
//  Created by rrdkf on 2020/6/20.
//  Copyright © 2020 Occipital. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

+ (NSString *)NA_UUIDString
{
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    NSString *UUIDString = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, UUID);
    CFRelease(UUID);
    // Remove '-' in UUID
    return [[[UUIDString componentsSeparatedByString:@"-"] componentsJoinedByString:@""] lowercaseString];
}
// 生成URL
- (NSURL *)url
{
    if ([self isEqualToString:@""]) {
        return nil;
    }
    
    BOOL hasPrefix = [self hasPrefix:@"http"];
    if (!hasPrefix) {
        NSString * host = RrDBaseUrl;
        if ([host hasSuffix:@"/"]) {
            host = [host substringToIndex:host.length - 1];
        }
        NSString * url = [self copy];
        if ([url hasPrefix:@"/"]) {
            url = [url substringFromIndex:1];
        }
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",host,url]];
    }
    return [NSURL URLWithString:self];
}
// 图片资源。添加固定服务器地址
- (NSString *)imageUrlStr{
    if ([self isEqualToString:@""]) {
         return nil;
     }
    BOOL hasPrefix = [self hasPrefix:@"http"];
    if (!hasPrefix) {
        NSString * host = QiNiuBaseUrl;
        if ([host hasSuffix:@"/"]) {
            host = [host substringToIndex:host.length - 1];
        }
        NSString * url = [self copy];
        if ([url hasPrefix:@"/"]) {
            url = [url substringFromIndex:1];
        }
        return [NSString stringWithFormat:@"%@/%@",host,url];
    }
    return self;
}

/**
// * 手机号码格式验证
// */
//+(BOOL)isMobile:(NSString *)phoneNum {
//
//    NSString *MOBILE = @"^(13[0-9]|14[5-9]|15[0-3,5-9]|16[2,5,6,7]|17[0-8]|18[0-9]|19[0-3,5-9])\\d{8}$";
//    NSPredicate *pred_mobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    return [pred_mobile evaluateWithObject:phoneNum];
//}

/**
 * 手机号码格式验证 -- 严格
 */
-(BOOL)isMobileNumber{
    
   NSString * telNum = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] != 11) {
        return NO;
    }
    
    /**
     * 中国移动：China Mobile
     *13[4-9],147,148,15[0-2,7-9],165,170[3,5,6],172,178,18[2-4,7-8],19[5,7,8]
     */
    NSString *CM_NUM = @"^((13[4-9])|(14[7-8])|(15[0-2,7-9])|(165)|(178)|(18[2-4,7-8])|(19[5,7,8]))\\d{8}|(170[3,5,6])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,146,155,156,166,167,170[4,7,8,9],171,175,176,185,186,196
     */
    NSString *CU_NUM = @"^((13[0-2])|(14[5,6])|(15[5-6])|(16[6-7])|(17[1,5,6])|(18[5,6])|(196))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149,153,162,170[0,1,2],173,174[0-5],177,180,181,189,19[0,1,3,9]
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(162)|(17[3,7])|(18[0,1,9])|(19[0,1,3,9]))\\d{8}|((170[0-2])|(174[0-5]))\\d{7}$";

    /**
     * 中国广电：China Broadcasting Network
     * 192
     */
    NSString *CBN_NUM = @"^((192))\\d{8}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    NSPredicate *pred_CBN = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CBN_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNum];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNum];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNum];
    BOOL isMatch_CBN = [pred_CBN evaluateWithObject:telNum];
    if (isMatch_CM || isMatch_CT || isMatch_CU || isMatch_CBN) {
        return YES;
    }
    
    return NO;
}


// 计算
- (CGSize)dd_stringCalculateSize:(CGSize)maxSize font:(UIFont *)font{
    __autoreleasing NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    return [self dd_stringCalculateSize:maxSize attributes:attributes];
}
-(CGSize)dd_stringCalculateSize:(CGSize)maxSize attributes:(NSDictionary *)attributes {
    if (self.length == 0 || [self isEqualToString:@""] ||self == nil) {
        return CGSizeZero;
    }
    CGSize size = [self boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                  attributes: attributes
                                     context:NULL].size;
    return size;
}


- (BOOL)checkPassWorld{
    return [self matchPattern:@"^[0-9A-Za-z]{6,100}$"];
}
- (BOOL)matchPattern:(NSString *)pattern {
    
    BOOL match = NO;
    NSRegularExpression *r = nil;
    @try {
        NSError *regError = nil;
        r = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:&regError];
        NSArray *mathes = [r matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        match = (mathes.count > 0);
    }
    @catch (NSException *e){
        match = NO;
    }
    return match;
}

#pragma marks 字母或数字
- (BOOL)numberOrLetterChangeformat
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [self isEqualToString:filtered];
    if(!basic){
        return NO;
    }else{
        return YES;
    }
}


+ (NSString *)BundlePath{
    NSString *bundle = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return bundle;
}

//判断是否有中文
-(BOOL)hasChinese{
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

@end
