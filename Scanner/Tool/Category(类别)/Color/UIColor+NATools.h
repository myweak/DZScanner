//
//  UIColor+NATools.h
//  MyCollections
//
//  Created by Nathan on 14-11-3.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NATools)

+ (instancetype)NA_ColorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue;
+ (instancetype)blueIOSColor;
+ (instancetype)colorFromARGB:(int)argb;
+ (instancetype)colorFromRGB:(int)argb withAlpha:(CGFloat)alpha;

+ (instancetype)colorFromARGBString:(NSString *)string;
+ (instancetype)colorFromARGBString:(NSString *)string withAlpha:(CGFloat)alpha;


@end
