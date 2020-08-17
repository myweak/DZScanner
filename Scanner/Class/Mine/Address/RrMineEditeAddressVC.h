//
//  RrMineEditeAddressVC.h
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//

typedef void (^BackSaveSucceedBlock)(void);

typedef NS_ENUM(NSInteger,RrMineEditeAddressType) {
    RrMineEditeAddressType_edit = 0, //编辑
    RrMineEditeAddressType_add , // 添加
};
#import "MainViewController.h"
#import "RrMineAddressMdoel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrMineEditeAddressVC : MainViewController
@property (nonatomic, assign)   RrMineEditeAddressType type;
@property (nonatomic, strong)   RrMineAddressMdoel *addreModel;
@property (nonatomic, copy)   BackSaveSucceedBlock backSaveSucceedBlock;
@end

NS_ASSUME_NONNULL_END
