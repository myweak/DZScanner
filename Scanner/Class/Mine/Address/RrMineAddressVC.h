//
//  RrMineAddressVC.h
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//


#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RrMineAddressVCBackBlock)(NSString *address,NSString *addreId);

@protocol RrMineAddressVCDelegate<NSObject>

- (void)rrMineAddressVCSelectAddress:(NSString *)address  AddreId:(NSString *)addreId;

@end

@interface RrMineAddressVC : MainViewController

@property (nonatomic, assign) id<RrMineAddressVCDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
