//
//  AHChain.m
//  AntHouse
//
//  Created by Nathan Ou on 2018/2/1.
//  Copyright © 2018年 Nathan Ou. All rights reserved.
//

#import "AHChain.h"

#define Service_String @"com.anthouse.keychains"

@implementation AHChain

+ (instancetype)shareManager
{
    static AHChain *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AHChain alloc] init];
        [manager initDatas];
    });
    return manager;
}

- (void)initDatas
{
    id datas = [AHChain loadDatas];
    if (!datas || ![datas isKindOfClass:[NSDictionary class]]) {
        // 如果数据不存在，则生成
        datas = @{DeviceUUIDKey:[NSString NA_UUIDString]};
        [AHChain saveAntHouseData:datas];
    }
    
    self.chainData = datas;
}

+(id)loadDatas {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id info = [userDefaults objectForKey:Service_String];//先从UserDefaults取出来
    if(!info) {
        info = [self load:Service_String];//如果没取到从秘钥链里面取
        if (info) {
            [userDefaults setObject:info forKey:Service_String];
            [userDefaults synchronize];
        }
    }
    
    id data = nil;
    if (info && [info isKindOfClass:[NSDictionary class]]) {
        NSString *key = [info allKeys].firstObject;
        if (key) {
            data = [info objectForKey:key];
        }
    }
    
    return data;
}

+(void)saveAntHouseData:(id)data {
    
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = @{bundleId:data};
    if (dict) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:Service_String]; //存user defaults
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self save:Service_String data:dict];//秘钥链
    }
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret ?: nil;
}

+ (void)deleteService:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Service_String]; //从user defaults删除
}

@end
