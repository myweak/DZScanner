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




@end

NS_ASSUME_NONNULL_END
