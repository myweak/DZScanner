//
//  RrUserDataModel.m
//  Scanner
//
//  Created by edz on 2020/7/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrUserDataModel.h"
#import "RrLonginModel.h"
@implementation RrUserDataModel


static dispatch_once_t onceToken;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
    
}

- (void)setStatus:(NSNumber *)status{
    _status = status;
    self.statusType = [status integerValue];
}

- (BOOL)isCompany{
    if (checkStrEmty(self.companyCode)) {
        return NO;
    }
    if (self.statusType == withInfoSuccess) {
        return YES;
    }
    return NO;
}



+(instancetype)sharedDataModel
{
    static RrUserDataModel *singleton = nil;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [[RrUserDataModel alloc] init];
    });
    return singleton;
}

Rr_CopyWithZone

Rr_CodingImplementation


- (void)saveUserData{
    NSLog(@"用户保存成功...");
    [RrUserDataModel sharedDataModel].userModel = self;
    NSLog(@"%@",aUser.name);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData  * userData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:userData forKey:KUserDataTitle];
    [defaults synchronize];
}

+ (RrUserDataModel *)readUserData {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData         * userData = [defaults objectForKey:KUserDataTitle];
    if (userData) {
        RrUserDataModel * User = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [RrUserDataModel sharedDataModel].userModel = User;
        return User;
    }
    else
        return nil;
}
- (void)removeUserData{
    NSLog(@"aUser用户数据删除成功...");
    _userModel = nil;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:KUserDataTitle];
    [self clear];
    [defaults synchronize];
}
- (RrUserDataModel *)userModel{
    if (_userModel == nil) {
        _userModel = [RrUserDataModel readUserData];
    }
    return _userModel;
}
- (void)clear {
    onceToken   = 0;
}



+ (BOOL)isLogin{
    
    //status 工作人员 ( 0 基本信息待审核， 1 基本信息审核通过，2 基本信息被驳回 3 完整信息待审核  4完整信息审核通过， 5 完整信息被驳回 关联经销商待审核，7 关联经销商审核通过，8 关联经销商被驳回)
    RrUserDataModel *model = [RrUserDataModel sharedDataModel].userModel;
    CheckStatusType userStatus =  model.statusType;
    if (userStatus == firstInfoSuccess ||
        userStatus == infoCheckSuccee ||
        userStatus == withInfoing ||
        userStatus == withInfoSuccess ||
        userStatus == withInfoUnSuccess) {
        if (checkStrEmty([[RrLonginModel sharedDataModel].loginModel access_token])) {
            return NO;
        }
        return YES;
    }
    return NO ;
}


//获取个人信息
+ (void)updateUserInfo{
    [[RrUserDataModel sharedDataModel] updateUserDataInfoUrlWithBlock:nil];
}
- (void)updateUserDataInfoUrlWithBlock:(void (^)(BOOL success,RrUserDataModel *model, RrResponseModel *responseModel))block
{
     NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
       [parameter setValue:[RrUserTypeModel readUserData].userId forKey:@"doctorInfoId"];
    
    [[RRNetWorkingManager sharedSessionManager] getUserInfo:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            RrUserDataModel *model = (RrUserDataModel *)responseModel.item;
            [model saveUserData];
            !block ?: block(!error,model,responseModel);
        }else{
            !block ?: block(!error,nil,responseModel);
        }
    }, [RrUserDataModel class])];
}





@end
