//
//  RrUserDataModel.h
//  Scanner
//
//  Created by edz on 2020/7/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RrMineAddressMdoel.h"
NS_ASSUME_NONNULL_BEGIN


@interface RrUserDataModel : NSObject <NSCopying>// 业务工作人员的id

@property (nonatomic, copy)   NSString *ID;//id
@property (nonatomic, copy)   NSString *name;//用户姓名
@property (nonatomic, copy)   NSString *headimg;//头像
@property (nonatomic, copy)   NSString *account;//账号
@property (nonatomic, strong) NSNumber *sex; // 性别，1为男性，2为女性，0是未知
@property (nonatomic, strong) NSNumber *titleId;//职称编号
@property (nonatomic, copy)   NSString *title;//职称
@property (nonatomic, strong) NSNumber *hospitalId;//医院编号
@property (nonatomic, copy)   NSString *hospital;//工作单位
@property (nonatomic, strong) NSNumber *deptId;//科室编号
@property (nonatomic, copy)   NSString *dept;//所在部门
@property (nonatomic, copy)   NSString *certimg;//从业资格图片URL
@property (nonatomic, copy)   NSString *comment;//备注内容
@property (nonatomic, copy)   NSString *phone;//手机号
/*
 状态， 0 基本信息待审核， 1 基本信息审核通过，2 基本信息被驳回 3 完整信息待审核  完整信息审核通过， 5 完整信息被驳回 关联经销商待审核，7 关联经销商审核通过，8 关联经销商被驳回"
 */
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy)   NSString *remark;//备注信息，如审核被拒原因
@property (nonatomic, copy)   NSString *provinceId;//省ID
@property (nonatomic, copy)   NSString *provinceDesc;// 省描述
@property (nonatomic, copy)   NSString *cityId;//市ID
@property (nonatomic, copy)   NSString *cityDesc;//市描述
@property (nonatomic, copy)   NSString *areaId;//区ID
@property (nonatomic, copy)   NSString *areaDesc;//区描述
@property (nonatomic, copy)   NSString *companyCode;//关联经销商号


//添加 status 转化
@property (nonatomic, assign) CheckStatusType statusType;
@property (nonatomic, readonly,assign) BOOL isCompany; // 是否关联通过


//xiao
@property (nonatomic, strong) RrUserDataModel *userModel;// 当前model数据
@property (nonatomic, strong) RrMineAddressMdoel *userAddressMdoel;// 用户选择下单地址model数据


+(instancetype)sharedDataModel;
// 清空用户数据
- (void)removeUserData;
//读取用户数据
+ (RrUserDataModel *)readUserData;
// 保存用户数据
- (void)saveUserData;

//获取个人信息
- (void)updateUserDataInfoUrlWithBlock:(void (^)(BOOL success,RrUserDataModel *model, RrResponseModel *responseModel))block;
+ (void)updateUserInfo;

// 是否登陆
+ (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
