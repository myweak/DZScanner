//
//  DataModelPCH.h
//  Scanner
//
//  Created by rrdkf on 2020/6/21.
//  Copyright © 2020 Occipital. All rights reserved.
//

#ifndef DataModelPCH_h
#define DataModelPCH_h

#define KUserTypeTitle  @"用户状态"
#define KUserDataTitle  @"用户数据"
#define KLoginDataTitle @"登陆数据"
#define KNaViTabarTitle @"左边标签栏"

//通知
#define KNotification_name_Scan                     @"3D扫描上传成功"
#define KNotification_name_updateOrder_list         @"更新订单列表通知"
#define KNotification_name_EnterForeground          @"pp从后台恢复至前台"


//TZUserDefaults Key
#define KUserDefaul_Key_agreement                   @"用户隐藏政策弹框!"
#define KUserDefaul_Key_search_product              @"商品搜索"
#define KUserDefaul_Key_search_order                @"订单搜索"
#define KUserDefaul_Key_search_scanfield            @"3D扫描文件搜索"


//缓存标识
static  NSString * const KisAddEGOCache_Key    =    @"KisAddEGOCacheKey";
static  NSString * const KisAddEGOCache_value  =    @"加此字典表示此地址需要缓存数据";


//get请求不用拼接key，只要求value 顺序
static const NSString * KKey_1  = @"get_Key_Key1";
static const NSString * KKey_2  = @"get_Key_Key2";
static const NSString * KKey_3  = @"get_Key_Key3";
static const NSString * KKey_4  = @"get_Key_Key4";
static const NSString * KKey_5  = @"get_Key_Key5";

#define aUser [RrUserDataModel sharedDataModel].userModel  //用户信息

//商品
#define KPlaceholderImage_product R_ImageName(@"product_placeholder")



static NSString *const kAlphaNum        = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";


#endif /* DataModelPCH_h */
