//
//  UserDataManager.h
//  Scanner
//
//  Created by rrdkf on 2020/6/29.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDataManager : NSObject

@property (nonatomic, assign) CGFloat frame_width;



+(instancetype)sharedManager;
- (void)psuhLoginVC;
- (void)deleteAllUserInfo; // 清除用户数据
+ (void)deleteJPUSHServiceAlias; // 清除极光

+ (void)registJPUSHServiceAlias; // 极光 Alia 别名
@end

NS_ASSUME_NONNULL_END
