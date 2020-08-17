//
//  RRNetWorkingManager.h
//  Scanner
//
//  Created by rrdkf on 2020/6/20.
//  Copyright © 2020 Occipital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@class RrResponseModel;

typedef void (^OnResponseBlock)(RrResponseModel *response);

typedef void (^ResultBlock)(NSDictionary *dict, RrResponseModel *responseModel, NSError *error);//完全的结果


@interface RrResponseResultBlockModel : NSObject

@property (nonatomic, strong) ResultBlock resultBlock;

@property (nonatomic, strong) NSString *classString;

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end
static inline RrResponseResultBlockModel * ResultBlockMake(ResultBlock  _Nonnull resultBlock, Class _Nonnull objetClass) {
    
    RrResponseResultBlockModel *blockModel = [[RrResponseResultBlockModel alloc]init];
    blockModel.resultBlock = resultBlock;
    blockModel.classString = NSStringFromClass(objetClass);
    return blockModel;
}

static inline NSString * XYQueryStringFromParametersWithEncoding(NSString *path, NSDictionary *parameters) {
  
    if (!parameters) {
        return path;
    }
    
    NSMutableArray *mutablePairs = [NSMutableArray arrayWithCapacity:0];
    NSArray *allKeys = [parameters allKeys];
    for (NSString *key in allKeys) {
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,[parameters objectForKey:key]];
        [mutablePairs addObject:string];
    }
    return [path stringByAppendingString:[NSString stringWithFormat:@"?%@",[mutablePairs componentsJoinedByString:@"&"]]];
}







@interface RRNetWorkingManager : NSObject

+ (instancetype)sharedSessionManager;

- (void)cancelAllOperations_all;

@property (nonatomic, copy) OnResponseBlock responseBlock;

- (NSString *)AntDevice;

- (void)initializeManager;

- (void)updateDeviceInfo;

- (void)setToken:(NSString *)token;


// isBasicToken 是否用公共 token
- (RrResponseResultBlockModel *)GETBasicToken:(BOOL)isBasicToken URLString:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock;

- (RrResponseResultBlockModel *)POSTBasicToken:(BOOL)isBasicToken URLString:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock;


- (RrResponseResultBlockModel *)GET:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock;

- (RrResponseResultBlockModel *)R:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock method:(NSString *)method;

- (RrResponseResultBlockModel *)POST:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock;

- (RrResponseResultBlockModel *)PATCH:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock ;

- (RrResponseResultBlockModel *)DELETE:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock;

- (RrResponseResultBlockModel *)PUT:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock;
@end

NS_ASSUME_NONNULL_END
