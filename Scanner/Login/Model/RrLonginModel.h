//
//  RrLonginModel.h
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrLonginModel : NSObject

@property (nonatomic, copy) NSString * access_token; // 凭证token
@property (nonatomic, copy) NSString * token_type;
@property (nonatomic, copy) NSString * refresh_token; // 当 access_token 过期 可以用 refresh_token
@property (nonatomic, copy) NSString * expires_in;
@property (nonatomic, copy) NSString * scope;

@property (nonatomic, strong) RrLonginModel *loginModel;// 当前model数据

+(instancetype)sharedDataModel;


- (void)removeUserData;


+ (RrLonginModel *)readUserData;


- (void)saveUserData;

@end

NS_ASSUME_NONNULL_END
