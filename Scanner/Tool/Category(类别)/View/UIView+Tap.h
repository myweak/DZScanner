//
//  UIView+Tap.h
//  Tangren
//
//  Created by  TB-home on 15/10/8.
//  Copyright (c) 2015年  TB-home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^TapBlock)(CGPoint loc,UIGestureRecognizer *tapGesture);

@interface UIView (Tap)

- (void)handleTap:(TapBlock)tapBlock;

- (void)handleTap:(TapBlock)tapBlock delegate:(id)delegate;

- (void)handleLongTap:(TapBlock)tapBlock;

- (void)removeAllGestures;



@end
