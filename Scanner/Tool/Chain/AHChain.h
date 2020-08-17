//
//  AHChain.h
//  AntHouse
//
//  Created by Nathan Ou on 2018/2/1.
//  Copyright © 2018年 Nathan Ou. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString * DeviceUUIDKey = @"uuid_chain";

@interface AHChain : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong) NSDictionary *chainData;

@end
