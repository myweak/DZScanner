//
//  LXObjectTools.h
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BackBlock)(id obj1,id obj2);

NS_ASSUME_NONNULL_BEGIN

@interface LXObjectTools : NSObject

@property (nonatomic, copy)  BackBlock backBlock;

+(instancetype)sharedManager;

- (void)tapAddPhotoImageBlock:(BackBlock) block; // 添加头像

+(void)getAppVersionUrl; //检查版本更新

//更新选择地址 plist 表
- (void)updateAddressUrlPlist;


+ (NSArray *)getRrDBaseUrlArr; // 方便测试用 域名切换

//清除app缓存
+ (void)clearAppAllCache;
//获取app缓存大小
+ (CGFloat)getAppCacheAllSize;

@end

NS_ASSUME_NONNULL_END
