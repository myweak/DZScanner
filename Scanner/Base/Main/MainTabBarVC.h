//
//  MainTabBarVC.h
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineViewController.h"
#import "OrderViewController.h"
#import "LXScanViewController.h"
#import "JJTabBarControllerLib.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainTabBarVC : UIViewController
@property (nonatomic,strong) JJTabBarController *tabBarController;
//@property (nonatomic, strong) JJTabBarView *tabBarView;
@property (nonatomic, strong) OrderViewController *orderVC;
@property (nonatomic, strong) MineViewController *mineVC;
@property (nonatomic, strong) LXScanViewController *scanVC;


@end


NS_ASSUME_NONNULL_END
