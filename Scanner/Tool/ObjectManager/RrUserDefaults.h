//
//  RrUserDefaults.h
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrUserDefaults : NSObject
// 保存数据
+(void)saveValueInUD:(id)value forKey:(NSString *)key;
+(void)saveDataValueInUD:(NSData *)data forKey:(NSString *)key;
+(void)saveStrValueInUD:(NSString *)str forKey:(NSString *)key;
+(void)saveIntValueInUD:(NSInteger)value forKey:(NSString *)key;
+(void)saveDicValueInUD:(NSDictionary *)dic forKey:(NSString *)key;
+(void)saveArrValueInUD:(NSArray *)arr forKey:(NSString *)key;
+(void)saveDateValueInUD:(NSDate *)date forKey:(NSString *)key;
+(void)saveBoolValueInUD:(BOOL)value forKey:(NSString *)key;
// 清除数据
+(void)removeValueInUDWithKey:(NSString *)key;
// 获取数据
+(id)getValueInUDWithKey:(NSString *)key;
+(NSDate *)getDateValueInUDWithKey:(NSString *)key;
+(NSString *)getStrValueInUDWithKey:(NSString *)key;
+(NSInteger )getIntValueInUDWithKey:(NSString *)key;
+(NSDictionary *)getDicValueInUDWithKey:(NSString *)key;
+(NSArray *)getArrValueInUDWithKey:(NSString *)key;
+(NSData *)getdataValueInUDWithKey:(NSString *)key;
+(BOOL)getBoolValueInUDWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
