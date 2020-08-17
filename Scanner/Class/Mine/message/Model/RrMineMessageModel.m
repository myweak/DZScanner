//
//  RrMineMessageModel.m
//  Scanner
//
//  Created by edz on 2020/8/7.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineMessageModel.h"

@implementation RrMineMessageModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end





@implementation typeJsonMdoel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
//表示未已读
+(void)patchMessageUrlWithID:(NSString *)ID{
    [typeJsonMdoel patchMessageUrlWithID:ID succeesBlock:nil];
}
+(void)patchMessageUrlWithID:(NSString *)ID succeesBlock:(void(^)(BOOL succee)) block{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:ID forKey:@"id"];
    [[RRNetWorkingManager sharedSessionManager] patchMessage:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            !block ? :block(YES);
        }
    }, nil)];
}

@end
