//
//  RrTool.h
//  Scanner
//
//  Created by rrdkf on 2020/6/21.
//  Copyright © 2020 Occipital. All rights reserved.
//

#ifndef RrTool_h
#define RrTool_h


/**
runtime实现通用copy
*/
#define Rr_CopyWithZone \
- (id)copyWithZone:(NSZone *)zone {\
    id obj = [[[self class] allocWithZone:zone] init];\
    Class class = [self class];\
    while (class != [NSObject class]) {\
        unsigned int count;\
        Ivar *ivar = class_copyIvarList(class, &count);\
        for (int i = 0; i < count; i++) {\
            Ivar iv = ivar[i];\
            const char *name = ivar_getName(iv);\
            NSString *strName = [NSString stringWithUTF8String:name];\
            id value = [[self valueForKey:strName] copy];\
            [obj setValue:value forKey:strName];\
        }\
        free(ivar);\
        class = class_getSuperclass(class);\
    }\
    return obj;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone{\
    id obj = [[[self class] allocWithZone:zone] init];\
    Class class = [self class];\
    while (class != [NSObject class]) {\
        unsigned int count;\
        Ivar *ivar = class_copyIvarList(class, &count);\
        for (int i = 0; i < count; i++) {\
            Ivar iv = ivar[i];\
            const char *name = ivar_getName(iv);\
            NSString *strName = [NSString stringWithUTF8String:name];\
            id value = [[self valueForKey:strName] copy];\
            [obj setValue:value forKey:strName];\
        }\
        free(ivar);\
        class = class_getSuperclass(class);\
    }\
    return obj;\
}\
\


/**
 二、runtime实现通用
 归档的实现
 */

#define Rr_CodingImplementation \
- (void)encodeWithCoder:(NSCoder *)aCoder \
{ \
unsigned int outCount = 0; \
Ivar * vars = class_copyIvarList([self class], &outCount); \
for (int i = 0; i < outCount; i++) { \
    Ivar var = vars[i]; \
    const char * name = ivar_getName(var); \
    NSString * key = [NSString stringWithUTF8String:name]; \
    id value = [self valueForKey:key]; \
    if (value) { \
        [aCoder encodeObject:value forKey:key]; \
    } \
} \
} \
\
- (instancetype)initWithCoder:(NSCoder *)aDecoder \
{ \
    if (self = [super init]) { \
        unsigned int outCount = 0; \
        Ivar * vars = class_copyIvarList([self class], &outCount); \
        for (int i = 0; i < outCount; i++) { \
            Ivar var = vars[i]; \
            const char * name = ivar_getName(var); \
            NSString * key = [NSString stringWithUTF8String:name]; \
            id value = [aDecoder decodeObjectForKey:key]; \
            if (value) { \
                [self setValue:value forKey:key]; \
            } \
        } \
    } \
    return self; \
}



#endif /* RrTool_h */
