//
//  RrUserTypeModel.m
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrUserTypeModel.h"

@implementation RrUserTypeModel

static dispatch_once_t onceToken;


- (void)setStatus:(NSNumber *)status{
    _status = status;
    self.statusType = [status integerValue];
    }

+(instancetype)sharedDataModel
{
    static RrUserTypeModel *singleton = nil;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [[RrUserTypeModel alloc] init];
    });
    return singleton;
}

Rr_CopyWithZone

Rr_CodingImplementation


- (void)saveUserData{
    NSLog(@"用户类型保存成功...");
    [RrUserTypeModel sharedDataModel].userModel = self;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData  * userData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:userData forKey:KUserTypeTitle];
    [defaults synchronize];
}

+ (RrUserTypeModel *)readUserData {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData         * userData = [defaults objectForKey:KUserTypeTitle];
    if (userData) {
        RrUserTypeModel * User = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [RrUserTypeModel sharedDataModel].userModel = User;
        return User; 
    }
    else
        return nil;
}
- (void)removeUserData{
    NSLog(@"用户类型数据删除成功...");
    _userModel = nil;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:KUserTypeTitle];
    self.status = nil;
    [self clear];
    [defaults synchronize];
}
- (RrUserTypeModel *)userModel{
    if (_userModel == nil) {
        _userModel = [RrUserTypeModel  readUserData];
    }
    return _userModel;
}
- (void)clear {
    onceToken   = 0;
}



- (void)updateUserTypeUrlWithBlock:(void (^)(BOOL success,RrUserTypeModel *model))block
{
    
    [[RRNetWorkingManager sharedSessionManager] updateUserType:nil result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            RrUserTypeModel *model = (RrUserTypeModel *)responseModel.item;
            [model saveUserData];
            !block ?: block(!error,model);
        }else{
            !block ?: block(!error,nil);
        }
    }, [RrUserTypeModel class])];
}


//+ (BOOL)isLogin{
//    
//    //status 工作人员 ( 0 基本信息待审核， 1 基本信息审核通过，2 基本信息被驳回 3 完整信息待审核  4完整信息审核通过， 5 完整信息被驳回 关联经销商待审核，7 关联经销商审核通过，8 关联经销商被驳回)
//    RrUserTypeModel *model = [RrUserTypeModel sharedDataModel].userModel;
//    CheckStatusType userStatus =  model.statusType;
//    if (userStatus == firstInfoSuccess ||
//        userStatus == infoCheckSuccee ||
//        userStatus == withInfoing ||
//        userStatus == withInfoSuccess ||
//        userStatus == withInfoUnSuccess) {
//        return YES;
//    }
//    return NO ;
//}






@end
