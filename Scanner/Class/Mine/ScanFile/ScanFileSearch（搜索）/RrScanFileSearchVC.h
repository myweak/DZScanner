//
//  RrScanFileSearchVC.h
//  Scanner
//
//  Created by edz on 2020/8/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//
@class ScanFileModel;
typedef void (^RrScanFileSearchVCTapBlock)(ScanFileModel *model);

typedef enum : NSUInteger {
    RrScanFileSearchVCType_nomal = 0,
    RrScanFileSearchVCType_choose, // 选择
} RrScanFileSearchVCType;

#import "RrSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrScanFileSearchVC : RrSearchViewController
@property (nonatomic, assign) RrScanFileSearchVCType searchTypes;
@property (nonatomic, copy)   RrScanFileSearchVCTapBlock tapBlock;
@end

NS_ASSUME_NONNULL_END
