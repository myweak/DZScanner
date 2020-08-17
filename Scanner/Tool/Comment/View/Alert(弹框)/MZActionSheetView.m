//
//  AHActionSheetView.m
//  MiZi
//
//  Created by 飞礼科技 on 2018/3/14.
//  Copyright © 2018年 Nathan Ou. All rights reserved.
//

#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define count_h 175
#define KAnimateDuration .2
#import "MZActionSheetView.h"
static NSString *AHActionSheetViewIndentifier = @"AHActionSheetViewIndentifier";

@interface MZActionSheetView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIView   * line;       //
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic ,strong) UIButton * cancelButton;    //
@property (nonatomic, assign) NSInteger  selectIndex; //
@property (nonatomic, copy) NSString  *title;

@end
@implementation MZActionSheetView
@synthesize selectIndex = _selectIndex;
-(instancetype) initWithActionSheetWithTitle:(NSString *)title
                                   ListArray:(NSArray *)listArray
                          completeSelctBlock:(CompleteBlock) completeBlock
{
    self = [super init];
    if (self) {
        self.title = title;
        self.tapEnadle = YES;
        self.listArray = listArray;
        self.selectIndex = -1;
        self.line.hidden = !listArray.count;
        self.completeBlock = [completeBlock copy];
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor c_alpha_bgWhiteColor];
        [self addSubview:self.cancelButton];
        [self addSubview:self.tableView];
        [self addSubview:self.line];
        
    }
    return self;
}
-(void)setTapEnadle:(BOOL)tapEnadle{
    _tapEnadle = tapEnadle;
}
-(UIView *)line{
    if(!_line){
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 5.0f)];
        _line.bottom = self.cancelButton.top;
        _line.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
        [_line addLine_bottom];
    }
    return _line;
}
-(void)didSelectRowAtIndex:(NSInteger)selectIndex{
    
    if(self.listArray.count == 0 || selectIndex< 0) return;
    
    _selectIndex = selectIndex;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectIndex inSection:0];

    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
}
-(void)setListArray:(NSArray *)listArray{
    _listArray = listArray;

    CGFloat headTitle_H = checkStringIsEmty(self.title)?0:KCell_H;
    if (listArray.count*KCell_H >count_h) {
        self.tableView.height =  count_h+headTitle_H;
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.height = listArray.count*KCell_H+headTitle_H;
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.bottom = self.cancelButton.top-5;
    [self.tableView reloadData];
}
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.size = CGSizeMake(KScreenWidth, KCell_H);
        _cancelButton.bottom =KScreenHeight;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor c_GrayColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.width = KScreenWidth;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    }
    return _tableView;
}
#pragma mark - tabel delegate & dataSoure
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return checkStringIsEmty(self.title)?0:KCell_H;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!checkStringIsEmty(self.title)) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KCell_H)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =view.bounds;
        titleLabel.text = self.title;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor blackColor];
        self.titleLabel = titleLabel;
        [view addSubview:titleLabel];
        [view addLine_bottom];
        return view;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KCell_H;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MZCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:AHActionSheetViewIndentifier];
    if (!cell) {
        cell = [[MZCommonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AHActionSheetViewIndentifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, KCell_H)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
        cell.titleLabel = titleLabel;
    }
    [cell setInsetWithX:0];
    UILabel *titleLable =  cell.titleLabel ;

    id object = self.listArray[indexPath.row];
 
    titleLable.text = [NSString stringWithFormat:@"%@",object];

    // 选中背景颜色
//        UIView *selectCellView = [UIView new];
//        selectCellView.backgroundColor = [UIColor yellowColor];
//        cell.selectedBackgroundView = selectCellView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.selectIndex) {
        titleLable.textColor = [UIColor c_GreenColor];
    }else{
        titleLable.textColor = [UIColor blackColor];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.completeBlock ?:self.completeBlock(indexPath.row);
    [self.tableView reloadData];
    [self disMiss];
}
- (void)cancelButtonClickedAction:(UIButton *)sender {
    !self.completeBlock ?:self.completeBlock(-1);
    [self disMiss];
}

- (void) show {
    self.userInteractionEnabled = YES;
    self.tableView.userInteractionEnabled = YES;
    self.cancelButton.userInteractionEnabled = YES;
    self.line.hidden = !self.listArray.count;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        [UIView animateWithDuration:0.35 animations:^{
            self.alpha = 1.f;
            self.cancelButton.bottom = KScreenHeight;
            self.line.bottom = self.cancelButton.top;
            self.tableView.bottom =  self.line.top;
        }];
    });
}
-(void)disMiss{
    @weakify(self)
    [UIView animateWithDuration:KAnimateDuration animations:^{
        @strongify(self)
        self.alpha = 0.f;
        self.line.top = KScreenHeight;
        self.cancelButton.top = KScreenHeight;
        self.tableView.top = KScreenHeight;
    } completion:^(BOOL finished) {
        @strongify(self)
        self.tableView =nil;
        self.cancelButton = nil;
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = touches.anyObject;//获取触摸对象
    if (![touch.view isEqual:self]) {
        return;
    }
    if (self.tapEnadle) {
        !self.completeBlock ?:self.completeBlock(-1);
        [self disMiss];

    }
}

@end
