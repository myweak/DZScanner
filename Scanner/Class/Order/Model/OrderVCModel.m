//
//  OrderVCModel.m
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "OrderVCModel.h"

@implementation OrderVCModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"items" : [OrderVCModel class]};
}

@end
