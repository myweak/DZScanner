//
//  UIColor+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-11-3.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "UIColor+NATools.h"

@implementation UIColor (NATools)

+ (instancetype)NA_ColorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue
{
    return [[UIColor alloc] initWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1];
}

+ (instancetype)blueIOSColor
{
    return [[UIColor alloc] initWithRed:0.047 green:0.373 blue:0.996 alpha:1.000];
}

+ (instancetype)colorFromARGBString:(NSString *)string
{
    if (![[string substringToIndex:1] isEqualToString:@"#"] && string.length != 9) {
        string = [NSString stringWithFormat:@"#FF%@",string];
    }
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    
    return [self colorFromARGB:result];
}

+ (instancetype)colorFromARGBString:(NSString *)string withAlpha:(CGFloat)alpha
{
    if (![[string substringToIndex:1] isEqualToString:@"#"] && string.length != 9) {
        string = [NSString stringWithFormat:@"#FF%@",string];
    }
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    
    return [self colorFromRGB:result withAlpha:alpha];
}

+ (instancetype)colorFromARGB:(int)argb
{
    int blue = argb & 0xff;
    int green = argb >> 8 & 0xff;
    int red = argb >> 16 & 0xff;
    CGFloat alpha = (argb >> 24 & 0xff)/255.f;
    
    return [[UIColor alloc] initWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (instancetype)colorFromRGB:(int)argb withAlpha:(CGFloat)alpha
{
    int blue = argb & 0xff;
    int green = argb >> 8 & 0xff;
    int red = argb >> 16 & 0xff;
    
    return [[UIColor alloc] initWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}




@end
