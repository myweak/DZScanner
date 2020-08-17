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
        if (error) {
//            [[UIViewController visibleViewController] AlertWithTitle:@"温馨提示" message:<#(NSString *)#> andOthers:<#(NSArray<NSString *> *)#> animated:<#(BOOL)#> action:<#^(NSInteger index)click#>];
        }
    }, nil)];
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
