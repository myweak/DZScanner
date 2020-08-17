//
//  FMBDManagerTool.h
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    KDataBaseStateOne,
    KDataBaseStateTwo,
    KDataBaseStateThree,
    
}KDataBaseDeleteState;

NS_ASSUME_NONNULL_BEGIN

@interface FMBDManagerTool : NSObject


/*
 * 返回一个单例
 */
+ (instancetype)defaultManager;


/*
* 获取沙盒路径
*/
- (NSString *)databaseFilePath;
/**
 *  创建表（表明是model的类名）
 */
- (void)creatTable:(Class )modelClass primaryKey:(NSString *)primaryKey, ...;
/**
 *  增加或更新 数据库数据
 *  1.如果没有创表，自动创表（表明是model的类名）
 *  2.创表的时候，是自定根据模型类的第一个属性当约束 保持唯一性的，所以 注意模型类的属性顺序
 *  3.如果数据库存在这条数据 更新数据
 *  4.根据runtime 自动写sql语句  实现增加更新
 */
- (BOOL)insertAndUpdateModelToDatabase:(id)model;

/**
 *  跟据条件删除语句
 *
 *  @param model                要删除的模型
 *  @param kDataBaseDeleteState 跟据几个参数去删
 *  @param one                  第一个参数(如果只有一个参数，后两个参数不用传)
 *  @param two                  第二个参数(如果只有两个参数，后一个参数不用传)
 *  @param three                第三个参数(跟据三种条件去删除语句)
 *
 *  @return
 */
-(BOOL)deleteModelInDatabase:(Class)model
        KDataBaseDeleteState:(KDataBaseDeleteState)kDataBaseDeleteState
                    whereOne:(NSString *)one
                    whereTwo:(NSString *)two
                  whereThree:(NSString *)three;
/**
 *  删除表
 *
 *  @param model 要删除的模型
 *
 *  @return
 */
-(BOOL)deleteModelInDatabase:(Class)model;
/**
 *  查询一张表的所有数据
 *  因为创建表的时候是根据类名创建的
 */
- (NSArray *)selectAllModelInDatabase:(Class)modelClass;
/**
 *  根据约束索引查询数据
 *  @param model  所以要先传入相关的model 如果format为nil 就是默认查询model的第一个属性
 *  @param format 查询条件  可以根据你的约束条件查询  也可以查询别的mode调教
 *  @return 返回想要的数据
 */
- (NSArray *)selectModelArrayInDatabase:(id)model orderByKey:(NSString *)orderKey byKey:(NSString *)format, ...;

/**
 查询model表 加入更新字段
 */
-(void)updateExistElement:(id)model;
// 查询数据库失败---记录失败次数
-(void)instertFailureWithFMDBDataLost:(id)model isToZero:(BOOL)isZero;



@end


NS_ASSUME_NONNULL_END
