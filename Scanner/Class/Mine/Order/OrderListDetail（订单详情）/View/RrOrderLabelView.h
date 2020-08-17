//
//  RrOrderLabelView.h
//  Scanner
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrOrderLabelView : UIView
@property (nonatomic, strong) UIView *contenViewBg ;
@property (nonatomic, strong) NSArray *itemLabelArr;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *itemLabelViewArr; // 保存 itemLabelArr 里的label 

- (void)updateConfigUI;
@end

NS_ASSUME_NONNULL_END
