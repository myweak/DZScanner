//
//  RRNetWorkingManager.m
//  Scanner
//
//  Created by rrdkf on 2020/6/20.
//  Copyright © 2020 Occipital. All rights reserved.
//

#define KDefineToken  @"ZHotc2VydmljZTouZHpTZXJ2aWNlOmZlMGI1NzgyZjM4ZDRkNmNiOTZiZGY4NWI1YjNkMjEz"

#define KEGO_Key  [NSString stringWithFormat:@"%@%@%@",aUser.ID,urlString,[parameters mj_JSONString]]

#import "RRNetWorkingManager.h"
#import <AFNetworking/AFNetworking.h>
#import "RrResponseModel.h"
//#import "RrPushManager.h"
#import "AHChain.h"
#import <sys/utsname.h>
//#import "XYResponseCache.h"
#import "RrUserTypeModel.h"
#import "RrLonginModel.h"
#import  <EGOCache/EGOCache.h>



NSString *const RequestHasError = @"RequestHasError";

static NSInteger RequestHasErrorCode = 10001;

NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


@implementation RrResponseResultBlockModel

@end



@interface RRNetWorkingManager()

@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSString *baseUrlString;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) NSDictionary *headerDict;

@property (nonatomic, strong) EGOCache *egocache ; // 缓存

@end

@implementation RRNetWorkingManager


+ (instancetype)sharedSessionManager {
    
    static RRNetWorkingManager *staticSessionManaer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        staticSessionManaer = [[self alloc]init];
    });
    
    return staticSessionManaer;
}

- (instancetype)init {
    
    if (self = [super init])
    {
        self.lock = [[NSLock alloc]init];
        self.egocache = [[EGOCache globalCache] initWithCacheDirectory:[self createCacheDirection]];
        //设置缓存时间 默认时间一天  一天的时间表示：24*60*60
        self.egocache.defaultTimeoutInterval = 24*60*60 *2;
        
        [self initializeManager];
    }
    return self;
}



- (void)initializeManager {
    
    [self.lock lock];
    
    self.headerDict = @{@"Authorization":@"Basic ZHotc2VydmljZTouZHpTZXJ2aWNlOmZlMGI1NzgyZjM4ZDRkNmNiOTZiZGY4NWI1YjNkMjEz"};
    
#ifdef DEBUG // 开发环境设置
    NSString *url = [RrUserDefaults getStrValueInUDWithKey:SRrDBaseUrl];
    self.baseUrlString = checkStringIsEmty(url) ? RrDBaseUrl:url;
#else
    self.baseUrlString = RrDBaseUrl;
#endif
    
    
    
    if (![self.baseUrlString isEqualToString:self.sessionManager.baseURL.absoluteString]) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 30;
        configuration.timeoutIntervalForResource = 30;
        self.sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:self.baseUrlString] sessionConfiguration:configuration];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"text/html",@"text/plain",@"image/tiff", @"image/jpeg", @"image/jpg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap",@"application/json", @"image/x-win-bitmap",nil];
//        self.sessionManager
        
        //无条件的信任服务器上的证书
        //        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 客户端是否信任非法证书 如果是需要服务端验证证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        self.sessionManager.securityPolicy = securityPolicy;
        
        [self setToken:[RrLonginModel readUserData].access_token];
        
    }
    
    [self.lock unlock];
}

- (void)cancelAllOperations_all{
    [self.sessionManager.operationQueue cancelAllOperations];
}

- (void)updateDeviceInfo
{
    
}


/*
 vendor,model,system,device_id,token,software
 */
static NSString *AntDeviceKey = @"Ant-Device";

- (NSString *)AntDevice {
    
    NSString *Software = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *uuid = [AHChain shareManager].chainData[DeviceUUIDKey];
    NSString *antDivice = [NSString stringWithFormat:
                           @"vendor:%@|model:%@|system:%@|deviceId:%@|token:%@|software:%@",@"Apple",
                           deviceName(),
                           [UIDevice currentDevice].systemVersion,
                           uuid,
                           [RrLonginModel readUserData].access_token,
                           //                           @"",
                           Software
                           ];
    return antDivice;
}

//将 parameters 拼接到 urlString
- (NSString *)urlWithParameters:(NSDictionary *)parameters url:(NSString *)urlString{
    //---------------------
    NSDictionary *dict = (NSDictionary *)parameters;
    NSArray *keyArr = [dict allKeys];
    keyArr = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
    NSComparisonResult result = [obj1 compare:obj2];
    return result==NSOrderedDescending;
    }];
    NSMutableString *Str = [[NSMutableString alloc] initWithString:urlString];
    for (NSString *key_str in keyArr) {
        if ([key_str isEqualToString:KisAddEGOCache_Key]) {
            continue;
        }
        NSString *pp = @"/";
        [Str appendFormat:@"%@%@",pp,[parameters valueForKey:key_str]];
    }
    return [Str stringWithoutSpaceAndEnter];
    //----------------------
}


// isBasicToken 是否用公共 token
- (RrResponseResultBlockModel *)GETBasicToken:(BOOL)isBasicToken URLString:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock  {
    
    //加载缓存的
    //    NSString *path = XYQueryStringFromParametersWithEncoding(urlString, parameters);
    //    id cahcedData = [XYResponseCache cachedResponseWithPath:path];
    //    if (cahcedData) {
    //        [self parseRusltWithData:cahcedData result:resultBlock];
    //    }
    
    @try {
        [self.sessionManager.requestSerializer setValue:[self AntDevice] forHTTPHeaderField:AntDeviceKey];
        if (isBasicToken) {
            [self setToken:@""];
        }else{
            [self setToken:[RrLonginModel readUserData].access_token];
        }
        
    }
    
    @catch(NSException *e) { }
    //---------------------
    urlString = [self urlWithParameters:parameters url:urlString];
    //----------------------
    return [self R:urlString parameters:parameters result:resultBlock method:@"GET"];
}

- (RrResponseResultBlockModel *)POSTBasicToken:(BOOL)isBasicToken URLString:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock{
    @try {
          [self.sessionManager.requestSerializer setValue:[self AntDevice] forHTTPHeaderField:AntDeviceKey];
        if (isBasicToken) {
            [self setToken:@""];
        }else{
            [self setToken:[RrLonginModel readUserData].access_token];
        }
          
      }
      
      @catch(NSException *e) { }
      
      return [self R:urlString parameters:parameters result:resultBlock method:@"POST"];
}


- (RrResponseResultBlockModel *)GET:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock  {
    return  [self GETBasicToken:NO URLString:urlString parameters:parameters result:resultBlock];
}

- (RrResponseResultBlockModel *)POST:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock {
    return  [self POSTBasicToken:NO URLString:urlString parameters:parameters result:resultBlock];
}

- (RrResponseResultBlockModel *)PATCH:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock {
    
    @try {
        [self.sessionManager.requestSerializer setValue:[self AntDevice] forHTTPHeaderField:AntDeviceKey];
        [self setToken:[RrLonginModel readUserData].access_token];
        
    }
    
    @catch(NSException *e) { }
    
    
    return [self R:urlString parameters:parameters result:resultBlock method:@"PATCH"];
}

- (RrResponseResultBlockModel *)DELETE:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock
{
    
    @try {
        [self.sessionManager.requestSerializer setValue:[self AntDevice] forHTTPHeaderField:AntDeviceKey];
        [self setToken:[RrLonginModel readUserData].access_token];
        
    }
    
    @catch(NSException *e) { }
    
    urlString = [self urlWithParameters:parameters url:urlString];
    
    //----------------------
    
    return [self R:urlString parameters:parameters result:resultBlock method:@"DELETE"];
}

- (RrResponseResultBlockModel *)PUT:(NSString *)urlString parameters:(id)parameters result:(RrResponseResultBlockModel *)resultBlock
{
    
    @try {
        [self.sessionManager.requestSerializer setValue:[self AntDevice] forHTTPHeaderField:AntDeviceKey];
        [self setToken:[RrLonginModel readUserData].access_token];
        
    }
    
    @catch(NSException *e) { }
    
    
    return [self R:urlString parameters:parameters result:resultBlock method:@"PUT"];
}

- (RrResponseResultBlockModel *)R:(NSString *)urlString parameters:(id)parameters
                           result:(RrResponseResultBlockModel *)resultBlock  method:(NSString *)method  {
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject)  =  [self analyzeDataWithSuccessCallBack:resultBlock path:urlString parameters:parameters method:method];
    void (^failBlock)(NSURLSessionDataTask *task, id responseObject)  =  [self analyzeDataWithfailureCallBack:resultBlock path:urlString parameters:parameters method:method];
    
    NSString *url = urlString;
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setValue:[self AntDevice] forKey:AntDeviceKey];
    
    if ([method isEqualToString: @"GET"]) {
        
        resultBlock.task = [self.sessionManager GET:urlString parameters:parameters
                                            headers:header
                                           progress:NULL
                                            success:successBlock
                                            failure:failBlock];
        
    }
    else if ([method isEqualToString: @"POST"]) {
        
        resultBlock.task = [self.sessionManager POST:urlString parameters:parameters headers:header progress:NULL success:successBlock failure:failBlock];
    } else if ([method isEqualToString: @"PUT"]) {
        
        resultBlock.task = [self.sessionManager PUT:urlString parameters:parameters
                                            headers:header
                                            success:successBlock
                                            failure:failBlock];
    } else if ([method isEqualToString: @"PATCH"]) {
        
        resultBlock.task = [self.sessionManager PATCH:url
                                           parameters:parameters
                                              headers:header
                                              success:successBlock
                                              failure:failBlock];
    } else if ([method isEqualToString: @"DELETE"]) {        
        
        resultBlock.task = [self.sessionManager DELETE:url
                                            parameters:NULL
                                               headers:header
                                               success:successBlock
                                               failure:failBlock];
    }
    
    return resultBlock;
}

- (void (^)(NSURLSessionDataTask *task, id responseObject)) analyzeDataWithSuccessCallBack:(RrResponseResultBlockModel *)result path:(NSString *)urlString parameters:(id)parameters method:(NSString *)method {
    
    NSString *str = [self.egocache stringForKey:KEGO_Key];
    NSDictionary *dict = [str mj_JSONObject];
    if (dict) {
        NSLog(@"🌞🌞🌞EGO🌞");
        [self parseRusltWithData:dict result:result];
    }
    
    WEAKSELF
    return ^(NSURLSessionDataTask *taskB, id responseObjectB) {
        if (result) {
            
            NSError *jsonModelError = nil;
            RrResponseModel *responseModel = nil;
            
            
            @try {
                responseModel = [RrResponseModel mj_objectWithKeyValues:responseObjectB];
                id data = responseModel.data;
                NSInteger status = responseModel.code.integerValue;
                
                NSLog(@"urlString-->%@\n parameters-->%@\n responseObjectB🌞\n%@\n🌞🌞",urlString,parameters,responseObjectB);
                
                if (status == 200 && [[parameters allKeys] containsObject:KisAddEGOCache_Key]) {
                    //缓存数据
                    [self.egocache setString:[responseObjectB mj_JSONString] forKey:KEGO_Key];
                    
                }
                
                
                if (status == 401) { // token 过期 -->重新登陆
                    showMessage(@"登陆过期");
                    [[UserDataManager sharedManager] psuhLoginVC];
                }
                
                //状态码为200成功
                if (status != 200) {
                    NSMutableDictionary *userInfoNew = nil;
                    if (responseModel) {
                        result.resultBlock(responseObjectB, responseModel ,[NSError new]);
                        userInfoNew = [NSMutableDictionary dictionaryWithCapacity:0];
                        [userInfoNew setObject:responseModel forKey:WkkeeperErrorUserInfoKey];
                    }
                    @throw [NSException exceptionWithName:RequestHasError reason:@"数据错误"
                                                 userInfo:userInfoNew];
                }
                NSHTTPURLResponse *responseHttp = (NSHTTPURLResponse *)taskB.response;
                NSDictionary *header = responseHttp.allHeaderFields;
                NSString *bearerToen = header[@"Authorization"];
                
                
                //                if (bearerToen.length) {
                //                    bearerToen = [bearerToen stringByReplacingOccurrencesOfString:@"Bearer " withString:@""];
                //                    //  token 为 空。重新登陆
                //                    if (bearerToen.length) {
                ////                        NSNumber *uid = [NADefaults sharedDefaults].currentMemberId;
                ////                        [[RrLoginManager sharedManager] updateToken:bearerToen forUser:uid memberModel:nil];
                //                    }
                //                }
                
                
                
                if (result.classString.length) {
                    Class modelClass = NSClassFromString(result.classString);
                    if ([data isKindOfClass:[NSArray class]]) {
                        responseModel.list = (NSMutableArray <RrBaseModel> *) [modelClass mj_objectArrayWithKeyValuesArray:data];
                    } else {
                        //包含 分页数组字段 orders 和 分页 总数量 total 、分页pages 判定为分页模型
                        if ([[responseModel.data allKeys] containsObject:@"orders"] && [[responseModel.data allKeys] containsObject:@"total"] &&
                            [[responseModel.data allKeys] containsObject:@"pages"]) {
                            responseModel.pageData = [RrDataPageModel mj_objectWithKeyValues:data];
                            if (responseModel.pageData.records) {
                                responseModel.list = (NSMutableArray <RrBaseModel> *) [modelClass mj_objectArrayWithKeyValuesArray:responseModel.pageData.records];
                            }
                        }else{
                            responseModel.item =  [modelClass mj_objectWithKeyValues:data];
                        }
                    }
                }
                
            }
            @catch(NSException *e){
                jsonModelError = [NSError errorWithDomain:e.name code:RequestHasErrorCode userInfo:e.userInfo];
            }
            
            if (jsonModelError) {
                @try {
                    NSString *url = [taskB.currentRequest.URL absoluteString];
                    NSLog(@"URL=%@,Error=%@",url,[jsonModelError mj_JSONString]);
                }@catch(NSException *e){}
            }
            responseModel.isCashEQO = NO;
            result.resultBlock(responseObjectB, responseModel ,jsonModelError);
            
            if (weakSelf.responseBlock) {
                weakSelf.responseBlock(responseModel);
            }
        }
    };
}


//数据解析
- (void)parseRusltWithData:(id)responseObjectB result:(RrResponseResultBlockModel *)result {
    
    NSError *jsonModelError = nil;
    RrResponseModel *responseModel = nil;
    @try {
        responseModel = [RrResponseModel mj_objectWithKeyValues:responseObjectB];
        id data = responseModel.data;
        NSInteger status = responseModel.code.integerValue;
        
        if (status == 401) { // token 过期 -->重新登陆
            [[UserDataManager sharedManager] psuhLoginVC];
        }
        //状态码为200成功
        if (status != 200) {
            NSMutableDictionary *userInfoNew = nil;
            if (responseModel) {
                userInfoNew = [NSMutableDictionary dictionaryWithCapacity:0];
                [userInfoNew setObject:responseModel forKey:WkkeeperErrorUserInfoKey];
            }
            @throw [NSException exceptionWithName:RequestHasError reason:@"数据错误"
                                         userInfo:userInfoNew];
        } else {
            if (result.classString.length) {
                Class modelClass = NSClassFromString(result.classString);
                if ([data isKindOfClass:[NSArray class]]) {
                    responseModel.list = (NSMutableArray <RrBaseModel> *) [modelClass mj_objectArrayWithKeyValuesArray:data];
                } else {
                    //包含 分页数组字段 orders 和 分页 总数量 total 、分页pages 判定为分页模型
                    if ([[responseModel.data allKeys] containsObject:@"orders"] && [[responseModel.data allKeys] containsObject:@"total"] &&
                        [[responseModel.data allKeys] containsObject:@"pages"]) {
                        responseModel.pageData = [RrDataPageModel mj_objectWithKeyValues:data];
                        if (responseModel.pageData.records) {
                            responseModel.list = (NSMutableArray <RrBaseModel> *) [modelClass mj_objectArrayWithKeyValuesArray:responseModel.pageData.records];
                        }
                    }else{
                        responseModel.item =  [modelClass mj_objectWithKeyValues:data];
                    }
                }
            }
        }
    }
    @catch(NSException *e){
        jsonModelError = [NSError errorWithDomain:e.name code:RequestHasErrorCode userInfo:e.userInfo];
    }
    responseModel.isCashEQO = YES;
    result.resultBlock(responseObjectB, responseModel ,jsonModelError);
    
}


- (void (^)(NSURLSessionDataTask *task, NSError *error))analyzeDataWithfailureCallBack:(RrResponseResultBlockModel *)result path:(NSString *)urlString parameters:(id)parameters  method:(NSString *)method  {
    
    WEAKSELF
    return ^(NSURLSessionDataTask *taskB, NSError *errorB) {
        
        RrResponseModel *responseModel = nil;
        NSDictionary *dict = nil;
        @try {
            NSData *data = errorB.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSError *jsonModelError = nil;
            if (data) {
                dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonModelError];
            }
            responseModel = [RrResponseModel mj_objectWithKeyValues:dict];
            NSLog(@"👴请求头：HTTPRequestHeaders👴%@",self.sessionManager.requestSerializer.HTTPRequestHeaders);
            NSLog(@"😄😄%@",dict);
            if ([responseModel.code integerValue] == 401) { // token 过期 -->重新登陆
                [[UserDataManager sharedManager] psuhLoginVC];
                //                showMessage(@"登陆过期");
            }
            if (responseModel) {
                NSMutableDictionary *userInfoNew = [NSMutableDictionary dictionaryWithCapacity:0];
                [userInfoNew setObject:responseModel forKey:WkkeeperErrorUserInfoKey];
                
                if (errorB.userInfo) {
                    [userInfoNew addEntriesFromDictionary:errorB.userInfo];
                }
                errorB = [NSError errorWithDomain:errorB.domain
                                             code:errorB.code userInfo:userInfoNew];
            }
        }
        @catch(NSException *e) { }
        
        if (result.resultBlock) {
            result.resultBlock(dict, nil, errorB);
        }
        
        if (weakSelf.responseBlock) {
            //            weakSelf.responseBlock(errorB.responseModel);
        }
    };
}


#pragma mark -

- (NSString *)encodeUrlString:(NSString *)originUrlString {
    
    if (!originUrlString) {
        return @"";
    }
    NSString *encodeString = [originUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodeString;
}


- (void)setToken:(NSString *)token
{
    NSString *berear = @"";
    if (checkStringIsEmty(token)) {
        token = KDefineToken;
        berear = [NSString stringWithFormat:@"Basic %@",token];
    }else{
        berear = [NSString stringWithFormat:@"Bearer %@",token];
    }
    //    berear = token; // 过期的token 做调试 d05d4700-5372-45e7-8aa6-4b27ea09e2b8
    [self.sessionManager.requestSerializer setValue:berear forHTTPHeaderField:@"Authorization"];
    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}



//数据缓存
/**
 *  创建缓存目录
 *
 *  @return 缓存目录
 */
-(NSString *)createCacheDirection
{
    //沙盒目录
    NSLog(@"-----%@",NSHomeDirectory());
    //Document 文件夹目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    //创建缓存目录
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,LaoXiaoEGOCache];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        BOOL result = [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (result) {
            return createPath;
        }else
        {
            return nil;
        }
    } else {
        NSLog(@"FileDir is exists.");
        return createPath;
    }
    
}




@end
