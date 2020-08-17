//
//  RrDefine.h
//  Scanner
//
//  Created by rrdkf on 2020/6/20.
//  Copyright © 2020 Occipital. All rights reserved.
//

#ifndef RrDefine_h
#define RrDefine_h

#ifdef DEBUG
#define LXLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define MZLog(...)
#else
#define LXLog(...)
#endif

#define WEAKSELF __weak typeof(self) weakSelf = self;//弱引用
#define WEAK_SELF(weakSelf) __weak __typeof(&*self) weakSelf = self;
#define STRONG_SELF(strongSelf) __strong __typeof(&*weakSelf) strongSelf = weakSelf;
//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//图片
#define R_ImageName(imagName)  [UIImage imageNamed:imagName]



#define WkkeeperErrorUserInfoKey @"WkkeeperErrorUserInfoKey"
#define WkkeeperErrorDomain @"WkkeeperErrorDomain"

#define KNotificationReload3DVCData @"reload3DVCData"







typedef NS_ENUM(NSInteger, WkkeeperErrorCode) {
    WkkeeperCommonError = 1000,
    WkkeeperLoginError =  1001,
    WkkeeperDataError =  2001,
};

#endif /* RrDefine_h */
