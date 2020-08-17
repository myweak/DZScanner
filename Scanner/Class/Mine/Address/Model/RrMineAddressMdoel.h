//
//  RrMineAddressMdoel.h
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrMineAddressMdoel : NSObject
@property (nonatomic, copy)   NSString *ID;
@property (nonatomic, copy)   NSString *consignee;//收货人
@property (nonatomic, copy)   NSString *doctorId; // 工作人员ID
@property (nonatomic, copy)   NSString *phone; // 收货电话
@property (nonatomic, strong) NSNumber *defaultAddr; // 是否设置为默认收货地址0否1是
@property (nonatomic, strong) NSNumber *provinceId;//省id
@property (nonatomic, copy)   NSString *provinceDesc; // 省描述
@property (nonatomic, strong) NSNumber *cityId; // 市ID
@property (nonatomic, copy)   NSString *cityDesc; // 市描述
@property (nonatomic, strong) NSNumber *areaId; //区ID
@property (nonatomic, copy)   NSString *areaDesc; // 区描述
@property (nonatomic, copy)   NSString *addrDetail; // 详细地址
@end

NS_ASSUME_NONNULL_END
