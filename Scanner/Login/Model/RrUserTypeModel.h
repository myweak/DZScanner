//
//  RrUserTypeModel.h
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

typedef NS_ENUM(NSInteger,CheckStatusType) {
    firstInfoing = 0, // 0 基本信息待审核
    firstInfoSuccess, // 1 基本信息审核通过
    firstinfoUnSuceess, // 2 基本信息被驳回
    infoChecking, // 3 完整信息待审核
    infoCheckSuccee, // 4 完整信息审核通过
    infoCheckUnSuccess, // 5 完整信息被驳回
    withInfoing, // 6 关联经销商待审核
    withInfoSuccess, // 7 关联经销商审核通过
    withInfoUnSuccess, // 8关联经销商被驳回
    noUserInfo, // 9 用户审核资料没有填写
};


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrUserTypeModel : NSObject

@property (nonatomic, strong) NSNumber * userCenterId;//用户中心ID
@property (nonatomic, strong) NSNumber * userType;// 用户类型 1-经销商 2-加工商 3-工作人员 4-管理员
@property (nonatomic, strong) NSNumber * status;//status 工作人员 ( 0 基本信息待审核， 1 基本信息审核通过，2 基本信息被驳回 3 完整信息待审核 4 完整信息审核通过， 5 完整信息被驳回 6关联经销商待审核， 7关联经销商审核通过，8 关联经销商被驳回) // 9 用户审核资料没有填写
@property (nonatomic, copy) NSString * userId;//工作人员ID // 业务工作人员的id

//
@property (nonatomic, assign) CheckStatusType statusType;

@property (nonatomic, strong) RrUserTypeModel *userModel;// 当前model数据

+(instancetype)sharedDataModel;
// 清空用户数据
- (void)removeUserData;
//读取用户数据
+ (RrUserTypeModel *)readUserData;
// 保存用户数据
- (void)saveUserData;

- (void)updateUserTypeUrlWithBlock:(void (^)(BOOL success,RrUserTypeModel *model))block;

//+ (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
