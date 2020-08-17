//
//  RrDidProductDeTailModel.m
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrDidProductDeTailModel.h"
@implementation RrDidProductDeTailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"AactualReceipts":@"actualReceipts"};
}

-(void)setTotalFee:(NSString *)totalFee{
    _totalFee = [NSString stringWithFormat:@"%.2f",[totalFee floatValue]];
}

-(void)setPayType:(NSNumber *)payType{ //支付方式:1在线支付，2线下支付
    _payType = payType;
    if ([payType intValue] == 1) {
        self.payTypeStr = @"线上支付";
    }else if ([payType intValue] == 2){
        self.payTypeStr = @"线下支付";
    }
}


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
            self.orderStatus_Str = @"待加工分配";
            break;
        case 5:
            self.orderStatus_Str = @"待制作";
            break;
        case 6:
            self.orderStatus_Str = @"制作完成";
            break;
        case 7:
            self.orderStatus_Str = @"完成";
            break;
            
        default:
            break;
    }
    
}

@end
