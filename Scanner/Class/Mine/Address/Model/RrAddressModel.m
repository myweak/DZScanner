//
//  RrAddressModel.m
//  Scanner
//
//  Created by edz on 2020/7/15.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrAddressModel.h"

@implementation RrAddressModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"item" : [RrAddressModel class]};
}


- (NSString *)areaName{
    if (checkStrEmty(_areaName)) {
        return @"";
    }
    return _areaName;
    
}

@end
