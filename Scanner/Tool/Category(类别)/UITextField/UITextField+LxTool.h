//
//  UITextField+LxTool.h
//  Scanner
//
//  Created by edz on 2020/8/3.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (LxTool)

// 限制textfild 小数位数为2位
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
