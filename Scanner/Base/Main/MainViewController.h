//
//  MainViewController.h
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

typedef void (^RightDefineActionBlock)(BOOL isSelect);
typedef void (^ NaviBtnActionBlock)(void);


#import <UIKit/UIKit.h>
#import "TZNotNetworkView.h" // 无网络View

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController
@property (nonatomic, copy)RightDefineActionBlock  rightDefineActionBlock;
@property (nonatomic, copy)NaviBtnActionBlock rightActionBlock;
@property (nonatomic, copy)NaviBtnActionBlock leftActionBlock;

@property (nonatomic, strong) UITableView *superTableView;
@property (nonatomic, strong) TZNotNetworkView *notNetWorkView;

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;



/*!
 @brief     左边按钮
 */
- (void)addNavigationButtonLeft:(NSString *)title
                RightActionBlock:(NaviBtnActionBlock)leftActionBlock;

/*!
 @brief     右边按钮
 */
- (void)addNavigationButtonRight:(NSString *)title
             RightActionBlock:(NaviBtnActionBlock)rightActionBlock;

/*!
 @brief     左边按钮【图片】
 */
- (void)addNavigationButtonImageLeft:(NSString *)buttonImage
                    RightActionBlock:(NaviBtnActionBlock)leftActionBlock;


/*!
 @brief     右边按钮【图片】
 */
- (void)addNavigationButtonImageRight:(NSString *)buttonImage
                     RightActionBlock:(NaviBtnActionBlock)rightActionBlock;


/*!
 @brief   自定义  右边按钮【图片】
 */
- (UIButton *)addRightNavigationCustomButtonWithActionBlock:(NaviBtnActionBlock)rightActionBlock;

// 添加底部按钮
- (UIButton*)addBottomBtnWithTitle:(NSString *)title actionBlock:(void(^)(UIButton *btn))block;


@end

NS_ASSUME_NONNULL_END
