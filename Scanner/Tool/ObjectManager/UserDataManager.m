//
//  UserDataManager.m
//  Scanner
//
//  Created by rrdkf on 2020/6/29.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "UserDataManager.h"
#import "LoginVC.h"
#import "JPUSHService.h"
#import "RrLonginModel.h"
@interface UserDataManager()
@property (nonatomic, assign) BOOL nextPush;
@end
@implementation UserDataManager
+(instancetype)sharedManager
{
    static UserDataManager *singleton = nil;
    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [[UserDataManager alloc] init];
    });
    return singleton;
}

- (CGFloat)frame_width{
    if (_frame_width <=0) {
        
        _frame_width = [[UIScreen mainScreen] bounds].size.width;

    }
    return _frame_width;
}


- (void)psuhLoginVC{
    UIViewController *vc = [UIViewController visibleViewController];
    if ([vc isKindOfClass:[LoginVC class]]) {
        return;
    }
    LoginVC *log = [LoginVC new];
    [log addPsuhVCAnimationFromTop];
    
    [UserDataManager deleteJPUSHServiceAlias];

  if ([KWindow.rootViewController isKindOfClass:[MainTabBarVC class]]) {//已进入主页面
      [vc setHidenLeftTaBar:YES];
      [vc.navigationController pushViewController:log animated:NO];
  }else{
       [vc.navigationController pushViewController:log animated:NO];
  }
}

+ (void)registJPUSHServiceAlias{
    [UserDataManager registJPUSHServiceAliasNext:YES];
}
// 防止设备绑定失败。重新连接一次
+ (void)registJPUSHServiceAliasNext:(BOOL)isNext{
    // 注册极光推送
    [JPUSHService setAlias:aUser.ID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"打印设置别名iResCode=%ld, iAlias=%@, seq=%ld", iResCode, iAlias, seq);
        if (iResCode == 0) {
            NSLog(@"添加别名成功");
            if (isNext) {
                [[UserDataManager sharedManager] getJPushDeviceIDUrlNext:NO];
            }
        }else{
            [UserDataManager registJPUSHServiceAliasNext:NO];
        }
    } seq: 2020];
    
   
    
}
+ (void)deleteJPUSHServiceAlias{
    [UserDataManager deleteJPUSHServiceAliasNext:YES];
}
+ (void)deleteJPUSHServiceAliasNext:(BOOL)isNext{
    　[JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode != 0) {
            if (isNext) {
                [UserDataManager deleteJPUSHServiceAliasNext:NO];
            }
        }
      } seq:2020];
}

- (void)getJPushDeviceIDUrlNext:(BOOL)isNext{
    NSString *deviceId =  [JPUSHService registrationID];
     [[RRNetWorkingManager sharedSessionManager] getJPushDeviceID:@{KKey_1:deviceId} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
         if (error) {
             NSLog(@"设备绑定失败");
             if (isNext) {
                 [UserDataManager registJPUSHServiceAliasNext:NO];
             }
         }
     }, nil)];
}



- (void)deleteAllUserInfo{
    //退出的时候删除别名
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            NSLog(@"删除别名成功");
        }
    } seq:1];
    [[RrLonginModel sharedDataModel] removeUserData];
    [[RrUserTypeModel sharedDataModel] removeUserData];
    [[RrUserDataModel sharedDataModel] removeUserData];
}

@end
