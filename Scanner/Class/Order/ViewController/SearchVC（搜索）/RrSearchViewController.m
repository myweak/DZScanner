//
//  RrSearchViewController.m
//  Scanner
//
//  Created by edz on 2020/8/5.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrSearchViewController.h"

@interface RrSearchViewController () <UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *historyRecordArr;
@property (nonatomic, strong) UIView *recordView;
@end

@implementation RrSearchViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.tableView.bottom = self.view.bottom;
    self.recordView.bottom = self.view.bottom;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self commitSearchController];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    @weakify(self)
    [self addNavigationButtonImageRight:@"navi_search_icon" RightActionBlock:^{
        @strongify(self)
        [self saveHistoryRecordDataWithKeyWord:self.searchController.searchBar.text];
    }];
    
    
    [self.view addSubview:self.recordView];
    
    
    self.pageNum = 1;
    self.isHeadRefreshing = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        self.isHeadRefreshing = YES;
        [self postHistoryRecordDataWithUrlKeyWord:self.searchController.searchBar.text];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isHeadRefreshing = NO;
        [self postHistoryRecordDataWithUrlKeyWord:self.searchController.searchBar.text];
    }];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    [self updateHistoryRecordView];

    
}

- (NSMutableArray *)historyRecordArr{
    if (!_historyRecordArr) {
        _historyRecordArr = [NSMutableArray array];
    }
    return _historyRecordArr;
}
- (UIView *)recordView{
    if (!_recordView) {
        _recordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth ,KScreenHeight -64)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 27, 300, 20)];
        titleLabel.font = KFont20;
        titleLabel.text = @"最近搜索";
        [_recordView addSubview:titleLabel];
     }
    return _recordView;
}
- (void)updateHistoryRecordView{
    
    self.historyRecordArr = [NSMutableArray arrayWithArray:[self getHistoryRecordList]];

    
    static NSMutableArray *mutLabelArr;
    if (!mutLabelArr) {
        mutLabelArr = [NSMutableArray array];
    }
    
    [mutLabelArr enumerateObjectsUsingBlock:^(UILabel  * label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.historyRecordArr.count) {
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }
    }];
    UILabel *lastLabel;
    @weakify(self)
    for (int i = 0; i< self.historyRecordArr.count; i++) {
        UILabel *label;
        if (i>= mutLabelArr.count) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(18, 77, 0, 36)];
            label.backgroundColor = [@"EEEEF1" getColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = KFont18;
            label.layer.cornerRadius = 18;
            label.layer.masksToBounds = YES;
            [mutLabelArr addObject:label];
        }else{
            label = mutLabelArr[i];
        }
        NSString *key = self.historyRecordArr[i];
        label.text = key;
        [self.recordView addSubview:label];

        CGFloat label_W =  [label getLableHeightWithMaxWidth:300].size.width;
        label.width = label_W+34;
        
        if ((lastLabel.right + label_W)>KFrameWidth-18*2) {//超出屏幕
            label.top = lastLabel.bottom +18;
            label.left = 18;
        }else if (lastLabel) {
            label.top = lastLabel.top;
            label.left = lastLabel.right +18;
        }

        [label handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
            @strongify(self)
            self.searchController.searchBar.text = key;
            [self saveHistoryRecordDataWithKeyWord:self.searchController.searchBar.text];
        }];
        lastLabel = label;
        
    }
}

// 历史搜索数据
- (NSArray *)getHistoryRecordList{
    NSArray *arr = @[];
    if (self.type == RrSearchVCType_product) {
        arr = [TZUserDefaults getArrValueInUDWithKey:KUserDefaul_Key_search_product];
    }else if (self.type == RrSearchVCType_order) {
        arr = [TZUserDefaults getArrValueInUDWithKey:KUserDefaul_Key_search_order];
    }else if (self.type == RrSearchVCType_scanField) {
        arr = [TZUserDefaults getArrValueInUDWithKey:KUserDefaul_Key_search_scanfield];
    }
    return arr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 17)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [MZCommonCell blankCell];
    
}


// MARK: 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无相关数据";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
        NSFontAttributeName:KFont19,
        NSForegroundColorAttributeName:[UIColor c_GrayNotfiColor],
        NSParagraphStyleAttributeName:paragraph
    };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
// 向上偏移量为表头视图高度/2
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -self.tableView.height/2.0+78;
}



- (void)commitSearchController {
    
    self.definesPresentationContext = YES;
    self.extendedLayoutIncludesOpaqueBars  = YES;

    //创建UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.barTintColor = [UIColor c_GreenColor];
    self.searchController.searchBar.tintColor = [UIColor c_GreenColor];
    self.searchController.searchBar.placeholder = @"搜索关键字";
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    //    [_searchController.view addSubview:_searchController.searchBar];
    
    [self makeAppearanceForSearchBar];
    
    self.navigationItem.titleView = self.searchController.searchBar;
    
}
- (UITableView *)tableView{
    
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, (KFrameHeight-64)) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 73;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor mian_BgColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



- (void)makeAppearanceForSearchBar {
    
    UISearchBar *searchBar = self.searchController.searchBar;
    UIView *subView = searchBar.subviews.firstObject;
    [subView setBackgroundColor:[UIColor whiteColor]];
    
    for (id view in subView.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UISearchBarBackground"]) {
            //            UIImageView *imageView = (UIImageView *)view;
            //            [imageView setImage:nil];
            //            [imageView setBackgroundColor:[UIColor magentaColor]];
            //
            //            [[view subviews] firstObject].layer.cornerRadius = 15;
            //            [[view subviews] firstObject].layer.masksToBounds = YES;
            
        }else if ([NSStringFromClass([view class]) isEqualToString:@"_UISearchBarSearchContainerView"]) {
            UIView *ssView = view;
            for (UIView * subView in ssView.subviews) {
                subView.backgroundColor = [UIColor whiteColor];
                [subView addCornerRadius:18];
                subView.layer.borderColor = [UIColor c_GreenColor].CGColor;
                subView.layer.borderWidth = 2.f;
            }
        }
    }
    
    UITextField *txfSearchField = [searchBar valueForKey:@"searchField"];
    if (txfSearchField && [txfSearchField isKindOfClass:[UITextField class]]) {
        txfSearchField.font = [UIFont systemFontOfSize:17];
    }
    
}

#pragma mark -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *keyWord = searchController.searchBar.text;
    if (keyWord.length) {
        [self showSearchReuslt:keyWord];
    } else {
        if(!self.tableView.hidden){
            self.tableView.hidden  =YES;
            @weakify(self)
            self.recordView.alpha = 0;
            self.recordView.hidden = NO;
            [UIView animateWithDuration:1. animations:^{
                @strongify(self)
                self.recordView.alpha = 1;
            }];
        }
    }
}

//    OVERRIDE THIS METHOD
- (void)showSearchReuslt:(NSString *)keyWord {
    
    
}


//键盘搜索 delegate 回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keyWord = searchBar.text;

    [self saveHistoryRecordDataWithKeyWord:keyWord];
  
}

//搜索关键字 处理逻辑
- (void)saveHistoryRecordDataWithKeyWord:(NSString *)keyWord{
    if (checkStrEmty(keyWord)) {
        return;
    }
    
    if ([self.historyRecordArr containsObject:keyWord]) {
        [self.historyRecordArr removeObject:keyWord];
    }
    
    [self.historyRecordArr insertObject:keyWord atIndex:0];
    if (self.historyRecordArr.count >20) { //上线保存20个
        [self.historyRecordArr removeLastObject];
    }
    
    
    if (self.type == RrSearchVCType_product) {
        [TZUserDefaults saveArrValueInUD:self.historyRecordArr forKey:KUserDefaul_Key_search_product];
    }else if (self.type == RrSearchVCType_order) {
        [TZUserDefaults saveArrValueInUD:self.historyRecordArr forKey:KUserDefaul_Key_search_order];
    }else if (self.type == RrSearchVCType_scanField) {
        [TZUserDefaults saveArrValueInUD:self.historyRecordArr forKey:KUserDefaul_Key_search_scanfield];
    }
    
    self.pageNum = 1;
    self.isHeadRefreshing = YES;
    if (self.listArr.count == 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    [self postHistoryRecordDataWithUrlKeyWord:keyWord];

}
// 搜索关键字 url。子类实现
- (void)postHistoryRecordDataWithUrlKeyWord:(NSString *)keyWord{

}

//更新搜索结果
- (void)updateListData{
    @weakify(self)
    self.tableView.alpha = 0;
    self.tableView.hidden = NO;
    self.recordView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.alpha = 1;
    } completion:^(BOOL finished) {
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.tableView reloadData];
            [self updateHistoryRecordView];
        });
    }];
}








@end
