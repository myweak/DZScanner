//
//  RrResponseModel.m
//  Scanner
//
//  Created by rrdkf on 2020/6/20.
//  Copyright © 2020 Occipital. All rights reserved.
//

#import "RrResponseModel.h"

@implementation RrResponseModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{@"pageData":@"message"};
//}
//+ (NSDictionary *)mj_objectClassInArray{
//    return @{ @"5" : [RrAddressModel class]};
//}

- (NSString *)msg{
//    if (!_msg) {
//        return self.error.msg;
//    }
    if (_msg != nil && ![_msg hasChinese]) {
        return @"服务异常 -_-!";;
    }
    return _msg;
}
- (NSNumber*)code{
    if (_code) {
        return _code;
    }
    return self.error.code ? : self.error.status;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{
//             @"pageData" : @"data"//前边的是你想用的key，后边的是返回的key
//             };
//}

@end




//  json 转模型。
@implementation RrBaseModel






@end


@implementation RrDataPageModel

@end


@implementation RrErrorModel

@end
