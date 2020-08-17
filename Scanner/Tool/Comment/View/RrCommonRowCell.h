//
//  RrCommonRowCell.h
//  Scanner
//
//  Created by edz on 2020/7/10.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define  RrCommonRowCell_ID  @"RrCommonRowCellID"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol RrCommonRowCellDelegate <NSObject>
- (void)getCellSelected:(BOOL)selected animated:(BOOL)animated;
@end

@interface RrCommonRowCell : UITableViewCell
// textField--> 默认隐藏
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *contenViewBg;
//左边 图片 --> 默认隐藏
@property (weak, nonatomic) IBOutlet UIImageView *mianImageView;

@property (nonatomic, assign) BOOL isHidden_mianImageView;

//左边主标题
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTitleLabel_X; // 默认27


//左边副标题--> 默认隐藏
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
//中间标题 -->默认隐藏
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
//右边标题 
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
//右边👉指出箭头 -->默认隐藏
@property (weak, nonatomic) IBOutlet UIImageView *pushImageView;
//顶部线 --> 默认隐藏
@property (weak, nonatomic) IBOutlet UIView *topLineView;
//底部线--> 默认隐藏
@property (weak, nonatomic) IBOutlet UIView *bottonLineView;

@property (nonatomic, assign) id<RrCommonRowCellDelegate> delegate;

- (void)getCellSelectedBlock:(void (^)(BOOL selected, BOOL animated)) block;

@end

NS_ASSUME_NONNULL_END
