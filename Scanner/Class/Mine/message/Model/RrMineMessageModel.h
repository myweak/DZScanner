//
//  RrMineMessageModel.h
//  Scanner
//
//  Created by edz on 2020/8/7.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface typeJsonMdoel : NSObject
/**
 AUDIT_SUCCESS, 关联代理商审核成功,
 AUDIT_FAIL, 关联代理商审核失败
 ORDERS_DELIVERY, 订单发货
 ORDERS_REJECTED, 订单审核驳回
 ORDERS_THROUGH, 订单审核通过
 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy)   NSString *prod;//对应的商品或者跳转的值
@property (nonatomic, copy)   NSString *ID;//消息ID


//表示未已读
+(void)patchMessageUrlWithID:(NSString *)ID;
+(void)patchMessageUrlWithID:(NSString *)ID succeesBlock:(void(^)(BOOL succee)) block;
@end


//--------------------------------------------------------------------

@interface RrMineMessageModel : NSObject
@property (nonatomic, copy)   NSString *ID;//消息ID
@property (nonatomic, copy)   NSString *userId;//用户ID
@property (nonatomic, strong) NSNumber *msgStatus;//0 未读 1 已读
@property (nonatomic, copy)   NSString *createTime;//创建时间
@property (nonatomic, copy)   NSString *content;//消息内容
@property (nonatomic, strong) typeJsonMdoel *typeJson;
@end

NS_ASSUME_NONNULL_END
