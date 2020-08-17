//
//  UIImage+NAAdditions.h
//  StraightPin
//
//  Created by Nathan Ou on 15/3/6.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NATools)

- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)zipImageWithSize:(CGSize)size;
- (UIImage*)blurredImage:(CGFloat)blurAmount;
- (UIImage *)JTS_applyBlurWithRadius:(CGFloat)blurRadius
                           tintColor:(UIColor *)tintColor
               saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                           maskImage:(UIImage *)maskImage;

- (UIImage *)fixImageOrientition;

+ (UIImage *)grayscaleImageForImage:(UIImage *)image ;

+ (UIImage *)imageWithColor: (UIColor *)color;

/**
 根据大小重新绘制图片
 
 @param size 大小
 @return 图片
 */
-(UIImage*)scaleToSize:(CGSize)size;

// 对Image图片本身进行旋转0，90，180，270
- (UIImage *)toRotation:(UIImageOrientation)orientation;

@end
