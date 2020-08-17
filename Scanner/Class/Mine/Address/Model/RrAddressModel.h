//
//  RrAddressModel.h
//  Scanner
//
//  Created by edz on 2020/7/15.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrAddressModel : NSObject
@property (nonatomic, strong) NSNumber *areaCode; //id
@property (nonatomic, copy)   NSString *areaName;// 名称
@property (nonatomic, copy)   NSString *treeNames;
@property (nonatomic, strong) NSNumber *areaType;
@property (nonatomic, copy)   NSString *createDate;
@property (nonatomic, copy)   NSString *updateDate;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSArray<RrAddressModel*> *item;

@end

NS_ASSUME_NONNULL_END
