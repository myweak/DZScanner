//
//  NSString+MyString.m
//  KinHop
//
//  Created by weibin on 14/11/25.
//  Copyright (c) 2014年 cwb. All rights reserved.
//

#import "NSString+MyString.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "sys/utsname.h"

@implementation NSString (MyString)

//去空格
+ (NSString *)stringBySpaceTrim:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)replacingAtWithOctothorpe
{
    return [self stringByReplacingOccurrencesOfString:@"@" withString:@"#"];
}

- (NSString *)replacingOctothorpeWithAt
{
    return [self stringByReplacingOccurrencesOfString:@"#" withString:@"@"];
}

//将回车转成空格
- (NSString *)replacingEnterWithNull
{
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

//将/p转成空格
- (NSString *)replacingPWithNull
{
//    if([temp isEqualToString:@"<p>"] || [temp isEqualToString:@"\n"] || [temp isEqualToString:@"\t"] || [temp isEqualToString:@"<strong>"] || [temp isEqualToString:@"<br //>"] || [temp isEqualToString:@"<//strong>"])

        return [self stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
}

//将\\转成空格
- (NSString *)replacingWithNull
{
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@""];
}

//将加号转成空格
- (NSString *)replacingAddWithNull
{
    return [self stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
}

//是否包含汉字
+ (BOOL)containsChinese:(NSString *)string
{
    for (int i = 0; i < [string length]; i++) {
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    
    return NO;
}

//回车转@""
+ (NSString*)stringByEnter:(NSString*)string
{
    for (int i = 0; i < [string length]; i++) {
        int a = [string characterAtIndex:i];
        if (a == 0x0d) {
            a = 0x20;
        }
    }
    return string;
}

//null转@""
+ (NSString*)stringByNull:(NSString*)string
{
    if (!string) {
        return @"";
    }
    return string;
}

//null或者@""都返回yes
+ (BOOL)isNull:(NSString *)string
{
    if (!string || [string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

-(BOOL)isBlank
{
    if([[self stringByStrippingWhitespace] length] == 0)
    {
        return YES;
    }
    
    return NO;
}

-(NSString *)stringByStrippingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
/*
 nil,<null>,NULL,@"",@"<null>",
 */


//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isEmptyAfterSpaceTrim:(NSString *)string
{
    NSString *str = [self stringBySpaceTrim:string];
    if (str.length == 0) {
        return YES;
    } else {
        return NO;
    }
}

//手机号添加空格
+ (NSString *)addBlank:(NSString *)phone
{
    //去掉-
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSMutableString *string = [NSMutableString string];
    for (int i = 0;i< phone.length; i++) {
        if (i == 2 ||i== 6) {
            [string appendString:[NSString stringWithFormat:@"%@ ",[phone substringWithRange:NSMakeRange(i, 1)]]];
        }else{
            [string appendString:[phone substringWithRange:NSMakeRange(i, 1)]];
            
        }
        
    }
    return string;
}

//添加空格
+ (NSString *)addBlankWithStr:(NSString *)str
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0;i< str.length; i++)
    {
        [string appendString:[NSString stringWithFormat:@"%@ ",[str substringWithRange:NSMakeRange(i, 1)]]];
    }
    return string;
}

//浮点型数据不四舍五入
+(NSString *)notRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = nil;
    NSDecimalNumber *roundedOunces = nil;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%.2f",[roundedOunces doubleValue]];
}

//转化成货币形式￥34,560.53
-(NSString *)convertToCurrencyStyle
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    
    currencyFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    [currencyFormatter setCurrencySymbol:@"￥"];
    [currencyFormatter setNegativeFormat:@"¤-#,##0.00"];
    
    NSString *string = [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.doubleValue]];
    
    return string;
}

//转化成标准数字形式 3位一个","
-(NSString *)convertToDecimalStyle
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *myString = (NSMutableString *)[currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.doubleValue]];
    return myString;
}

- (NSString *)stringByAppendingString:(NSString *)string width:(float)width height:(float)height
{
       width = ceil(width * 3);
         height = ceil(height * 3);
    string = [NSString stringWithFormat:@"%@?%.0fX%.0f",string,width,height];
    
    return string;
}

+ (NSString *)MD5WithString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//获取设备MAC地址
+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        free(msgBuffer);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

// 隐藏index开始到剩余4位的地方
+(NSString *)cardSecurityString:(NSString *)string andFirstShowIndex:(NSInteger)index
{
    NSInteger Stringlenth = (NSInteger)string.length;
    if (Stringlenth < 5 || Stringlenth < index + 4)
    {
        return string;
    }
    NSString *StringFirst = [string substringToIndex:index];
    NSString *StringLaster = [string substringFromIndex:Stringlenth - 4];
    NSInteger count = Stringlenth - index - 4;
    for (NSInteger i = 0; i< count; i++)
    {
        StringFirst = [StringFirst stringByAppendingString:@"*"];
    }
    StringFirst = [StringFirst stringByAppendingString:StringLaster];
    
    return StringFirst;
}

+(NSString *)showSecurityString:(NSString *)string andSurplusCount:(int)count
{
    int Stringlenth = (int)string.length;
    if (Stringlenth <= count)
    {
        return string;
    }
    NSString *StringFirst = [string substringToIndex:Stringlenth-count];
    for (int i = 0; i<count; i++)
    {
        StringFirst = [StringFirst stringByAppendingString:@"*"];
    }
    return StringFirst;
}

+ (BOOL)JudgePasswordCorrect:(NSString *)Password
{
    // (?=^.{8,}$)(?=.*\d)(?=.*\W+)(?=.*[A-Z])(?=.*[a-z])(?!.*\n).*$
    // ^(?![0-9]+$)[a-zA-Z0-9_~!@#$%\^&*]{6,16}$
    // ^(?![0-9]+$)[a-zA-Z0-9_~!@#$%\\^&*]{6,16}$
//    NSString *regex = @"^(?![0-9]+$)[a-zA-Z0-9_~!@#$%\\^&*]{6,16}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if ([pred evaluateWithObject:Password])
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
     return YES;
}

+ (BOOL)JudgePayPasswordCorrect:(NSString *)Password
{
    NSString *regex = @"^\\d{6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:Password])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    return YES;
}

+ (BOOL)JudgeWithdawalMoney:(NSString *)Money
{
    //
    NSString *regex = @"^\\d+(\\.\\d{0,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:Money])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)UnlockPasswordOpen
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *result = [userDefaults objectForKey:@"IfOpenUnlockPassword"];
    if (result == nil || [result intValue] == 0)
    {
        return NO;
    }
    else if([result intValue] == 1)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)checkPhoneNumInput:(NSString *)Phone;
{
    if (Phone.length < 5)
    {
        return NO;
    }
    
    NSString * StringPhone = @"^1([0-9])\\d{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", StringPhone];
    BOOL res1 = [regextestmobile evaluateWithObject:Phone];
    
    if (res1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

//格式化金额  三位一个逗号
+(NSString*)strmethodComma:(NSString*)string
{
    NSString *sign = nil;
    if ([string hasPrefix:@"-"]||[string hasPrefix:@"+"]) {
        sign = [string substringToIndex:1];
        string = [string substringFromIndex:1];
    }
    
    NSString *pointLast = [string substringFromIndex:[string length]-3];
    NSString *pointFront = [string substringToIndex:[string length]-3];
    
    int commaNum = (int)([pointFront length]-1)/3;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < commaNum+1; i++) {
        int index = (int)[pointFront length] - (i+1)*3;
        int leng = 3;
        if(index < 0)
        {
            leng = 3+index;
            index = 0;
            
        }
        NSRange range = {index,leng};
        NSString *stq = [pointFront substringWithRange:range];
        [arr addObject:stq];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    
    for (int i = (int)[arr count]-1; i>=0; i--) {
        [arr2 addObject:arr[i]];
    }
    
    NSString *commaString = [[arr2 componentsJoinedByString:@","] stringByAppendingString:pointLast];
    if (sign) {
        commaString = [sign stringByAppendingString:commaString];
    }
    return commaString;
}

// 每3位插入逗号
+ (NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

// 每3位插入空格
+ (NSString *)insertBlankAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    
    while (count > 4)
    {
        NSRange rang;
        if(count < 7)
            rang = NSMakeRange(0, count);
        else
            rang = NSMakeRange(0, 4);
        
        NSString *str = [string substringWithRange:rang];
        
        [newstring appendString:str];
        [newstring appendString:@"      "];
        [string deleteCharactersInRange:rang];
        
        count -= 4;
    }

    return newstring;
}

#pragma marks 字母或数字
+ (BOOL)numberOrLetterChangeformat:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    if(!basic){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//
////判断是否绑定银行卡
//+ (void)isBindBankCard:(UIView *)view
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *UserName = [defaults objectForKey:KEY_USER_NAME];
//    NSString *TradePassWord = [defaults objectForKey:KEY_USER_TRADEPASSWORD];
//    NSDictionary *DicCardData = [defaults objectForKey:KEY_USER_CARD_DATA];
//    NSString *UserID = [defaults objectForKey:KEY_USER_ID];
//    if([UserName isEqualToString:@""] || [TradePassWord isEqualToString:@""] || DicCardData.count == 0)
//    {
//        [HUD showHUDInView:view title:nil];
//        [[API sharedInstance]getUpDataUserInfoByUserID:UserID
//                Sucess:^(SuccessResult *result, id responseObject) {
//                    [HUD hideHUDInView:view];
//                    if(result.code ==1000){
//                        NSDictionary *dicData = [responseObject objectForKey:@"data"];
//                        NSString *TradePassWord = [dicData objectForKey:@"buss_pwd"];
//                        NSString *UserName = [dicData objectForKey:@"name"];
//                        int bank = [[dicData objectForKey:@"bank"] intValue];
//                        if (![TradePassWord isEqualToString:@""]) {
//                            [defaults setObject:TradePassWord forKey:KEY_USER_TRADEPASSWORD];
//                        }
//                        if (![UserName isEqualToString:@""]) {
//                            [defaults setObject:UserName forKey:KEY_USER_NAME];
//                        }
//                        if(bank == 1){
//                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                            [HUD showHUDInView:view title:nil];
//                            [[API sharedInstance] getBankInfoByUserID:UserID
//                                      success:^(SuccessResult *result, id responseObject){
//                                          [HUD hideHUDInView:view];
//                                          if (result.code == 1000)
//                                          {
//                                              NSMutableArray *DicArray = [responseObject objectForKey:@"data"];
//                                              if ([DicArray count] < 1)
//                                              {
//                                                  [defaults setObject:nil forKey:KEY_USER_CARD_DATA];
//                                                  return;
//                                              }
//                                              [defaults setObject:DicArray forKey:KEY_USER_CARD_DATA];
//
//                                          }
//                                          else
//                                          {
//                                              [defaults setObject:nil forKey:KEY_USER_CARD_DATA];
//                                              [HUD showMessageInView:view title:result.message];
//                                          }
//                                      }
//                                      failure:^(AFHTTPRequestOperation *operation, NSError *error){
//                                          [HUD showNetWorkErrorInView:view];
//                                      }];
//                        }
//
//                    }
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        }];
//    }
//}
//格式化转入转出说明的文本格式
+(NSMutableAttributedString *)ExplainTextForMatByLimit:(NSString *)StringLimit AndnNote:(NSString *)StringNote{
    
    StringLimit = [StringLimit stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    StringNote = [StringNote stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    NSString *StringContent = [NSString stringWithFormat:@"%@%@",StringLimit,StringNote];
    NSMutableAttributedString *StringLabel = [[NSMutableAttributedString alloc] initWithString:StringContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    [StringLabel setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0],NSParagraphStyleAttributeName : paragraphStyle,  NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} range:NSMakeRange(0, StringContent.length)];
    [StringLabel setAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSParagraphStyleAttributeName : paragraphStyle,  NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} range:NSMakeRange(StringLimit.length, StringNote.length)];
    return StringLabel;
    
}

+(float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}


+ (NSString*)jsonStringOfObj:(NSDictionary*)dic{
    NSError *err = nil;
    
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:dic
                                                         options:0
                                                           error:&err];
    
    NSString *str = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    return str;
}


//拉伸图片
+(UIImage *)stretchImageWithUIImage:(UIImage *)image{
    CGFloat top = 8; // 顶端盖高度
    CGFloat bottom = 8 ; // 底端盖高度
    CGFloat left = 8; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *stretchImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return stretchImage;
}

+ (NSString *)getMacModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    
    return modelNameString;
}

+ (NSString *)reviseString:(NSString *)string
{
    NSString *tempString = [NSString stringWithFormat:@"%@",string];
    NSRange pointRange = [tempString rangeOfString:@"."];

    if (pointRange.location != NSNotFound)
    {
        CGFloat limitlength = pointRange.location + pointRange.length;
        NSString *temp = [tempString substringFromIndex:limitlength];
        
        if (temp.length > 6)
        {
            /* 直接传入精度丢失有问题的Double类型*/
            double conversionValue        = (double)[tempString floatValue];
            NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
            NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
            return [decNumber stringValue];
        }
    }
    
    return tempString;
}

// 2个字符串10进制 异或 pan 源字符串
+ (NSString *)pin10Xor:(NSString *)pan withPinv:(NSString *)pinv
{
    NSString *temp = [[NSString alloc] init];
    temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%lld",[pan longLongValue]^[pinv longLongValue]]];
    
    if(temp.length < 9)
    {
        NSString *temp1 = [[NSString alloc] init];
        for (NSInteger i = 0; i < 9 - temp.length; i++)
        {
            temp1 = [temp1 stringByAppendingString:[NSString stringWithFormat:@"0"]];
        }
        
        temp = [NSString stringWithFormat:@"%@%@",temp1,temp];
    }
    return temp;
}

// 2个字符串16进制异或 pan 源字符串
+ (NSString *)pinXor:(NSString *)pan withPinv:(NSString *)pinv
{
    if (pan.length != pinv.length)
    {
        return nil;
    }
    
    const char *panchar = [pan UTF8String];
    const char *pinvchar = [pinv UTF8String];
    
    NSString *temp = [[NSString alloc] init];
    
    for (int i = 0; i < pan.length; i++)
    {
        int panValue = [self charToint:panchar[i]];
        int pinvValue = [self charToint:pinvchar[i]];
        
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%X",panValue^pinvValue]];
    }
    return temp;
    
}

+ (int)charToint:(char)tempChar
{
    if (tempChar >= '0' && tempChar <='9')
    {
        return tempChar - '0';
    }
    else if (tempChar >= 'A' && tempChar <= 'F')
    {
        return tempChar - 'A' + 10;
    }
    
    return 0;
}


//验证email
-(BOOL)isValidateEmail {
    
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
}



/**
 大数字缩写（@"34503" -> @"3.4万"）
 */
- (NSString *)getLargeNumbersAbbreviation{
    NSInteger number = self.integerValue;
    NSString * numStr;
    if (number < 10000) {
        numStr = @(number).stringValue;
    } else {
        CGFloat w = number / 10000.0;
        
        /**
         初始化方法
         
         @ roundingMode 舍入方式
         @ scale 小数点后舍入值的位数。
         @ exact 精度错误处理；YES:如果出现错误，将引发异常，NO:忽略错误并将控制权放回给调用者。
         @ overflow 溢出错误处理；YES:如果出现错误，将引发异常，NO:忽略错误并将控制权放回给调用者。
         @ underflow 下溢错误处理；YES:如果出现错误，将引发异常，NO:忽略错误并将控制权放回给调用者。
         @ divideByZero 除以0的错误处理；YES:如果出现错误，将引发异常，NO:忽略错误并将控制权放回给调用者。
         @ NSDecimalNumberHandler 对象
         */
        NSDecimalNumberHandler *hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:1  raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *num = [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",w]] decimalNumberByDividingBy :[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"1"]] withBehavior:hander];
        numStr = [NSString stringWithFormat:@"%@万", num];
    }
    
    return numStr;
}


- (UIColor *)getColor {
    return [self getColorWithAlpha:1];
}

- (UIColor *)getColorWithAlpha:(CGFloat)alpha {
    
    NSString *colorText = [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[colorText substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[colorText substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[colorText substringWithRange:range]] scanHexInt:&blue];
    
    return [[UIColor alloc] initWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
}


- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)checkMoneyIsValidCurrency
{
    if ([self isEqualToString:@"."]) {
        return YES;
    }
    if( ![self isPureInt] || ![self isPureFloat])
    {
        return NO;
    }
    return YES;
}

-(BOOL)inputShouldNumberText {
    if (self.length == 0) return NO;
        
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL b = [pred evaluateWithObject:self];
    return b;
}

+ (NSString *)NA_UUIDString
{
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    NSString *UUIDString = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, UUID);
    CFRelease(UUID);
    // Remove '-' in UUID
    return [[[UUIDString componentsSeparatedByString:@"-"] componentsJoinedByString:@""] lowercaseString];
}

- (NSString *)appVersionNumberFormat{
    NSString *str = [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    if (str.length >3) {
        str = [str substringToIndex:3];
    }else if (str.length<3) {
        str = [NSString stringWithFormat:@"%@0",str];
        str = [str appVersionNumberFormat];
    }
    return str;
}

- (NSString *)phoneNumberFormat{
    NSString *string = self;
    if (self.length >7) {
        string = [self stringByReplacingOccurrencesOfString:[self substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    }
    return string;
}


- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}



// 时间戳 ---> 2020-3-4 16:05:05
- (NSString *)dateStringFromTimeYMDHMS
{
    //毫秒 时间戳。要除1000
    CGFloat dataStr = [self doubleValue]/1000.000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dataStr];
    return NAStringFromDate(@"yyyy-MM-dd HH:mm:ss", date);
}

- (NSString *)stringWithoutSpaceAndEnter
{
    NSString *targetString;
    targetString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"■" withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@" " withString:@""];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"■" withString:@""];
    return targetString;
}

- (long long)getfilePathOfSize
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self]){
        return [[manager attributesOfItemAtPath:self error:nil] fileSize];
    }
    return 0;
}
- (float)getFolderNameOfSize
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString *folderPath = [[NSString BundlePath] stringByAppendingPathComponent:self];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [fileAbsolutePath getfilePathOfSize];
    }
    return folderSize/(1024.0*1024.0);
}

- (void)clearFolderNameAtCache{
    NSFileManager* manager = [NSFileManager defaultManager];
     NSString *folderPath = [[NSString BundlePath] stringByAppendingPathComponent:self];
    if ([manager fileExistsAtPath:folderPath]){
        [manager removeItemAtPath:folderPath error:nil];
    };
}

@end
