//
//  UIColor+Additions.m
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)


+(instancetype)c_alpha_bgWhiteColor{
    return [UIColor colorWithWhite:0.f alpha:0.6f];
}


+ (instancetype)c_ThemeColor{
    return [UIColor colorFromARGBString:@"231816"];
}

+ (instancetype)mian_BgColor{
    return [UIColor colorFromARGBString:@"F5F5F5"];
}

+ (instancetype)c_iconNorColor{
    return [UIColor colorFromARGBString:@"A8A8A8"];
}

+ (instancetype)c_iconSelectColor{
    return [UIColor colorFromARGBString:@"00C280"];
}

+ (instancetype)c_GreenColor{
    return [UIColor colorFromARGBString:@"00C280"];
}
+ (instancetype)c_lineColor{
    return [UIColor colorFromARGBString:@"E9E9E9"];
}

+ (instancetype)c_BgGrayColor{
    return [UIColor colorFromARGBString:@"D3D3D3"];
}

+ (instancetype)c_GrayColor{
    return [UIColor colorFromARGBString:@"A9A9A9"];
}

+ (instancetype)c_GrayNotfiColor{
    return [UIColor colorFromARGBString:@"A7A7A7"];
}


+ (instancetype)c_mainBackColor{
    return [UIColor colorFromARGBString:@"000000"];
}
+ (instancetype)c_redColor{
    return [UIColor colorFromARGBString:@"FF0000"];
}

+ (instancetype)c_mianblackColor{
    return [UIColor colorFromARGBString:@"010101"];
}

+ (instancetype)c_btn_Bg_Color{
    return [UIColor colorFromARGBString:@"FF6B00"];
}




@end
