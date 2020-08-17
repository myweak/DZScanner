//
//  MZKeyboardDetectManager.m
//  MiZi
//
//  Created by Simple on 2018/7/18.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import "MZKeyboardDetectManager.h"

@interface MZKeyboardDetectManager ()

@property (nonatomic, strong) NSMutableArray *detectBlocks;

@end

@implementation MZKeyboardDetectManager

+ (instancetype)sharedInstance
{
    static MZKeyboardDetectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MZKeyboardDetectManager alloc] init];
        manager.detectBlocks = [NSMutableArray array];
    });
    return manager;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    _isVisible = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self.detectBlocks enumerateObjectsUsingBlock:^(KeyboardShowNotificationBlock block, NSUInteger idx, BOOL * _Nonnull stop) {
        block(YES, keyboardRect.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _isVisible = NO;
    [self.detectBlocks enumerateObjectsUsingBlock:^(KeyboardShowNotificationBlock block, NSUInteger idx, BOOL * _Nonnull stop) {
        block(NO, 0.f);
    }];
}

- (void)addKeyBoardDetectBlock:(KeyboardShowNotificationBlock)block
{
    [self.detectBlocks addObject:block];
}

- (id)init
{
    if ((self = [super init])) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

@end
