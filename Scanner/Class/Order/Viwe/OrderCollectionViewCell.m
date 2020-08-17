//
//  OrderCollectionViewCell.m
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "OrderCollectionViewCell.h"

@implementation OrderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 5;
    self.titleLabel.font = KFont35;
    // 图片 底部阴影
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0, 0, self.viewBg.width, self.viewBg.height);
//    gl.startPoint = CGPointMake(0.5, 0);
//    gl.endPoint = CGPointMake(0.5, 1);
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5].CGColor];
//    gl.locations = @[@(0), @(1.0f)];
//    [self.viewBg.layer insertSublayer:gl atIndex:0];
    
}

@end
