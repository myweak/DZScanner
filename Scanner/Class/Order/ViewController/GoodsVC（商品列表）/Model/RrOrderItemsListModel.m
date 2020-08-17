//
//  RrOrderItemsListModel.m
//  Scanner
//
//  Created by edz on 2020/7/17.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderItemsListModel.h"

@implementation RrOrderItemsListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"ID":@"id",
        @"Description":@"description",
    };
}

- (void)setProductPrice:(NSString *)productPrice{
    _productPrice = [NSString stringWithFormat:@"%.2f",[productPrice floatValue]];
}

@end
