//
//  MZQiNiuManager.h
//  Scanner
//
//  Created by edz on 2020/7/8.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZSendProgressView.h"

#define MZQiNiuManager_FieldName @"doctor"

@interface MZQiNiuManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, copy) void(^currenProgressBlock)(CGFloat progress);

- (void)uploadImagesWithDataArray:(NSMutableArray *)array withProgressView:(MZSendProgressView *)progressView completion:(void(^)(BOOL success, NSMutableArray *paths))block;

- (void)uploadImageWithData:(NSData *)imageData completion:(void(^)(BOOL success, NSString *fileUrl))block;

- (void)uploadImageWithData:(NSData *)imageData name:(NSString *)name completion:(void(^)(BOOL success, NSString *fileUrl))block;

- (void)uploadVideoData:(NSData *)video completion:(void(^)(BOOL success, NSString *fileUrl))block;

//上传文件
- (void)uploadFiledWithData:(NSData *)imageData fileName:(NSString *)fileName fileTypeStr:(NSString *)fileTypeStr completion:(void(^)(BOOL success, NSString *fileUrl))block;

@end
