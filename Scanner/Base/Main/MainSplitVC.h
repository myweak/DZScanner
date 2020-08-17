//
//  MainSplitVC.h
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXNavigationController.h"
#import "MineViewController.h"
#import "OrderViewController.h"
#import "LXScanViewController.h"
#import "LXLeftMainVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainSplitVC : UISplitViewController

@property (nonatomic, strong) OrderViewController *orderVC;
@property (nonatomic, strong) MineViewController *mineVC;
@property (nonatomic, strong) LXScanViewController *scanVC;

@end

NS_ASSUME_NONNULL_END
