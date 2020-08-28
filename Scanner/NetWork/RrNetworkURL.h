//
//  RrNetworkURL.h
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#ifndef RrNetworkURL_h
#define RrNetworkURL_h


//=========================================================================
#ifdef DEBUG // 加Debug宏，两层约束，免得遗忘关闭
    #define Test_Env  1  // 测试宏
#endif
//-----
#ifdef Test_Env

//    static NSString *const RrDBaseUrl = @"https://dev.goto-recovery.com";  //开发式服
    // 主域名
      static NSString *const RrDBaseUrl = @"https://uat.goto-recovery.com";

//      static NSString *const RrDBaseUrl = @"http://192.168.2.31:30000";//模拟dev


//生产环境
//    static NSString * const RrDBaseUrl = @"https://api.rrdkf.com";

#else
//----------------------------生产环境star--------------------------------
//static NSString *const RrDBaseUrl = @"https://uat.goto-recovery.com";

static NSString * const RrDBaseUrl = @"https://api.rrdkf.com";
//-----------------------------end-------------------------------

#endif

static NSString *const QiNiuBaseUrl = @"https://image2.rrdkf.com/"; // 七牛固定地址

//=========================================================================






static NSString *const Kprivacy   = @"https://rrdkf.com/about/privacy"; //   隐私政策
static NSString *const Kagreement = @"https://rrdkf.com/about/agreement"; //   协议



static NSString *const KUM_AppKey    = @"5f2bb525d309322154758608"; //   友盟apppkey
static NSString *const KJPUSH_AppKey = @"779344a5810fac17349dd36f"; //   极光 appkey

static NSString *const LaoXiaoEGOCache = @"LaoXiaoEGOCache"; //   ego 缓存文件名
static NSString *const LaoxiaoScan =     @"LaoxiaoScan"; //   3d文件保存文件名



#define SRrDBaseUrl                 @"切换域名"


#endif /* RrNetworkURL_h */
