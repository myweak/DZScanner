//
//  MineScanFieldVC.h
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

@class ScanFileModel;
typedef void (^MineScanFieldVCTapBlock)(ScanFileModel *model);

typedef enum : NSUInteger {
    MineScanFieldVCType_nomal = 0,
    MineScanFieldVCType_choose, // 选择
} MineScanFieldVCType;



#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineScanFieldVC : MainViewController
@property (nonatomic, assign) MineScanFieldVCType type;
@property (nonatomic, copy)   MineScanFieldVCTapBlock tapBlock;

@end

NS_ASSUME_NONNULL_END
