//
//  UIView+Tap.m
//  Tangren
//
//  Created by  TB-home on 15/10/8.
//  Copyright (c) 2015年  TB-home. All rights reserved.
//

#import "UIView+Tap.h"

@implementation UIView (Tap)




static char blockKey;
static char blockLongKey;

#pragma mark - Edges


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
