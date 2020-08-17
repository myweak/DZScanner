//
//  RrResponseModel.h
//  Scanner
//
//  Created by rrdkf on 2020/6/20.
//  Copyright © 2020 Occipital. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@class RrRequestModel;

@interface RrErrorModel : NSObject

@property (nonatomic, strong)   NSNumber *code;

@property (nonatomic, strong)   NSNumber *status;

@property (nonatomic, strong)     NSString  *msg;

@property (nonatomic, strong)     NSString  *detail;

@end



@protocol RrBaseModel;

@interface RrDataPageModel : NSObject

@property (nonatomic, strong) NSNumber *current;

@property (nonatomic, strong) NSNumber *hitCount;

@property (nonatomic, strong) NSNumber *pages;

@property (nonatomic, strong) NSNumber *size;

@property (nonatomic, strong) NSNumber *total; //总数

@property (nonatomic, strong) NSArray *records; //数据

@end




/// 转模型。model
@interface RrBaseModel : NSObject

@end


@protocol RrDataPageModel;

@interface RrResponseModel : NSObject

@property (nonatomic, strong) RrErrorModel  *error;

@property (nonatomic, strong) RrDataPageModel  *pageData;

@property (nonatomic, strong) NSNumber *code;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, assign) BOOL isCashEQO;

@property (nonatomic, strong) id   data;

@property (nonatomic, strong) RrBaseModel  *item;

@property (nonatomic, strong) NSMutableArray <RrBaseModel> *list;

@end

NS_ASSUME_NONNULL_END
