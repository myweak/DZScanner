//
//  LXScrollView.m
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "LXScrollView.h"

@interface LXScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *barScroller;//顶部标题框
@property (nonatomic,assign)CGFloat barWidth;
@property (nonatomic,strong)NSArray <NSString *>*barTitles;
@property (nonatomic,strong)UIButton *tmpItem;

@property (nonatomic,strong)UIView *markLineView;//下标线

@property (nonatomic,strong)UIScrollView *contentScroller;//下部内容页面的scrollView
@property (nonatomic,assign)CGFloat tmpOff_X;

@property (nonatomic, strong) NSMutableArray *saveItemBtnArr;// 保存item

@end

/** 标题框高度*/
#define kBarScrollerHeight iPH(50)
/** 标题框item的字体大小*/
#define kBarItmeFont KFont20
/** 标题框item之间的间隙*/
#define kBarItemBetween 15.f
/** 标题框item的字体颜色*/
#define kBarItemTextColor [UIColor blackColor]
/** 标题框item的字体选中颜色*/
#define kBarItemTextColorH [UIColor c_GreenColor]

/** 下标线的高度*/
#define kMarkLineHeight 3.f
/** 下标线的颜色*/
#define kMarkLineColor [UIColor c_GreenColor]


@implementation LXScrollView

- (UIScrollView *)barScroller{
    if (!_barScroller) {
        _barScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _barWidth, kBarScrollerHeight)];
        _barScroller.backgroundColor = [UIColor whiteColor];
        _barScroller.showsHorizontalScrollIndicator = NO;
        
    }
    return _barScroller;
}
- (UIScrollView *)contentScroller{
    if (!_contentScroller) {
        _contentScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kBarScrollerHeight, self.frame.size.width, self.frame.size.height - kBarScrollerHeight)];
        _contentScroller.backgroundColor = [UIColor whiteColor];
        _contentScroller.showsHorizontalScrollIndicator = NO;
        _contentScroller.pagingEnabled = YES;
        _contentScroller.delegate = self;
        _contentScroller.scrollEnabled = NO;
    }
    return _contentScroller;
}
- (instancetype)initWithFrame:(CGRect)frame andBarWidth:(CGFloat)width{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _barWidth = width>0?width:self.frame.size.width;
        
        [self addSubview:self.barScroller];
        [self addSubview:self.contentScroller];
                
    }
    return self;
}
- (void)reloadData{
    
    if ([self.dataSource respondsToSelector:@selector(gsSortViewTitles)]) {
        _barTitles = [_dataSource gsSortViewTitles];
    }
    else{
        NSLog(@"请实现 gsSortViewTitles 方法");
    }
    
    [self configBarItems];
    [self configMarkLine];
    
    [self configContentViews];
    
    
}
- (void)setSelectItemIndex:(NSInteger)selectItemIndex{
    _selectItemIndex = selectItemIndex;
}

- (NSMutableArray *)saveItemBtnArr{
    if (!_saveItemBtnArr) {
        _saveItemBtnArr = [NSMutableArray array];
    }
    return _saveItemBtnArr;;
}

#pragma mark - 标题框的items
- (void)configBarItems{
    [self.saveItemBtnArr removeAllObjects];

    if (self.type == LXScrollViewItemWidthType_equalMaxWidth) {
        //获取最长的标题的长度
        CGRect maxLongthRect = [_barTitles[0] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kBarItmeFont,NSFontAttributeName, nil] context:nil];
        
        for (NSInteger i = 1; i < _barTitles.count; i ++) {
            CGRect rect = [_barTitles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kBarItmeFont,NSFontAttributeName, nil] context:nil];
            
            if (maxLongthRect.size.width < rect.size.width) {
                maxLongthRect = rect;
            }
        }
        CGFloat itemWidth = maxLongthRect.size.width + 2*kBarItemBetween;
        
        for (NSInteger i = 0; i < _barTitles.count; i ++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(i * itemWidth, 0, itemWidth, kBarScrollerHeight - kMarkLineHeight);
            item.tag = 1111 + i;
            item.titleLabel.font = kBarItmeFont;
            [item setTitle:_barTitles[i] forState:UIControlStateNormal];
            [item setTitleColor:kBarItemTextColor forState:UIControlStateNormal];
            [item setTitleColor:kBarItemTextColorH forState:UIControlStateSelected];
            [item addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_barScroller addSubview:item];
            
            if (!self.tmpItem && i == self.selectItemIndex) {
                self.tmpItem = item;
            }
            [self.saveItemBtnArr addObject:item];
        }
        _barScroller.contentSize = CGSizeMake(itemWidth * _barTitles.count,kBarScrollerHeight);
    }else  if (self.type == LXScrollViewItemWidthType_equalAll) {
        CGFloat item_W = _barWidth / _barTitles.count;
        CGFloat item_X = 0;
        for (NSInteger i = 0; i < _barTitles.count; i ++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.tag = 1111 + i;
            item.titleLabel.font = kBarItmeFont;
            [item setTitle:_barTitles[i] forState:UIControlStateNormal];
            [item setTitleColor:kBarItemTextColor forState:UIControlStateNormal];
            [item setTitleColor:kBarItemTextColorH forState:UIControlStateSelected];
            [item addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_barScroller addSubview:item];
            [self.saveItemBtnArr addObject:item];
            
            if (!self.tmpItem && i == self.selectItemIndex) {
                self.tmpItem = item;
            }

            item.frame = CGRectMake(item_X, 0, item_W, kBarScrollerHeight - kMarkLineHeight);
            
            item_X += item_W;
        }
        _barScroller.contentSize = CGSizeMake(item_X,kBarScrollerHeight);
    }
    else{
        CGFloat item_X = 0;
        for (NSInteger i = 0; i < _barTitles.count; i ++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.tag = 1111 + i;
            item.titleLabel.font = kBarItmeFont;
            [item setTitle:_barTitles[i] forState:UIControlStateNormal];
            [item setTitleColor:kBarItemTextColor forState:UIControlStateNormal];
            [item setTitleColor:kBarItemTextColorH forState:UIControlStateSelected];
            [item addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_barScroller addSubview:item];
            
            if (!self.tmpItem && i == self.selectItemIndex) {
                self.tmpItem = item;
            }
            [self.saveItemBtnArr addObject:item];

            CGRect rect = [_barTitles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kBarItmeFont,NSFontAttributeName, nil] context:nil];
            item.frame = CGRectMake(item_X, 0, rect.size.width + 2*kBarItemBetween, kBarScrollerHeight - kMarkLineHeight);
            
            item_X += rect.size.width + 2*kBarItemBetween;
        }
        _barScroller.contentSize = CGSizeMake(item_X,kBarScrollerHeight);
    }
    self.tmpItem.selected = YES;
}
- (void)itemClickAction:(UIButton *)sender{
    self.tmpItem.selected = NO;
    
    sender.selected = YES;
    self.tmpItem = sender;
    
    NSInteger index = sender.tag - 1111;
    
    if((NSInteger)_contentScroller.contentOffset.x/self.frame.size.width != index)_contentScroller.contentOffset = CGPointMake(index * self.frame.size.width, 0);
    
}
#pragma mark - 下标线
- (void)configMarkLine{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kBarScrollerHeight - kMarkLineHeight, _barScroller.contentSize.width, kMarkLineHeight)];
    line.backgroundColor = [UIColor clearColor];
    [_barScroller addSubview:line];
    
    _markLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, kMarkLineHeight)];
    _markLineView.backgroundColor = kMarkLineColor;
    UIButton *getItem = (UIButton *)[_barScroller viewWithTag:1111];
    _markLineView.frame = CGRectMake(0, 0, _markLineWidth>0?_markLineWidth:(getItem.frame.size.width - 2*kBarItemBetween), kMarkLineHeight);
    _markLineView.center = CGPointMake(getItem.center.x, kMarkLineHeight/2);
    [line addSubview:_markLineView];
}
- (void)scrollMarkLineAndSelectedItem:(CGFloat)off_X{
    
    NSInteger tag = off_X/self.frame.size.width + 1111;
    
    UIButton *getItem = (UIButton *)[self.barScroller viewWithTag:tag];
    self.tmpItem.selected = NO;
    
    getItem.selected = YES;
    self.tmpItem = getItem;
    
    [UIView animateWithDuration:0.3 animations:^{
        _markLineView.frame = CGRectMake(0, 0, _markLineWidth>0?_markLineWidth:(getItem.frame.size.width - 2*kBarItemBetween), kMarkLineHeight);
        _markLineView.center = CGPointMake(getItem.center.x, kMarkLineHeight/2);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat off_X = 0;
        if (getItem.frame.origin.x + getItem.frame.size.width/2 - _barWidth/2 >= 0 && getItem.frame.origin.x + getItem.frame.size.width/2 + _barWidth/2 <= _barScroller.contentSize.width) {
            off_X = getItem.frame.origin.x + getItem.frame.size.width/2 - _barWidth/2;
        }
        else if (getItem.frame.origin.x + getItem.frame.size.width/2 - _barWidth/2 >= 0){
            off_X = _barScroller.contentSize.width - _barWidth;
        }
        _barScroller.contentOffset = CGPointMake(off_X, 0);
    }];
    
}
#pragma mark - 内容页的view
- (void)configContentViews{
    if ([self.dataSource respondsToSelector:@selector(gsSortView:viewForIndex:)]) {
        
        for (NSInteger i = 0; i < _barTitles.count; i ++) {
            UIView *view = [_dataSource gsSortView:self viewForIndex:i];
            view.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, view.frame.size.height);
            [_contentScroller addSubview:view];
        }
        _contentScroller.contentSize = CGSizeMake(_barTitles.count * _contentScroller.frame.size.width, _contentScroller.frame.size.height);
    }
    else{
        NSLog(@"请实现 gsSortView:viewForIndex: 方法");
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger off_X = scrollView.contentOffset.x;
    NSInteger new_index = off_X/self.frame.size.width;
    NSInteger old_index = self.tmpOff_X/self.frame.size.width;
    if (new_index != old_index && off_X >= 0 && off_X < _barTitles.count * self.frame.size.width) {
        
        [self scrollMarkLineAndSelectedItem:off_X];
        
        if ([self.delegate respondsToSelector:@selector(gsSortViewDidScroll:)]) {
            [self.delegate gsSortViewDidScroll:(NSInteger)off_X/self.frame.size.width];
        }
        
        self.tmpOff_X = off_X;
        
    }
}

@end
