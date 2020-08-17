//
//  ViewUtilities.m
//  Scanner
//
//  Created by Jeremy Steward on 7/22/19.
//  Copyright © 2019 rrd. All rights reserved.
//

#import "ViewUtilities.h"

UIColor* colorFromHexString(NSString* hexString)
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF) / 255.0f;
    float green = ((baseValue >> 16) & 0xFF) / 255.0f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
    float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

UIImage* imageWithColor(UIColor* color, CGRect rect, CGFloat cornerRadius)
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context,YES);
    CGContextSetShouldAntialias(context,YES);
    
    [color setFill];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextSetAllowsAntialiasing(context,NO);
    CGContextSetShouldAntialias(context,NO);
    
    UIGraphicsEndImageContext();
    
    return image;
}

UIView* createHorizontalRule(CGFloat height)
{
    // NOTE: You still need to add a width == superview.width constraint
    // You may also want to change the background color
    UIView* horizontalRule = [[UIView alloc] init];
    horizontalRule.translatesAutoresizingMaskIntoConstraints = NO;
    horizontalRule.backgroundColor = [UIColor darkGrayColor];
    
    [horizontalRule addConstraint:
     [NSLayoutConstraint constraintWithItem:horizontalRule
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0
                                   constant:height]];
    return horizontalRule;
}
