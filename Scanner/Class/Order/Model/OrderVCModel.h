//
//  OrderVCModel.h
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface OrderVCModel : NSObject
@property (nonatomic, copy)   NSString *ID; // 主键Id
@property (nonatomic, copy)   NSString *name; // 分类名称
@property (nonatomic, strong) NSNumber *levelNo;//级别
@property (nonatomic, strong) NSNumber *orderNo;//排序号
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy)   NSString *typeMark;

@property (nonatomic, strong) NSArray <OrderVCModel *>*items; //

@end

NS_ASSUME_NONNULL_END
