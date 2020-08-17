//
//  ScanFileModel.h
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanFileModel : NSObject
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, copy)   NSString *fileName;
@property (nonatomic, copy)   NSString *imgFilePath;
@property (nonatomic, copy)   NSString *zipFilePath;
@property (nonatomic, copy)   NSString *stlFile;
@property (nonatomic, copy)   NSString *addTime;


@property (nonatomic, copy)   NSString *updateTime;//更新时间
@property (nonatomic, copy)   NSString *ID;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *preview;//预览图url
@property (nonatomic, copy)   NSString *sourceUrl;//资源URL
@property (nonatomic, copy)   NSString *createTime;//创建时间
@end

NS_ASSUME_NONNULL_END
