//
//  MZKeyboardDetectManager.h
//  MiZi
//
//  Created by Simple on 2018/7/18.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KeyboardShowNotificationBlock)(BOOL keyBoardShow, CGFloat keyBoardHeight);

@interface MZKeyboardDetectManager : NSObject

+ (instancetype)sharedInstance;

- (void)addKeyBoardDetectBlock:(KeyboardShowNotificationBlock)block;

@property (nonatomic, assign) BOOL isVisible;
@end
