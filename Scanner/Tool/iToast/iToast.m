//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>
#import "MZKeyboardDetectManager.h"

#define kPadding 150

#define m_toast_tag 2009

enum iToastDuration {
    iToastDurationLong = 10000,
    iToastDurationShort = 1000,
    iToastDurationNormal = 3000
}iToastDuration;

static iToastSettings *sharedSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast


- (id) initWithText:(NSString *) tex{
    if (self = [super init]) {
        text = [tex copy];
    }
    
    return self;
}

- (void) show{
    [self show:iToastTypeNone];
}
- (void) show:(iToastType) type {
    [self show:type superview:nil];
}
- (void) show:(iToastType) type superview:(UIView *)superview{
    
    iToastSettings *theSettings = _settings;
    
    if (!theSettings) {
        theSettings = [iToastSettings getSharedSettings];
    }
    
    UIImage *image = [theSettings.images valueForKey:[NSString stringWithFormat:@"%i", type]];
    
    UIFont *font = [UIFont systemFontOfSize:16.f];
    //    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 80, 60)];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 80,MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : font} context:nil].size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(1, 1);
    
    UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        v.frame = CGRectMake(0, 0, image.size.width + textSize.width + 30, MAX(textSize.height, image.size.height) + 15);
        label.center = CGPointMake(image.size.width + 10 + (v.frame.size.width - image.size.width - 10) / 2, v.frame.size.height / 2);
    } else {
        v.frame = CGRectMake(0, 0, textSize.width + 30, textSize.height + 15);
        label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
    }
    [v addSubview:label];
    
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(5, (v.frame.size.height - image.size.height)/2, image.size.width, image.size.height);
        [v addSubview:imageView];
    }
    
    v.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.7];
    v.layer.cornerRadius = 4;
    
    
    UIView *window = superview;
    if (!window) {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    
    CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    
    // Set correct orientation/location regarding device orientation
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    float width = window.frame.size.width;
    float height = window.frame.size.height;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        {
            if (theSettings.gravity == iToastGravityTop) {
                point = CGPointMake(window.frame.size.width / 2, kPadding);
            } else if (theSettings.gravity == iToastGravityBottom) {
                point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - kPadding);
            } else if (theSettings.gravity == iToastGravityCenter) {
                point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            } else {
                point = theSettings.postition;
            }
            
            point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:
        {
            v.transform = CGAffineTransformMakeRotation(M_PI);
            
            
            
            if (theSettings.gravity == iToastGravityTop) {
                point = CGPointMake(width / 2, height - kPadding);
            } else if (theSettings.gravity == iToastGravityBottom) {
                point = CGPointMake(width / 2, kPadding);
            } else if (theSettings.gravity == iToastGravityCenter) {
                point = CGPointMake(width/2, height/2);
            } else {
                // TODO : handle this case
                point = theSettings.postition;
            }
            
            point = CGPointMake(point.x - offsetLeft, point.y - offsetTop);
            break;
        }
        case UIDeviceOrientationLandscapeLeft:
        {
            //			v.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
            
            if (theSettings.gravity == iToastGravityTop) {
                point = CGPointMake(width / 2,  kPadding);
            } else if (theSettings.gravity == iToastGravityBottom) {
                point = CGPointMake(kPadding,window.frame.size.height / 2);
            } else if (theSettings.gravity == iToastGravityCenter) {
                point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            } else {
                // TODO : handle this case
                point = theSettings.postition;
            }
            
            point = CGPointMake(point.x - offsetTop, point.y - offsetLeft);
            break;
        }
        case UIDeviceOrientationLandscapeRight:
        {
            // 屏幕读取问题
            //			v.transform = CGAffineTransformMakeRotation(-M_PI/2);
            
            if (theSettings.gravity == iToastGravityTop) {
                point = CGPointMake(kPadding, window.frame.size.height / 2);
            } else if (theSettings.gravity == iToastGravityBottom) {
                point = CGPointMake(window.frame.size.width - kPadding, window.frame.size.height/2);
            } else if (theSettings.gravity == iToastGravityCenter) {
                point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            } else {
                // TODO : handle this case
                point = theSettings.postition;
            }
            
            point = CGPointMake(point.x + offsetTop, point.y + offsetLeft);
            break;
        }
        default:
            break;
    }
    
    
    v.center = point;
    
    UIView *lastToast = [window viewWithTag:m_toast_tag];
    if (lastToast) {
        [lastToast removeFromSuperview];
        lastToast.alpha = 0.f;
        lastToast.hidden = YES;
    }
    
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
                                              target:self selector:@selector(hideToast:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowOpacity = 0.4;
    v.layer.shadowRadius = 2.5;
    v.layer.shadowOffset = (CGSize){1.8,1.8};
    v.tag = m_toast_tag;
    [window addSubview:v];
    
    view = v;
    
    [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (void) hideToast:(NSTimer*)theTimer{
    [UIView beginAnimations:nil context:NULL];
    view.alpha = 0;
    [UIView commitAnimations];
    
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:500
                                              target:self selector:@selector(hideToast:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
    [view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text{
    iToast *toast = [[iToast alloc] initWithText:_text];
    
    return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
    [self theSettings].duration = duration;
    return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
             offsetLeft:(NSInteger) left
              offsetTop:(NSInteger) top{
    [self theSettings].gravity = gravity;
    offsetLeft = left;
    offsetTop = top;
    return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
    [self theSettings].gravity = gravity;
    return self;
}

- (iToast *) setPostion:(CGPoint) _position{
    [self theSettings].postition = CGPointMake(_position.x, _position.y);
    
    return self;
}

-(iToastSettings *) theSettings{
    if (!_settings) {
        _settings = [[iToastSettings getSharedSettings] copy];
    }
    
    return _settings;
}

+ (void)ahShowBottom_ToastWithText:(NSString *)text
{
    [self showToastWithText:text position:iToastGravityBottom witduration:1700];
}

+ (void)showTop_ToastWithText:(NSString *)text
{
    [self showToastWithText:text position:iToastGravityTop witduration:1700];
}

+ (void)showBottom_ToastWithText:(NSString *)text
{
    [self showToastWithText:text position:iToastGravityBottom witduration:1700];
}

+ (void)showCenter_ToastWithText:(NSString *)text
{
    [self showToastWithText:text position:iToastGravityCenter witduration:1700];
}

+ (void)showCenter_ToastWithText:(NSString *)text superview:(UIView *)superview
{
    [self showToastWithText:text position:iToastGravityCenter witduration:1700 superview:superview];
}

+ (void)showToastWithText:(NSString *)text position:(iToastGravity)gravity
{
    if (gravity == iToastGravityBottom && [MZKeyboardDetectManager sharedInstance].isVisible) {
        gravity = iToastGravityCenter;
    }
    [self showToastWithText:text position:gravity witduration:1700];
}
+ (void)showToastWithText:(NSString *)text position:(iToastGravity)gravity witduration:(CGFloat)duration{
    [self showToastWithText:text position:gravity witduration:duration superview:nil];
}
+ (void)showToastWithText:(NSString *)text position:(iToastGravity)gravity witduration:(CGFloat)duration superview:(UIView*)superview
{
    duration = [self calculateDuration:text];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (text.length) {
            iToast *toast = [iToast makeText:text];
            toast = [toast setDuration:duration];
            [[toast setGravity:gravity] show:iToastTypeNone superview:superview];
            
        }
        
    });
}

+ (CGFloat)calculateDuration:(NSString *)text{
    CGFloat duration = [self judgeChineseCount:text] * 200 + [self judgeNumberCount:text] * 100 + [self judgeLetterCount:text] * 50;
    if (duration < 1700) {
        duration = 1700;
    }
    return duration;
}

+ (NSUInteger)judgeNumberCount:(NSString*)text {
    if (!text) {
        return 0;
    }
    NSRegularExpression * tNumberRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumberMatchCount = [tNumberRegularExpression  numberOfMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    return tNumberMatchCount;
    
}

+ (NSUInteger)judgeLetterCount:(NSString*)text {
    if (!text) {
        return 0;
    }
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    
    return tLetterMatchCount;
}

+ (NSUInteger)judgeChineseCount:(NSString*)text {
    if (!text) {
        return 0;
    }
    //中文条件
    NSRegularExpression *tChineseRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger tChineseMatchCount = [tChineseRegularExpression numberOfMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    return tChineseMatchCount;
    
}
@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
    if (type == iToastTypeNone) {
        // This should not be used, internal use only (to force no image)
        return;
    }
    
    if (!images) {
        images = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    if (img) {
        NSString *key = [NSString stringWithFormat:@"%i", type];
        [images setValue:img forKey:key];
    }
}


+ (iToastSettings *) getSharedSettings{
    if (!sharedSettings) {
        sharedSettings = [iToastSettings new];
        sharedSettings.gravity = iToastGravityCenter;
        sharedSettings.duration = iToastDurationShort;
    }
    
    return sharedSettings;
    
}

- (id) copyWithZone:(NSZone *)zone{
    iToastSettings *copy = [iToastSettings new];
    copy.gravity = self.gravity;
    copy.duration = self.duration;
    copy.postition = self.postition;
    
    NSArray *keys = [self.images allKeys];
    
    for (NSString *key in keys){
        [copy setImage:[images valueForKey:key] forType:[key intValue]];
    }
    
    return copy;
}

@end
