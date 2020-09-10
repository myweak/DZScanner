//
//  RRNetWorkingManager+URL.m
//  Scanner
//
//  Created by rrdkf on 2020/6/21.
//  Copyright © 2020 Occipital. All rights reserved.
//

#import "RRNetWorkingManager+URL.h"

@implementation RRNetWorkingManager (URL)

- (void)getQiNiuImageUrl:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/public/qiniu/uptoken" parameters:parameter result:resultBlock];
}

- (void)login:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POSTBasicToken:YES URLString:@"/api-uaa/oauth/user/token" parameters:parameter result:resultBlock];
}
- (void)codeLogin:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/api-uaa/oauth/code/token" parameters:parameter result:resultBlock];
}
- (void)updateUserType:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/worker/staff/login" parameters:parameter result:resultBlock];
}

- (void)outLogin:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/api-uaa/oauth/remove/token" parameters:parameter result:resultBlock];
}



- (void)getCode:(id)parameter basicToken:(BOOL)isBasicToken result:(RrResponseResultBlockModel *)resultBlock{
//    [self GET:@"/api-uaa/register/send" parameters:parameter result:resultBlock];
    [self GETBasicToken:isBasicToken URLString:@"/api-uaa/register/send" parameters:parameter result:resultBlock];
}

- (void)getUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/worker/staff" parameters:parameter result:resultBlock];
}
- (void)postRegister:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/api-uaa/register/user" parameters:parameter result:resultBlock];
}

- (void)postChangeWord:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POSTBasicToken:YES URLString:@"/api-uaa/register/reset" parameters:parameter result:resultBlock];
}

- (void)postUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/staff/reg" parameters:parameter result:resultBlock];
}

- (void)patchChangeUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self PATCH:@"/dz-service/worker/staff" parameters:parameter result:resultBlock];
}

- (void)POSTNextCheckUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/staff/reAudit" parameters:parameter result:resultBlock];
}



- (void)getAssociated:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/worker/staff/associated" parameters:parameter result:resultBlock];
}

//- (void)getCodeCheck:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
//    [self GET:@"/api-uaa/register/code/check" parameters:parameter result:resultBlock];
//}

- (void)getCodeCheck:(id)parameter basicToken:(BOOL)isBasicToken result:(RrResponseResultBlockModel *)resultBlock{
//    [self GET:@"/api-uaa/register/send" parameters:parameter result:resultBlock];
    [self GETBasicToken:isBasicToken URLString:@"/api-uaa/register/code/check" parameters:parameter result:resultBlock];
}




//--------------------商品类----star--------------------------------------------------


- (void)getGoodsCategory:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/public/category/" parameters:parameter result:resultBlock];
}
- (void)postProductList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/product/list" parameters:parameter result:resultBlock];
}

- (void)getProductDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/worker/product" parameters:parameter result:resultBlock];
}


- (void)postOrderDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/addr" parameters:parameter result:resultBlock];
}

- (void)postChckeOrderDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/order" parameters:parameter result:resultBlock];
}

- (void)postUserOrderList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/order/list" parameters:parameter result:resultBlock];
}

- (void)getUserChckeOrderDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/worker/order" parameters:parameter result:resultBlock];
}

- (void)putOrderPayNotifi:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self PUT:@"/dz-service/worker/order/remind" parameters:parameter result:resultBlock];
}

- (void)changeOrderStatus:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self PATCH:@"/dz-service/worker/order" parameters:parameter result:resultBlock];
}

- (void)postOrderPayImg:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/payImg" parameters:parameter result:resultBlock];
}




//--------------------商品类----end--------------------------------------------------

- (void)postAddGoodsAddress:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/addr" parameters:parameter result:resultBlock];
}


- (void)postScanSource:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/scanSource" parameters:parameter result:resultBlock];
}
- (void)postScanSourceList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/scanSource/list" parameters:parameter result:resultBlock];
}

- (void)deleteScanSource:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self DELETE:@"/dz-service/worker/scanSource" parameters:parameter result:resultBlock];
}
- (void)changeScanSource:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self PATCH:@"/dz-service/worker/scanSource" parameters:parameter result:resultBlock];
}





/**
 获取所有的省份 市区 地址

 */
- (void)getProvinceListAdderss:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz/public/addr/area" parameters:parameter result:resultBlock];
}

- (void)getAddressList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock
{
    [self GET:@"/dz-service/worker/addr/list" parameters:parameter result:resultBlock];
}

- (void)deleteAdressList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;
{
    [self DELETE:@"/dz-service/worker/addr" parameters:parameter result:resultBlock];
}
- (void)putCahngeAdressList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self PUT:@"/dz-service/worker/addr" parameters:parameter result:resultBlock];
}

- (void)getJPushDeviceID:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/worker/user/device" parameters:parameter result:resultBlock];
}


- (void)getMessageList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GET:@"/dz-service/worker/user/msg" parameters:parameter result:resultBlock];
}

- (void)patchMessage:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self PATCH:@"/dz-service/worker/user/msg" parameters:parameter result:resultBlock];
}

- (void)postSuggesiont:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self POST:@"/dz-service/worker/feedback" parameters:parameter result:resultBlock];
}


- (void)getAppVersion:(id)parameter result:(RrResponseResultBlockModel *)resultBlock{
    [self GETBasicToken:YES URLString:@"/common/appVersion/update"  parameters:parameter result:resultBlock];
}


@end
