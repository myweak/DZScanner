//
//  FMBDManagerTool.m
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "FMBDManagerTool.h"
#import "FMDB.h"
#import <objc/runtime.h>



// 通过实体获取类名
#define TABLE_NAME(model) [NSString stringWithUTF8String:object_getClassName(model)]
// 通过实体获取属性数组数目
#define MODEL_PROPERTYS_COUNT [[self getAllProperties:model] count]
// 通过实体获取属性数组
#define MODEL_PROPERTYS [self getAllProperties:model]



// 通过实体获取类名
#define TABLE_NAME_Class(modelClass) [NSString stringWithUTF8String:object_getClassName(modelClass)]
// 通过实体获取属性数组数目
#define CLASS_PROPERTYS_COUNT [[self getAllProperties:modelClass] count]
// 通过实体获取属性数组
#define CLASS_PROPERTYS [self getAllProperties:modelClass]


@interface FMBDManagerTool()
@property (nonatomic ,strong)FMDatabase *db;

@property (nonatomic ,strong)FMDatabaseQueue* dataBaseQueue;
@end


@implementation FMBDManagerTool


+ (instancetype) defaultManager{
    static FMBDManagerTool *_DataBaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DataBaseManager = [[FMBDManagerTool alloc]init];
    });
//    NSLog(@"单例子   %@",_DataBaseManager);
    return _DataBaseManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatDatabase];
    }
    return self;
}

// 创建数据库
- (void)creatDatabase
{
    self.db = [FMDatabase databaseWithPath:[self databaseFilePath]];
    self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseFilePath]];
}
// 获取沙盒路径
- (NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"LaoXiaoMessageData.sqlite"];
    return dbFilePath;
    
}
// 创建表格
- (void)creatTable:(id)model
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db) {
        [self creatDatabase];
    }
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
    //
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if (![self.db tableExists:TABLE_NAME(model)]) {
        //（1）获取类名作为数据库表名
        //（2）获取类的属性作为数据表字段
        
        // 1.创建表语句头部拼接
        NSString *creatTableStrHeader = [NSString stringWithFormat:@"create table %@",TABLE_NAME(model)];
        
        // 2.创建表语句中部拼接
        NSString *creatTableStrMiddle =@"";
        for (int i = 0; i < MODEL_PROPERTYS_COUNT; i++) {
            if ([creatTableStrMiddle isEqualToString:@""]) {
                //UNIQUE 独一无二的
                //                UNIQUE 约束唯一标识数据库表中的每条记录。
                //                UNIQUE 和 PRIMARY KEY 约束均为列或列集合提供了唯一性的保证。
                //                PRIMARY KEY 拥有自动定义的 UNIQUE 约束。
                //                请注意，每个表可以有多个 UNIQUE 约束，但是每个表只能有一个 PRIMARY KEY 约束
                creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@"(%@ TEXT UNIQUE",[MODEL_PROPERTYS objectAtIndex:i]];
            } else {
                creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[MODEL_PROPERTYS objectAtIndex:i]];
            }
            
        }
        // 3.创建表语句尾部拼接
        NSString *creatTableStrTail =[NSString stringWithFormat:@")"];
        // 4.整句创建表语句拼接
        NSString *creatTableStr = [NSString string];
        creatTableStr = [creatTableStr stringByAppendingFormat:@"%@%@%@",creatTableStrHeader,creatTableStrMiddle,creatTableStrTail];
        [self.db executeUpdate:creatTableStr];
        
        NSLog(@"创建完成");
    }
    //    关闭数据库
    [self.db close];
}


// 只保存单条数据
-(void)creatTable:(Class)modelClass primaryKey:(NSString *)primaryKey, ...
{
    if (primaryKey == nil) {
        [self creatTable:modelClass];
        return;
    }
    va_list arglist;
    va_start(arglist, primaryKey);
    NSString  * outstring = [[NSString alloc] initWithFormat:primaryKey arguments:arglist];
    va_end(arglist);
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db) {
        [self creatDatabase];
    }
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
    //
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if (![self.db tableExists:TABLE_NAME_Class(modelClass)]) {
        //（1）获取类名作为数据库表名
        //（2）获取类的属性作为数据表字段
        
        // 1.创建表语句头部拼接
        NSString *creatTableStrHeader = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS  %@",TABLE_NAME_Class(modelClass)];
        // 2.创建表语句中部拼接
        NSString *creatTableStrMiddle =@"";
        for (int i = 0; i < CLASS_PROPERTYS_COUNT; i++) {
            if ([creatTableStrMiddle isEqualToString:@""]) {
                creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@"(%@ TEXT",[CLASS_PROPERTYS objectAtIndex:i]];
            } else {
                creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[CLASS_PROPERTYS objectAtIndex:i]];
            }
        }
        creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",primary key(%@)",outstring];
        // 3.创建表语句尾部拼接
        NSString *creatTableStrTail =[NSString stringWithFormat:@")"];
        // 4.整句创建表语句拼接
        NSString *creatTableStr = [NSString string];
        creatTableStr = [creatTableStr stringByAppendingFormat:@"%@%@%@",creatTableStrHeader,creatTableStrMiddle,creatTableStrTail];
        [self.db executeUpdate:creatTableStr];
        
        NSLog(@"创建完成");
    }else{
        [self updateExistElement:[modelClass new]];
    }
    //    关闭数据库
    [self.db close];
    
}


#pragma mark - 查询model表 加入不存在的字段，
-(void)updateExistElement:(id)model{
    
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db) {
        [self creatDatabase];
    }
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
    //
    //判断数据库中是否已经存在这个表，如果存在则 才能插入 字段
    if (![self.db tableExists:TABLE_NAME(model)]) {
        [self creatTable:model];
        // 判断数据库能否打开
        if (![self.db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
    }else{
        
        //在已经创建好的表格中插入add字段的SQ语句
        for (NSString *element in MODEL_PROPERTYS) {
            
            //        NSString *addStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",TABLE_NAME(model),element];
            NSString *defaultStr = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' text NOT NULL DEFAULT 'none' ",TABLE_NAME(model),element];
            //判断model_table表格中是否有 -> element字段
            if (![self.db columnExists:element inTableWithName:TABLE_NAME(model)])
            {
                BOOL b = [self.db executeUpdate:defaultStr];
                if (b) {
                    NSLog(@"\n新字段加入成功\n");
                }
            }
            
        }

        
    }
}
-(BOOL)insertAndUpdateModelToDatabase:(id)model{
    
    // 判断数据库是否存在
    if (!self.db) {
        [self creatDatabase];
    }
    // 判断数据库能否打开
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    // 设置数据库缓存
    [self.db setShouldCacheStatements:YES];
    
    // 判断是否存在对应的userModel表
    if(![self.db tableExists:TABLE_NAME(model)])
    {
        [self creatTable:model];
        // 判断数据库能否打开
        if (![self.db open]) {
            NSLog(@"数据库打开失败");
            return NO;
        }
    }
    
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        [self.db beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            // 拼接插入语句的头部
            // insert or replace into 如果有数据  复盖  没有就插入
            //  @"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE];
            
            //增加字段
//            NSArray *array = @[@"whatPP0",@"whatPP1",@"whatPP2",@"whatPP3",@"whatPP4",@"whatPP5",@"whatPP6",@"whatPP7"];
//
//            for (NSString *str in array) {
//                if (![self.db columnExists:str inTableWithName:TABLE_NAME(model)]){
//                    NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME(model),str];
//                    [self.db executeUpdate:alertStr];
//                }
//            }
            
            NSString *insertStrHeader = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  %@ (",TABLE_NAME(model)];
            // 拼接插入语句的中部1
            NSString *insertStrMiddleOne = [NSString string];
            for (int i = 0; i < MODEL_PROPERTYS_COUNT; i++) {
                insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[MODEL_PROPERTYS objectAtIndex:i]];
                if (i != MODEL_PROPERTYS_COUNT -1) {
                    insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@","];
                }
            }
            // 拼接插入语句的中部2
            NSString *insertStrMiddleTwo = [NSString stringWithFormat:@") VALUES ("];
            // 拼接插入语句的中部3
            NSString *insertStrMiddleThree = [NSString string];
            for (int i = 0; i < MODEL_PROPERTYS_COUNT; i++) {
                insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@"?"];
                if (i != MODEL_PROPERTYS_COUNT-1) {
                    insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@","];
                }
            }
            // 拼接插入语句的尾部
            NSString *insertStrTail = [NSString stringWithFormat:@")"];
            // 整句插入语句拼接
            NSString *insertStr = [NSString string];
            insertStr = [insertStr stringByAppendingFormat:@"%@%@%@%@%@",insertStrHeader,insertStrMiddleOne,insertStrMiddleTwo,insertStrMiddleThree,insertStrTail];
            NSMutableArray *modelPropertyArray = [NSMutableArray array];
            for (int i = 0; i < MODEL_PROPERTYS_COUNT; i++) {
                NSString *str = [model valueForKey:[MODEL_PROPERTYS objectAtIndex:i]];
                if (str == nil) {
                    str = @"none";
                }
                [modelPropertyArray addObject: str];
            }
            
            BOOL  result = [self.db executeUpdate:insertStr withArgumentsInArray:modelPropertyArray];
            
            if (!result)
            {
                isRollBack = YES;
                showMessage(@"失败");
            }
        }
        @catch (NSException *exception) {
            [self.db rollback];
        }
        @finally {
            if (isRollBack)
            {
                [self.db rollback];
//                [self instertFailureWithFMDBDataLost:model isToZero:NO]; // xiao 加 2017-11-21
                NSLog(@"insert to database failure content");
            }
            else
            {
//                [self instertFailureWithFMDBDataLost:model isToZero:NO]; // xiao 加 2017-11-21

                [self.db commit];
            }
        }
    }];
    //    关闭数据库
    [self.db close];
    return YES;
}
// 查询数据库失败---记录失败次数
-(void)instertFailureWithFMDBDataLost:(id)model isToZero:(BOOL)isZero{
//    NSString *messageID = [model valueForKey:@"messageID"];
//    NSString *pushType = [model objectForKey:@"pushType"];
//    NSArray * userSetArray = [[writeToDB shareManager] UserSettingConditionWay:[model objectForKey:@"messageID"] pushType:[model objectForKey:@"pushType"]];
//    for (int i = 0; i < userSetArray.count; i++){ //更新插入数据失败字段
////        UserSetting * userModel = userSetArray[i];
////        userModel.lostNum = ([userModel.lostNum isEqualToString:@"none"] || isZero) ? @"0":userModel.lostNum;
////        userModel.lostNum = [NSString stringWithFormat:@"%d",[userModel.lostNum integerValue]+1];
////        [self insertAndUpdateModelToDatabase:userModel];
//    }
}
-(BOOL)deleteModelInDatabase:(Class)model
        KDataBaseDeleteState:(KDataBaseDeleteState)kDataBaseDeleteState
                    whereOne:(NSString *)one
                    whereTwo:(NSString *)two
                  whereThree:(NSString *)three
{
    // 判断是否创建数据库
    if (!self.db) {
        [self creatDatabase];
    }
    // 判断数据是否已经打开
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    // 设置数据库缓存，优点：高效
    [self.db setShouldCacheStatements:YES];
    
    // 判断是否有该表
    if(![self.db tableExists:TABLE_NAME(model)])
    {
        return NO;
    }
    // 删除操作
    // 拼接删除语句
    NSString *deletStr;

    if (kDataBaseDeleteState == KDataBaseStateOne) {
        
        deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",
                    TABLE_NAME(model),
                    [MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:one]],
                    [model valueForKey:[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:one]]]];
    } else if (kDataBaseDeleteState == KDataBaseStateTwo) {
        
        deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = '%@' and %@ = '%@'",
                    TABLE_NAME(model),
                    [MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:one]],
                    [model valueForKey:[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:one]]],
                    [MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:two]],
                    [model valueForKey:[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:two]]]];
        
    } else if (kDataBaseDeleteState == KDataBaseStateThree) {
        
        deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = '%@' and %@ = '%@' and %@ = '%@'",TABLE_NAME(model),[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:one]],
                    [model valueForKey:[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:one]]],[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:two]],
                    [model valueForKey:[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:two]]],[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:three]],
                    [model valueForKey:[MODEL_PROPERTYS objectAtIndex:[MODEL_PROPERTYS indexOfObject:three]]]];
    }
    

    BOOL isCorrect = [self.db executeUpdate:deletStr];
    // 关闭数据库
    [self.db close];
    return isCorrect;
}

-(BOOL)deleteModelInDatabase:(Class)model
{
    // 判断是否创建数据库
    if (!self.db) {
        [self creatDatabase];
    }
    // 判断数据是否已经打开
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    // 设置数据库缓存，优点：高效
    [self.db setShouldCacheStatements:YES];
    
    // 判断是否有该表
    if(![self.db tableExists:TABLE_NAME(model)])
    {
        return NO;
    }
    // 删除操作 drop table 表名
    // 拼接删除语句
    NSString *deletStr = [NSString stringWithFormat:@"drop table  %@",
                TABLE_NAME(model)];
    BOOL isCorrect = [self.db executeUpdate:deletStr];
    // 关闭数据库
    [self.db close];
    return isCorrect;
}


// 表字段查询
-(NSMutableArray *)selectAllTableKey:(id)model{
    if (!self.db) {
        [self creatDatabase];
    }
    
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    [self.db setShouldCacheStatements:YES];
    
    if(![self.db tableExists:TABLE_NAME(model)])
    {
        [self creatTable:model];
    }
    
    NSMutableArray *tableKeyArray = [NSMutableArray array];
    NSString * textKey = [NSString stringWithFormat:@"PRAGMA table_info(%@)",TABLE_NAME(model)];
    FMResultSet *set = [self.db executeQuery:textKey];
    while ([set next]) {
        NSString *index = [set stringForColumnIndex:0];
        NSString *key   = [set stringForColumnIndex:1];
        NSString *type  = [set stringForColumnIndex:2];
        NSLog(@"\n第%@个字段；--字段名：%@；--字段类型：%@",index,key,type);
        [tableKeyArray addObject:key];
    }
    [self.db close];
    return tableKeyArray;
}
// 表数据查询
- (NSArray *)selectAllModelInDatabase:(id)model
{
    //    select * from tableName
    if (!self.db) {
        [self creatDatabase];
    }
    
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    [self.db setShouldCacheStatements:YES];
    
    if(![self.db tableExists:TABLE_NAME(model)])
    {
        [self creatTable:model];
    }
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *userModelArray = [NSMutableArray array];
    //定义一个结果集，存放查询的数据
    //拼接查询语句
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@",TABLE_NAME(model)];
    FMResultSet *resultSet = [self.db executeQuery:selectStr];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
        // 用id类型变量的类去创建对象
        id modelResult = [[[model class]alloc] init];
        for (int i = 0; i < MODEL_PROPERTYS_COUNT; i++) {
            [modelResult setValue:[resultSet stringForColumn:[MODEL_PROPERTYS objectAtIndex:i]] forKey:[MODEL_PROPERTYS objectAtIndex:i]];
        }
        //将查询到的数据放入数组中。
        [userModelArray addObject:modelResult];
    }
    // 关闭数据库
    [self.db close];
    
    return userModelArray;
}
/**
 *  根据model 表名 无条件查询数据
 */
- (NSArray *)selectModelArrayInDatabase:(id)model
{
    if (!self.db) {
        [self creatDatabase];
    }
    
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    [self.db setShouldCacheStatements:YES];
    
    if(![self.db tableExists:TABLE_NAME(model)])
    {
        [self creatTable:model];
    }
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *userModelArray = [NSMutableArray array];
    //定义一个结果集，存放查询的数据
    //拼接查询语句
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",TABLE_NAME(model),[MODEL_PROPERTYS objectAtIndex:0],[model valueForKey:[MODEL_PROPERTYS objectAtIndex:0]]];
    FMResultSet *resultSet = [self.db executeQuery:selectStr];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
        // 用id类型变量的类去创建对象
        id modelResult = [[[model class]alloc] init];
        for (int i = 0; i < MODEL_PROPERTYS_COUNT; i++) {
            [modelResult setValue:[resultSet stringForColumn:[MODEL_PROPERTYS objectAtIndex:i]] forKey:[MODEL_PROPERTYS objectAtIndex:i]];
        }
        //将查询到的数据放入数组中。
        [userModelArray addObject:modelResult];
    }
    // 关闭数据库
    [self.db close];
    
    return userModelArray;
}
/**
 *  肯据条件查询数据
 */
- (NSArray *)selectModelArrayInDatabase:(id)model orderByKey:(NSString *)orderKey byKey:(NSString *)format, ...
{
    NSLog(@"数据库名:%@",TABLE_NAME(model));

    if (format == nil) {
        return  [self selectModelArrayInDatabase:model];
    }
    va_list arglist;
    va_start(arglist, format);
    NSString  * outstring = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    NSArray *keyArr = [outstring componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"，,"]];
    if (!self.db) {
        [self creatDatabase];
    }
    
    if (![self.db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
    
    if(![self.db tableExists:TABLE_NAME(model)])
    {
        [self creatTable:model];
    }
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *userModelArray = [NSMutableArray array];
    //定义一个结果集，存放查询的数据
    //拼接查询语句
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@ where ",TABLE_NAME(model)];
    //拼接查询条件的语句
    NSString *selsctFactor = @"";
    for (int i = 0; i < keyArr.count; i++) {
        selsctFactor = [selsctFactor stringByAppendingFormat:@"%@ = '%@'",keyArr[i],[model valueForKey:keyArr[i]]];
        if (i != keyArr.count-1) {
            selsctFactor = [selsctFactor stringByAppendingFormat:@" and "];
        }
    }
    //是否需要根据字段排序输出 select * from 表名 order by 字段 ; 1:asc（升序，默认）, 2:desc（降序）
    if (orderKey.length!=0) {
        selectStr = [selectStr stringByAppendingFormat:@"%@ ORDER BY %@ DESC",selsctFactor,orderKey];
    }else{
        selectStr = [selectStr stringByAppendingFormat:@"%@",selsctFactor];
    }
    FMResultSet *resultSet = [self.db executeQuery:selectStr];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
        // 用id类型变量的类去创建对象
        id modelResult = [[[model class]alloc] init];
        for (int i = 0; i < MODEL_PROPERTYS_COUNT; i++) {
            [modelResult setValue:[resultSet stringForColumn:[MODEL_PROPERTYS objectAtIndex:i]] forKey:[MODEL_PROPERTYS objectAtIndex:i]];
        }
        //将查询到的数据放入数组中。
        [userModelArray addObject:modelResult];
    }
    // 关闭数据库
    [self.db close];
    return userModelArray;
    
}
/**
 *  传递一个model实体
 */
- (NSArray *)getAllProperties:(id)model
{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList([model class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray array];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
 
    free(properties);
    return propertiesArray;
}

@end
