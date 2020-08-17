//
//  RRNetWorkingManager+URL.h
//  Scanner
//
//  Created by rrdkf on 2020/6/21.
//  Copyright © 2020 Occipital. All rights reserved.
//

#import "RRNetWorkingManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRNetWorkingManager (URL)

/**
 上传七牛/阿里云 -- image
 
 @param parameter parameter description
 */
- (void)getQiNiuImageUrl:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  用户注册

 */
- (void)postRegister:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;



/**
 登陆
 
 @param parameter
 */
- (void)login:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
 手机验证码登陆
 
 @param parameter phone code
 */
- (void)codeLogin:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
手机忘记密码

@param parameter  phone code password
*/
- (void)postChangeWord:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
  工作人员角色状态信息获取
 
 @param parameter <#parameter description#>
 */
- (void)updateUserType:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  发送注册验证码

 @param parameter /{phone}/{type}type: 1 注册短信 2 忘记密码 3 登录验证码
 */
//- (void)getCode:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;
- (void)getCode:(id)parameter basicToken:(BOOL)isBasicToken result:(RrResponseResultBlockModel *)resultBlock;
/**
 验证码校验

@param parameter{code}/{phone}
*/
//- (void)getCodeCheck:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;
- (void)getCodeCheck:(id)parameter basicToken:(BOOL)isBasicToken result:(RrResponseResultBlockModel *)resultBlock;
/**
  获取用户信息

 @param parameter doctorInfoId
 */
- (void)getUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
  工作人员审核资料提交


 */
- (void)postUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
  工作人员信息更新

 */
- (void)patchChangeUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  提交工作人员信息 被拒--》 再次提交审核资料

 */
- (void)POSTNextCheckUserInfo:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
 工作人员绑定经销商

@param /{companyCode}/{staffId}
*/
- (void)getAssociated:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;



//--------------------商品类----star--------------------------------------------------


/**
  获取所有商品分类
    parameter {id}
 */
- (void)getGoodsCategory:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
  商品列表

 */
- (void)postProductList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
  商品详情

 */
- (void)getProductDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


///**
// 提交订单 订单详情
//
//*/
//- (void)postOrderDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  提交订单

*/
- (void)postChckeOrderDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
  订单详情
 
 parameter:    outTradeNo 订单号(String)

*/
- (void)getUserChckeOrderDetail:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
订单列表

*/
- (void)postUserOrderList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
工作人员重新给用户推送待支付订单
 parameter:    outTradeNo 订单号(String)

*/
- (void)putOrderPayNotifi:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
取消订单或者确认订单或者完善订单
 parameter:
 outTradeNo 订单号(String)
 orderStatus=0  取消订单
 orderStatus=2  完善测量数据
 orderStatus=7  确认收货

*/
- (void)changeOrderStatus:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
提交支付凭证
 parameter:    actualReceipts payImg outTradeNo

*/
- (void)postOrderPayImg:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

//--------------------商品类----end--------------------------------------------------


/**
 保存3d素材扫描

*/
- (void)postScanSource:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
 分页获取数据-vijay 3D扫描

*/
- (void)postScanSourceList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
 根据ID删除数据-vijay 3D扫描

*/
- (void)deleteScanSource:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
 修改名称 3D扫描

*/
- (void)changeScanSource:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  添加收货地址

 */
- (void)postAddGoodsAddress:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  获取地址列表

 */
- (void)getAddressList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  删除收货地址

 */
- (void)deleteAdressList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
  修改收货地址

 */
- (void)putCahngeAdressList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;





/**
 获取所有的省份 市区 地址

 */
- (void)getProvinceListAdderss:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;


/**
用户绑定设备

*/
- (void)getJPushDeviceID:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
用户消息列表

*/
- (void)getMessageList:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;
/**
消息设置为已读

*/
- (void)patchMessage:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
保存反馈

*/
- (void)postSuggesiont:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

/**
app获取版本更新
 device  :   IOS

*/
- (void)getAppVersion:(id)parameter result:(RrResponseResultBlockModel *)resultBlock;

@end

NS_ASSUME_NONNULL_END
