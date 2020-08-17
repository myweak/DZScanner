//
//  MZCommonCell.h
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/20.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BackTapAction)(UIButton *btn);
@interface MZCommonCell : UITableViewCell
// ----------------- 实体实例------------------------------------
@property (nonatomic, strong) UILabel  *leftLabel; // 最左边
@property (nonatomic, strong) UILabel  *rightLabel; // 最右边
@property (nonatomic, strong) NSString  *subTitle;  // 中间副标题
@property (nonatomic, strong) UIImageView  *acceImageView; // 右边箭头
@property (nonatomic, assign) BOOL  showAccessoryView; // 右边箭头 是否隐藏， 默认隐藏NO
// -----------------------------------------------------

// 属性
@property (nonatomic, assign) BOOL isBlankCell;

// UI
@property (nonatomic, strong) UIButton * loadMoreButton; // 加载更多
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *customView;



@property (nonatomic, copy) BackTapAction  block;
// 方法
+ (instancetype)cellWithId:(NSString *)cellId;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;


+ (MZCommonCell *)blankCell;
+ (MZCommonCell *)blankSpaceCell;
//空白颜色
+ (MZCommonCell *)blankClearCell;
// 加载更多。 点击响应事件 BackTapAction  block;
+(MZCommonCell *)cellWithLoadMoreButtonWithBlock:(BackTapAction)blcok;

@end
