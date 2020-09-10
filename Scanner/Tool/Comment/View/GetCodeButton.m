//
//  GetCodeButton.m
//  Scanner
//
//  Created by edz on 2020/7/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "GetCodeButton.h"
@interface GetCodeButton()
@property (nonatomic,strong)dispatch_source_t sometimer;
@end

@implementation GetCodeButton

@synthesize countTime = _countTime;
- (instancetype)init
{
    self = [GetCodeButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.isCounting = NO;
        self.countTime = 60;
        self.buttonEnableColor = [UIColor yellowColor];
        self.buttonDisableColor = [UIColor colorWithWhite:1.f alpha:0.3f];
        self.disableTitleColor = [UIColor colorWithWhite:1.f alpha:0.3f];
        self.enableTitleColor = [UIColor redColor];
        self.layer.borderColor = self.buttonEnableColor.CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:self.disableTitleColor forState:UIControlStateDisabled];
        self.titleLabel.font = KFont14;
        self.backgroundColor = [UIColor clearColor];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return self;
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setButtonEnableColor:(UIColor *)buttonEnableColor
{
    _buttonEnableColor = buttonEnableColor;
    if (self.enabled) {
    }
}

- (void)setButtonDisableColor:(UIColor *)buttonDisableColor
{
    _buttonDisableColor = buttonDisableColor;
    if (!self.enabled) {
    }
}

- (UIColor *)disableTitleColor
{
    if (!_disableTitleColor) {
        _disableTitleColor = [UIColor whiteColor];
    }
    return _disableTitleColor;
}

- (UIColor *)enableTitleColor
{
    if (!_enableTitleColor) {
        _enableTitleColor = [UIColor whiteColor];
    }
    return _enableTitleColor;
}

- (void)getSubmitCodeWithAction:(void (^)(void))block completeCounting:(void (^)(void))completion
{
    self.completionBlock = completion;
    if (block) {
        block();
    }
}

- (void)counting
{
    self.isCounting = YES;
    self.enabled = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    _sometimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0,0, queue);
    dispatch_source_set_timer(_sometimer, dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0);// 每秒执行一次
    
    NSTimeInterval seconds = self.countTime;
    WEAKSELF
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds];// 最后期限
    dispatch_source_set_event_handler(_sometimer, ^{
        NSTimeInterval interval = [endTime timeIntervalSinceNow];
        if(interval >0) {// 更新倒计时
            NSString *timeStr = [NSString stringWithFormat:@"%.0fs后", interval];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.timeTipsStr) {
                    [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,weakSelf.timeTipsStr] forState:UIControlStateDisabled];
                }else{
                    [weakSelf setTitle:[NSString stringWithFormat:@"%@重新获取",timeStr] forState:UIControlStateDisabled];
                }
            });
            
        }else{// 倒计时结束，关闭
            dispatch_source_cancel(weakSelf.sometimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf finishCounting];
            });
        }
    });
    
    dispatch_resume(_sometimer);
}

- (void)stopCounting
{
    if (self.isCounting) {
        dispatch_source_cancel(self.sometimer);
        [self setTitle:@"重新获取" forState:UIControlStateNormal];
        self.isCounting = NO;
        self.enabled = YES;
    }
}

- (void)reset
{
    if (self.isCounting) {
        dispatch_source_cancel(self.sometimer);
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.isCounting = NO;
        self.enabled = YES;
    }
}

- (void)finishCounting
{
    [self setTitle:@"重新获取" forState:UIControlStateNormal];
    self.layer.borderColor = self.enableTitleColor.CGColor;
    self.isCounting = NO;
    self.enabled = YES;
    if (self.completionBlock) {
        self.completionBlock();
    }
}


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        [self setTitleColor:self.enableTitleColor forState:UIControlStateNormal];
        self.layer.borderColor = self.enableTitleColor.CGColor;
    }
    else {
        [self setTitleColor:self.disableTitleColor forState:UIControlStateNormal];
        self.layer.borderColor = self.disableTitleColor.CGColor;
    }
}

- (void)updateColors
{
    [self setTitleColor:self.enableTitleColor forState:UIControlStateNormal];
    [self setTitleColor:self.disableTitleColor forState:UIControlStateDisabled];
}
-(void)setABGetCodeButtonType:(GetCodeButtonType)abGetCodeButtonType{
    _abGetCodeButtonType = abGetCodeButtonType;
}
@end

