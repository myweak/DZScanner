//
//  RrSearchViewController.h
//  Scanner
//
//  Created by edz on 2020/8/5.
//  Copyright © 2020 rrdkf. All rights reserved.
//
typedef enum : NSUInteger {
    RrSearchVCType_product,
    RrSearchVCType_order,
    RrSearchVCType_scanField,
} RrSearchVCType;
#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrSearchViewController : MainViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) NSInteger pageNum; //分页
@property (nonatomic, assign) BOOL isHeadRefreshing; // 头部刷新
@property (nonatomic, assign) RrSearchVCType type;

//更新搜索结果
- (void)updateListData;
- (void)postHistoryRecordDataWithUrlKeyWord:(NSString *)keyWord;

@end

NS_ASSUME_NONNULL_END
