//
//  AppModel.h
//  Scanner
//
//  Created by edz on 2020/8/18.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppModel : NSObject
@property (nonatomic, copy)   NSString *ID;
@property (nonatomic, copy)   NSString *appid;
@property (nonatomic, copy)   NSString *appName;//对应应用名称
@property (nonatomic, copy)   NSString *alertImage;//弹窗图片
@property (nonatomic, copy)   NSString *context;//版本内容说明
@property (nonatomic, copy)   NSString *device;//对应设备
@property (nonatomic, strong) NSNumber *forceType;//是否强制更新，默认 否0 >> 否1 >> 是
@property (nonatomic, copy)   NSString *url;//下载地址
@property (nonatomic, copy)   NSString *version;//版本号
@property (nonatomic, strong) NSNumber *status;

//{
//  "code": 200,
//  "msg": "操作成功",
//  "data": {
//    "id": 5,
//    "appid": null,
//    "appName": "辅具IOS",
//    "alertImage": "",
//    "version": 1,
//    "context": "更新内容",
//    "forceType": 0,
//    "url": "www.baidu.com",
//    "device": "IOS",
//    "status": 1,
//    "md5": "asadasd"
//  }
//}

@end

NS_ASSUME_NONNULL_END
