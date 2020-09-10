//
//  AppDelegate.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "AppDelegate.h"
#import "OrderViewController.h"
#import "LoginVC.h"
#import "MainTabBarVC.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
//#import <LLDebug.h>

#import "RrLonginModel.h"
#import "RrAgreementView.h"
#import "RrMineMessageModel.h"
#import "CheckUserInfoVC.h"
#import "RrMineOrderListDetailVC.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) LoginVC *login;
@property (nonatomic, strong) MainTabBarVC *tabarVc;

@end

@implementation AppDelegate

- (LoginVC *)login{
    if (!_login) {
        _login = [LoginVC new];
    }
    return _login;
}
- (MainTabBarVC *)tabarVc{
    if (!_tabarVc) {
        _tabarVc = [MainTabBarVC new];
    }
    return _tabarVc;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
#ifdef DEBUG
//    [[LLDebugTool sharedTool] startWorkingWithConfigBlock:^(LLConfig * _Nonnull config) {}];
#else
#endif
    if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:-100];
    //    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor redColor];
    //    [IQKeyboardManager sharedManager].toolbarBarTintColor = [UIColor yellowColor];
    //屏幕 横向设置
    [application.delegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.window];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    if (![RrUserDataModel isLogin] || ![TZUserDefaults getBoolValueInUDWithKey:KUserDefaul_Key_agreement]) {
        self.window.rootViewController = [[LXNavigationController alloc] initWithRootViewController: self.login];
    }else{
        self.window.rootViewController = self.tabarVc;
    }
    
    [self.window makeKeyAndVisible];
    
    //用户协议提示框。放到rootViewController进程的最后
    [RrAgreementView showAgreementView];
    
    //极光推送
    [self jPushInit];
    
    /**
     *  友盟统计配置
     */
    [LXObjectTools initUMConfig];


    
    
    [LXObjectTools getAppVersionUrl];


    
    
    return YES;
    
    
}

//// 极光初始化
- (void)jPushInit
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:nil appKey:KJPUSH_AppKey
                          channel:@"test"
                 apsForProduction:0
            advertisingIdentifier:nil];
}


//屏幕 横向设置
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return UIInterfaceOrientationMaskLandscapeRight;
}


#pragma mark- JPUSHRegisterDelegate 极光推送

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self ReceiveNotificationResponsePushToVCWithDict:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}

//自动获取数据 更新
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
//    [self ReceiveNotificationResponsePushToVCWithDict:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, For systems with less than or equal to iOS 6
//    [self ReceiveNotificationResponsePushToVCWithDict:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
}


// 注册 APNs 成功并上报 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

// 实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)networkDidLogin:(NSNotification *)notification {
    
}


//点击App图标，使App从后台恢复至前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    KPostNotification(KNotification_name_EnterForeground, nil);
}



//按Home键使App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

//接收推送结果
- (void)ReceiveNotificationResponsePushToVCWithDict:(NSDictionary *)userInfo{
    if ([RrUserDataModel isLogin]) {
       typeJsonMdoel *model =  [typeJsonMdoel mj_objectWithKeyValues:[userInfo valueForKey:@"msgJson"]];
        [typeJsonMdoel patchMessageUrlWithID:model.ID];//标为已读
        UIViewController *vc =[UIViewController visibleViewController];
      
        if ([model.type isEqualToString:@"AUDIT_SUCCESS"] ||
            [model.type isEqualToString:@"AUDIT_FAIL"]) {// 关联代理商审核成功, //AUDIT_FAIL关联代理商审核失败
            CheckUserInfoVC *userVc =[CheckUserInfoVC new];
            userVc.title = @"个人资料";;
            userVc.type = CheckUserInfoVCType_push;
            [vc.navigationController pushViewController:userVc animated:YES];
            
        }else if([model.type isEqualToString:@"ORDERS_DELIVERY"] ||
                 [model.type isEqualToString:@"ORDERS_REJECTED"] ||
                 [model.type isEqualToString:@"ORDERS_THROUGH"]) {//订单发货 //ORDERS_REJECTED订单审核驳回 //ORDERS_THROUGH订单审核通过
            KPostNotification(KNotification_name_updateOrder_list, nil);
            RrMineOrderListDetailVC *detailVc =[RrMineOrderListDetailVC new];
            detailVc.outTradeNo = model.prod;
            [vc.navigationController pushViewController:detailVc animated:YES];
        }
        
     }
}


@end
