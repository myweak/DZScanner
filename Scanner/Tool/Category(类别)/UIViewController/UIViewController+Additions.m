//
//  UIViewController+Additions.m
//  MiZi
//
//  Created by Simple on 2018/7/16.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import "UIViewController+Additions.h"
//#import "RAlertView.h"
//#import "AHAlertAction.h"
//#import <UMMobClick/MobClick.h>


@implementation UIViewController (Additions)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL viewWillOriginaSelector = @selector(viewWillAppear:);
        SEL viewWillSwizzledSelector = @selector(as_viewWillAppear:);

        SEL viewWillDissOriginaSelector = @selector(viewWillDisappear:);
        SEL viewWillDissSwizzledSelector = @selector(as_viewWillDisappear:);

        Method viewWillAppear = class_getInstanceMethod(class, @selector(viewWillAppear:));
        Method as_viewWillAppear = class_getInstanceMethod(class, @selector(as_viewWillAppear:));
        BOOL viewWillSuccess = class_addMethod(class, viewWillOriginaSelector, method_getImplementation(as_viewWillAppear), method_getTypeEncoding(as_viewWillAppear));
        if (viewWillSuccess) {
            class_replaceMethod(class, viewWillSwizzledSelector, method_getImplementation(viewWillAppear), method_getTypeEncoding(viewWillAppear));
        }else{
            method_exchangeImplementations(viewWillAppear, as_viewWillAppear);
        }

        Method viewWillDisappear = class_getInstanceMethod(class, @selector(viewWillDisappear:));
        Method as_viewWillDisappear = class_getInstanceMethod(class, @selector(as_viewWillDisappear:));

        BOOL viewWillDissSuccess = class_addMethod(class, viewWillDissOriginaSelector, method_getImplementation(as_viewWillDisappear), method_getTypeEncoding(as_viewWillDisappear));
        if (viewWillDissSuccess) {
            class_replaceMethod(class, viewWillDissSwizzledSelector, method_getImplementation(viewWillDisappear), method_getTypeEncoding(viewWillDisappear));
        }else{
            method_exchangeImplementations(viewWillDisappear, as_viewWillDisappear);
        }
    });
}


- (void)as_viewWillAppear:(BOOL)animated{
    if (self.title.length) {
        NSLog(@"开始路径%@->%@ -> %s",NSStringFromClass(self.class),self.title,__func__);
//        [MobClick beginLogPageView:self.title];
    }
    [self as_viewWillAppear:animated];
}

- (void)as_viewWillDisappear:(BOOL)animated{
    if (self.title.length) {
        NSLog(@"结束路径%@->%@ -> %s",NSStringFromClass(self.class),self.title,__func__);
//        [MobClick endLogPageView:self.title];
    }
    [self as_viewWillDisappear:animated];
}










- (UIBarButtonItem *)backButtonIsBlack:(BOOL)isBlack
{
    return [[UIBarButtonItem alloc] initWithCustomView:[self buttonOfBackButtonIsBlack:isBlack]];
}

- (UIButton *)buttonOfBackButtonIsBlack:(BOOL)isBlack
{
    UIImage *img = [UIImage imageNamed:@"navi_back"];
    if (isBlack) img = [[UIImage imageNamed:@"navi_back"] imageWithColor:[UIColor blackColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
    [button setImage:img forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor c_mainBackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10.f, 0, 0);
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.height = 44.0f;
    button.width = iPW(100);
    return button;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)backBarButtonPressed:(id)backBarButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBackButton
{
    self.navigationItem.leftBarButtonItems = @[[self backButtonIsBlack:NO]];
}

- (void)addBackNilButton
{
    self.navigationItem.leftBarButtonItems = @[];
}

//- (void)addTheMeColorTitle:(NSString *)titileName
//{
//    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160,44)];
//    titleView.text = titileName;
//    titleView.textAlignment = 1;
//    titleView.font = MZ_RegularFont(18);
//    titleView.textColor = [UIColor mz_themeColor];
//    self.navigationItem.titleView = titleView;
//}

+ (UIViewController *)visibleViewController {
    UIViewController *rootViewController = [KWindow rootViewController];
    return [UIViewController getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [[self class] getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [[self class] getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else if ([vc isKindOfClass:[MainTabBarVC class]]) {
        JJTabBarController *tabar = (JJTabBarController *) vc.tabBarController;
        UIViewController *vcd = tabar.selectedTabBarChild;
        return [[self class] getVisibleViewControllerFrom:vcd];
    }else {
        if (vc.presentedViewController) {
            return [[self class] getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

-(void)addPsuhVCAnimationFromTop{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [actions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addAction:obj];
    }];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITabBarController *tabBarController  = (UITabBarController *)(window.rootViewController);
    UINavigationController *currentNavigationController = tabBarController.selectedViewController;
    [currentNavigationController.visibleViewController presentViewController:alert animated:YES completion:nil];
}



-(void)setHidenLeftTaBar:(BOOL)hidenLeftTaBar
{
    
    [UserDataManager sharedManager].frame_width =  hidenLeftTaBar ? KScreenWidth:(KScreenWidth -KTabar_Width);
    MainTabBarVC *tabar = (MainTabBarVC *)KWindow.rootViewController;
     tabar.tabBarController.hiddenTabBar = hidenLeftTaBar;
    self.view.width = hidenLeftTaBar ? KScreenWidth:(KScreenWidth -KTabar_Width);

    NSLog(@"<<<<%@>>>>=========>%f",NSStringFromClass([self class]),[UserDataManager sharedManager].frame_width );
}




@end
