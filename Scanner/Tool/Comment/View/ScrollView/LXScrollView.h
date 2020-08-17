//
//  LXScrollView.h
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LXScrollViewItemWidthType_none,
    LXScrollViewItemWidthType_equalMaxWidth, // 等于 最大的item长度
    LXScrollViewItemWidthType_equalAll, // BarWidth 平分
} LXScrollViewItemWidthType;

@class LXScrollView;

@protocol LXScrollViewDelegate <NSObject>

/** 点击分选框标题
 *  index 0~titles.count-1
 */
- (void)gsSortViewDidScroll:(NSInteger)index;


@end

@protocol LXScrollViewDataSource <NSObject>

@required

/** 分选框的标题数组*/
- (NSArray <NSString *>*)gsSortViewTitles;

/** 分选框的内容页
 *  index 0~titles.count-1
 *  请将返回的View减去标题框的高度（标题框高度默认40）
 */
- (UIView *)gsSortView:(LXScrollView *)sortView viewForIndex:(NSInteger)index;

@end

@interface LXScrollView : UIView

@property (nonatomic,weak)id <LXScrollViewDelegate>delegate;
@property (nonatomic,weak)id <LXScrollViewDataSource>dataSource;

//@property (nonatomic,assign)BOOL isBarEqualParts;//标题框是否等分，默认NO(设置为YES之后，markLineWidth的长度也就定了为最长的标题长，但可以修改的)
@property (nonatomic, assign) LXScrollViewItemWidthType type;

@property (nonatomic,assign)CGFloat markLineWidth;//下标线的宽度，如果为0，那么就跟标题文字一样宽

@property (nonatomic, assign) NSInteger selectItemIndex; // 默认选中的item

/** 初始化
 *  frame是self的frame
 *  width是标题框的宽度，当标题框右边有个按钮的时候可以将width设置的小一点
 */
- (instancetype)initWithFrame:(CGRect)frame andBarWidth:(CGFloat)width;

- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
