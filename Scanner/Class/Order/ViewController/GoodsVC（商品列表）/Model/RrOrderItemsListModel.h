//
//  RrOrderItemsListModel.h
//  Scanner
//
//  Created by edz on 2020/7/17.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrOrderItemsListModel : NSObject

@property (nonatomic, copy)   NSString *ID; // 主键
@property (nonatomic, copy)   NSString *name; // 商品名称
@property (nonatomic, copy)   NSString *productCode;// 产品编码
@property (nonatomic, strong) NSNumber *status;//产品状态：1：上架，0:下架
@property (nonatomic, copy)   NSString *productPrice;//产品价格
@property (nonatomic, copy)   NSString *productAbstract;//适应病症-商品简介
@property (nonatomic, copy)   NSString *Description;//产品描述
@property (nonatomic, copy)   NSString *icon; // 图片Icon的url
@end

NS_ASSUME_NONNULL_END
