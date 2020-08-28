//
//  LXObjectTools.m
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "LXObjectTools.h"
#import "AreaPickerView.h"
#import "MZAvatarImagePicker.h"
#import "RrLonginModel.h"
#import <SDImageCache.h>
#import  <EGOCache/EGOCache.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "AppModel.h"
@interface LXObjectTools ()<OTAvatarImagePickerDelegate>
@end
@implementation LXObjectTools

+(instancetype)sharedManager
{
    static LXObjectTools *singleton = nil;
    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [[LXObjectTools alloc] init];
    });
    return singleton;
}


+ (NSArray *)getRrDBaseUrlArr{
#ifdef DEBUG
    return @[@"",
             @"https://dev.goto-recovery.com",
             @"https://uat.goto-recovery.com",
             @"https://api.rrdkf.com",
    ];
#else
    return @[@"https://api.rrdkf.com"];
#endif
}

+ (CGFloat)getAppCacheAllSize{
    SDImageCache *cache = (SDImageCache *)[[SDWebImageManager sharedManager] imageCache];
    NSInteger  size = [cache totalDiskSize];
    NSInteger  disk = [cache totalDiskCount];
    
    CGFloat  LaoxiaoScanSise = [LaoxiaoScan getFolderNameOfSize];
    CGFloat  LaoXiaoEGOCacheSize = [LaoXiaoEGOCache getFolderNameOfSize];
    
    CGFloat imageSize = (size +disk)/(1024*1024);
    CGFloat cacheSize = imageSize + LaoxiaoScanSise +LaoXiaoEGOCacheSize;
    
    return cacheSize;
}
+ (void)clearAppAllCache{
    [[EGOCache globalCache] clearCache];
    [LaoxiaoScan clearFolderNameAtCache];
    [LaoXiaoEGOCache clearFolderNameAtCache];
    SDImageCache *cache = (SDImageCache *)[[SDWebImageManager sharedManager] imageCache];
    ///  清除内存缓存
    [cache clearMemory];
    [cache clearDiskOnCompletion:^{
    }];
    
    
}


// 更新地址url 省市区
- (void)updateAddressUrlPlist{
    
    //    [RWPromise promise:^(ResolveHandler resolve, RejectHandler reject) {
    //        resolve(@"1");
    //    }].then(^id(id value){
    //        NSLog(value);
    //        return @"2";
    //    }).catch(^(NSError* e){
    //        NSLog(@"error");
    //    }).then(^id(id value){
    //        NSLog(value);
    //        return nil;
    //    });
    
    
    [[RRNetWorkingManager sharedSessionManager] getProvinceListAdderss:nil result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            NSArray *arr = responseModel.data;
            [AreaPickerView saveArrayToData:arr];
        }
    }, nil)];
    
}

+ (void)getAppVersionUrl{
    [[LXObjectTools sharedManager] getAppVersionUrl];
}
- (void)getAppVersionUrl{
    NSString *device =[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"IOS" :@"IPAD";
    [[RRNetWorkingManager sharedSessionManager] getAppVersion:@{KKey_1:device} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            AppModel *model = (AppModel*)responseModel.item;
            NSArray *btnArr = @[@"不更新",@"马上更新"];
            NSString *versionStr = [[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"] appVersionNumberFormat];
            NSString *app_Version = [versionStr appVersionNumberFormat];
            NSString * version = [model.version appVersionNumberFormat];
            if (![version containsOnlyNumbers]) {
                return;
            }
            if ([version floatValue] <= [app_Version floatValue]) {
                return;
            }
            if ([model.forceType intValue] == 1) { //强制升级
                btnArr = @[@"马上更新"];
            }else{
                NSString *versionKey = [NSString stringWithFormat:@"版本%@",model.version];
                if ([RrUserDefaults getBoolValueInUDWithKey:versionKey]) {
                    return;
                }
                [RrUserDefaults saveBoolValueInUD:YES forKey:versionKey];
            }
            [[UIViewController visibleViewController] AlertWithTitle:[NSString stringWithFormat:@"\"%@\"新版本通知",model.appName] message:model.context andOthers:btnArr animated:YES action:^(NSInteger index) {
                if ([btnArr[index] isEqualToString:@"马上更新"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url] options:nil completionHandler:^(BOOL success) {
                        exit(0);
                    }];
                }
            }];
        }
    }, [AppModel class])];
}

+ (void)initUMConfig{
#ifdef DEBUG
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setLogEnabled:YES];
    //开发者需要显式的调用此函数，日志系统才能工作
#else
#endif
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    UMConfigInstance.appKey = KUM_AppKey;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:version];
    [MobClick setCrashReportEnabled:YES];//打开奔溃报告
    
    
}


//--------头像选择相片-------------star-----------------------------------------------------------------

- (void)tapAddPhotoImageBlock:(BackBlock) block{
    self.backBlock = [block copy];
    [[[MZActionSheetView alloc]initWithActionSheetWithTitle:nil ListArray:@[@"从相册中选择图片",@"使用照相机"] completeSelctBlock:^(NSInteger selectIndex) {
        [self topHeadactionSheetIndexAction:selectIndex];
    }] show] ;
}

#pragma mark - AddHdeadImage
- (void)topHeadactionSheetIndexAction:(NSInteger)selectIndex
{
    if (selectIndex == 1) {
        // 拍照
        [MZAvatarImagePicker sharedInstance].canEdit = NO;
        [MZAvatarImagePicker sharedInstance].shouldSave = YES;
        [[MZAvatarImagePicker sharedInstance] setDelegate:nil];
        [[MZAvatarImagePicker sharedInstance] setDelegate:self];
        [[MZAvatarImagePicker sharedInstance] getImageFromCameraInIphone:[UIViewController visibleViewController]];
    }else
        
        if (selectIndex == 0) {
            // 手机相册
            [MZAvatarImagePicker sharedInstance].canEdit = NO;
            [[MZAvatarImagePicker sharedInstance] setDelegate:nil];
            [[MZAvatarImagePicker sharedInstance] setDelegate:self];
            [[MZAvatarImagePicker sharedInstance] getImageFromAlbumInIphone:[UIViewController visibleViewController]];
        }
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - OTAvataDelegate
////////////////////////////////////////////////////////////////////////////////////

- (void)getImageFromWidget:(UIImage *)image
{
    
    UIImage *zipedImage = [image zipImageWithSize:CGSizeMake(500, 500)];
    @weakify(self);
    [[MZQiNiuManager shareManager] uploadImageWithData:UIImageJPEGRepresentation(zipedImage,0.7) name:MZQiNiuManager_FieldName completion:^(BOOL success, NSString *fileUrl) {
        @strongify(self)
        if (success) {
            !self.backBlock ? :self.backBlock(fileUrl.imageUrlStr,zipedImage);
        }else{
            showTopMessage(@"图片加载失败");
        }
    }];
    
}



//---------------------end-----------------------------------------------------------------




@end
