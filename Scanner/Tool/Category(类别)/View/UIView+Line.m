//
//  UIView+Line.m
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/17.
//  Copyright © 2018年 Simple. All rights reserved.
//


static char blockKey;
static char blockLongKey;

//线条颜色
#define mz_lineColor [UIColor c_lineColor]
#define mzLine_H 0.5f

#import "UIView+Line.h"

@implementation UIView (Line)

- (void)addLine_top
{
    CALayer * layers = [CALayer layer];
    CGFloat width    = self.width;
    layers.frame = CGRectMake(0, 0, width, mzLine_H);
    layers.backgroundColor = mz_lineColor.CGColor;
    [self.layer addSublayer:layers];
}

- (void)addLine_bottom
{
    CALayer * layers = [CALayer layer];
    CGFloat height   = mzLine_H;
    CGFloat width    = self.width;
    layers.frame = CGRectMake(0, self.height - height, width, height);
    layers.backgroundColor = mz_lineColor.CGColor;
    [self.layer addSublayer:layers];
}

- (void)addLine_left
{
    CALayer * layers = [CALayer layer];
    CGFloat height   = self.height;
    CGFloat width    = mzLine_H;
    layers.frame = CGRectMake(0, 0, width, height);
    layers.backgroundColor = mz_lineColor.CGColor;
    [self.layer addSublayer:layers];
}
- (void)addLine_right
{
    CALayer * layers = [CALayer layer];
    CGFloat height   = self.height;
    CGFloat width    = mzLine_H;
    layers.frame = CGRectMake(self.width, 0, width, height);
    layers.backgroundColor = mz_lineColor.CGColor;
    [self.layer addSublayer:layers];
}

- (void)addLine_top:(UIColor *)color W:(CGFloat)W H:(CGFloat)H
{
    CALayer * layers = [CALayer layer];
    CGFloat width    = W;
    layers.frame = CGRectMake(0, 0, width, H);
    layers.backgroundColor = color.CGColor;
    [self.layer addSublayer:layers];
}

- (void)addLine_bottom:(UIColor *)color W:(CGFloat)W H:(CGFloat)H
{
    CALayer * layers = [CALayer layer];
    CGFloat height   = H;
    CGFloat width    = W;
    layers.frame = CGRectMake(0, self.height - height, width, height);
    layers.backgroundColor = color.CGColor;
    [self.layer addSublayer:layers];
}

- (void)addLine_left:(UIColor *)color H:(CGFloat)H
{
    CALayer * layers = [CALayer layer];
    CGFloat height   = self.height;
    CGFloat width    = H;
    layers.frame = CGRectMake(0, 0, width, height);
    layers.backgroundColor = color.CGColor;
    [self.layer addSublayer:layers];
}
- (void)addLine_right:(UIColor *)color H:(CGFloat)H
{
    CALayer * layers = [CALayer layer];
    CGFloat height   = self.height;
    CGFloat width    = H;
    layers.frame = CGRectMake(self.width, 0, width, height);
    layers.backgroundColor = color.CGColor;
    [self.layer addSublayer:layers];
}

//画线
- (void)addLine:(CGRect)frame{
    [self addLineWithFrame:frame color:nil];
}
- (CALayer *)addLineWithFrame:(CGRect)frame color:(UIColor *)color
{
    CALayer * layers = [CALayer layer];
    layers.frame = frame;
    layers.backgroundColor = (color == nil ? mz_lineColor.CGColor: color.CGColor);
    [self.layer addSublayer:layers];
    return layers;
}


-(void)addLindeBorderWithColor:(UIColor *)color andRadius:(CGFloat)Radius{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = Radius;
    self.layer.borderColor = (color == nil ? mz_lineColor.CGColor:color.CGColor);
}


- (void)removeAllGestures {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
    }
}

#pragma mark - Tap

- (void)handleTap:(TapBlock)tapBlock delegate:(id)delegate {
    objc_setAssociatedObject(self, &blockKey, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addAGestureRecognizer:delegate];
}

- (void)handleTap:(TapBlock)tapBlock {
    [self handleTap:tapBlock delegate:nil];
}

- (void)addAGestureRecognizer:(id)delegate {
    [self removeAllGestures];
    self.userInteractionEnabled =   YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didTapped:)] ;
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    if (delegate) {
        tapGesture.delegate = delegate;
    }
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Long Tap

- (void)handleLongTap:(TapBlock)tapBlock {
    objc_setAssociatedObject(self, &blockLongKey, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addALongGestureRecognizer];
}

- (void)addALongGestureRecognizer {
    [self removeAllGestures];
    self.userInteractionEnabled =   YES;
    UILongPressGestureRecognizer *longTapGesture = [[UILongPressGestureRecognizer alloc]  initWithTarget:self action:@selector(didLongTapped:)] ;
    longTapGesture.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longTapGesture];
    
}
- (void)didTapped:(UITapGestureRecognizer *)rec {
    CGPoint point = [rec locationInView:self];
    TapBlock block =   objc_getAssociatedObject(self, &blockKey);
    if (block) {
        block(point,rec);
    }
}

- (void)didLongTapped:(UITapGestureRecognizer *)rec {
    
    if (rec.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [rec locationInView:self];
        TapBlock block =   objc_getAssociatedObject(self, &blockLongKey);
        block(point,rec);
    }
}


@end
