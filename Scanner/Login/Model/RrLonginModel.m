//
//  RrLonginModel.m
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrLonginModel.h"

static dispatch_once_t onceToken;
@implementation RrLonginModel


+(instancetype)sharedDataModel
{
    static RrLonginModel *singleton = nil;
    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [[RrLonginModel alloc] init];
    });
    return singleton;
}


Rr_CodingImplementation


- (void)saveUserData{
    NSLog(@"登陆保存成功...");
    [RrLonginModel sharedDataModel].loginModel = self;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData  * userData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:userData forKey:KLoginDataTitle];
    [defaults synchronize];
}

+ (RrLonginModel *)readUserData {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData         * userData = [defaults objectForKey:KLoginDataTitle];
    if (userData) {
        RrLonginModel * User = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [RrLonginModel sharedDataModel].loginModel = User;
        return User;
    }
    else
        return nil;
}
- (void)removeUserData{
    NSLog(@"登陆数据删除成功...");
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:KLoginDataTitle];
    _loginModel = nil;
    self.access_token = @"";
    [self clear];
    [defaults synchronize];
}
- (RrLonginModel *)loginModel{
    if (_loginModel == nil) {
        _loginModel = [RrLonginModel  readUserData];
    }
    return _loginModel;
}

- (void)clear {
    onceToken   = 0;
}

@end
