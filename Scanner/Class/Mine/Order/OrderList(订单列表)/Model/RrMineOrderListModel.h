//
//  RrMineOrderListModel.h
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrMineOrderListModel : NSObject
@property (nonatomic, copy)   NSString *outTradeNo;//订单编号
@property (nonatomic, copy)   NSString *actualReceipts;//支付金额
@property (nonatomic, copy)   NSString *totalFee;//订单金额
@property (nonatomic, strong) NSNumber *orderStatus;//订单状态
@property (nonatomic, copy)   NSString *trackingNumber;//快递单号
@property (nonatomic, copy)   NSString *express;//快递公司
@property (nonatomic, copy)   NSString *transactionId;//交易编号
@property (nonatomic, copy)   NSString *createTime;//订单创建时间
@property (nonatomic, copy)   NSString *productName;//商品名称
@property (nonatomic, copy)   NSString *productIcon;//商品图片
@property (nonatomic, copy)   NSString *patientName;//工作人员姓名
@property (nonatomic, copy)   NSString *patientPhone;//工作人员手机号
@property (nonatomic, strong) NSNumber *payType;//支付方式:1在线支付，2线下支付
@property (nonatomic, copy)   NSString *productCode;//商品编码

// ----
@property (nonatomic, copy)   NSString *orderStatus_Str;//订单状态 str

/// 进入倒计时
@property (nonatomic, assign) BOOL timePut;
@end

/**
 orderStatus
 CANCEL("已取消", 0),
 WAIT_PERFECTED("待完善", 1),
 WAIT_AUDITED("待审核", 2),
 WAIT_PAY("待支付", 3),
 WAIT_PROCESS("待加工分配", 4),
 WAIT_MAKE("待制作", 5),
 MAKE_COMPLETE("制作完成", 6),
 COMPLETE("完成", 7),
 */

NS_ASSUME_NONNULL_END
