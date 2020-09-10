//
//  RrMineOrderListModel.m
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineOrderListModel.h"

@implementation RrMineOrderListModel

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

- (void)setOrderStatus:(NSNumber *)orderStatus{
    _orderStatus = orderStatus;
    
    switch ([orderStatus intValue]) {
        case 0:
            self.orderStatus_Str = @"已取消";
            break;
        case 1:
            self.orderStatus_Str = @"待完善";
            break;
        case 2:
            self.orderStatus_Str = @"待审核";
            break;
        case 3:
            self.orderStatus_Str = @"待付款";
            break;
        case 4:
            self.orderStatus_Str = @"加工分配";
            break;
        case 5:
            self.orderStatus_Str = @"待制作";
            break;
        case 6:
            self.orderStatus_Str = @"制作完成";
            break;
        case 7:
            self.orderStatus_Str = @"已完成";
            break;
            
        default:
            break;
    }
    
}

- (void)setTotalFee:(NSString *)totalFee{
    _totalFee = [NSString stringWithFormat:@"%.2f",[totalFee floatValue]];
}


@end
