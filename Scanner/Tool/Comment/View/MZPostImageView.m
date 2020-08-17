//
//  MZPostImageView.m
//  MiZi
//
//  Created by Nathan Ou on 2018/8/7.
//  Copyright © 2018年 Simple. All rights reserved.
//
#define KSpace  15
#import "MZPostImageView.h"

@implementation MZPostImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KSpace, self.width-KSpace, self.height-KSpace)];
    }

    return _imageView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
            [_deleteButton setImage:[UIImage imageNamed:@"image_remv"] forState:UIControlStateNormal];
//            [_deleteButton sizeToFit];
        _deleteButton.width = 60;
        _deleteButton.height = 60;
//            _deleteButton.right = self.width;
        _deleteButton.centerX = self.width-KSpace;
        _deleteButton.centerY = KSpace;
//            _deleteButton.contentMode =  UIViewContentModeTopRight;

        //    _deleteButton.hidden = YES;
        //    _deleteButton.backgroundColor = [UIColor redColor];
            [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (void)deleteButtonAction:(UIButton *)button
{
    if (self.deleteButtonActionBlock) {
        self.deleteButtonActionBlock(self);
    }
}


@end
