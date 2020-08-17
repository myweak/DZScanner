//
//  RrAddImageView.h
//  Scanner
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPhotoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RrAddImageView : UIView
//@property (nonatomic, strong) UIView *contenViewBg ;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) AddPhotoView *addPView ;

@property (nonatomic, copy)   ComplemntBlock complemntBlock;

@end

NS_ASSUME_NONNULL_END
