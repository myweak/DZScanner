//
//  RrOrderListDetailVC.m
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderListDetailVC.h"
#import "RrPostOrderListDetailVC.h"
#import "RrOrderListDetailCell.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface RrOrderListDetailVC ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat webView_height;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation RrOrderListDetailVC

- (void)viewDidAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"商品详情"]; //("Pagename"为页面名称，可自定义)
}


- (void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"商品详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView_height  = 20;
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([RrOrderListDetailCell class]) cellIndentifier:KRrOrderListDetailCell_ID];
    [self getProductDetailUrl];
    if (self.type == RrOrderListDetailVCType_nomal) {
        @weakify(self);
        UIButton *btn = [self addBottomBtnWithTitle:@"立即定制" actionBlock:^(UIButton * _Nonnull btn) {
            @strongify(self)
            RrPostOrderListDetailVC *detailVc =[RrPostOrderListDetailVC new];
            detailVc.productModel = self.productModel;
            detailVc.title = self.productModel.name;
            [self.navigationController pushViewController:detailVc animated:YES];
        }];
        self.tableView.height = btn.top;
    }
    
}


#pragma  mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 355 + (KFrameHeight - 64-82-50);
    return 355 + self.webView_height;
    //    return 356 + [RrOrderListDetailCell getDetailLabelHightWithStr:self.productModel.Description];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RrOrderListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderListDetailCell_ID forIndexPath:indexPath];
    [cell.imageViews sd_setImageWithURL:self.productModel.icon.url placeholderImage:KPlaceholderImage_product];
    cell.titleLabels.text = [NSString stringWithFormat:@"%@  %@",self.productModel.name,self.productModel.productCode];
    cell.subLabel.text = self.productModel.productAbstract;
    cell.priceLabel.text = [NSString stringWithFormat:@"小计：￥%@",self.productModel.productPrice];
    if (!self.webView && self.productModel.Description != nil) {
        self.webView = cell.webView;
        [cell.webView loadHTMLString:self.productModel.Description baseURL:nil];
        cell.webView.navigationDelegate = self;
    }

    return cell;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    @weakify(self)
    [webView evaluateJavaScript:@"Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        @strongify(self)
        if (!error) {
            NSNumber *height = result;
            webView.height = [height floatValue];
            self.webView_height = webView.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.tableView reloadData];
            });
            
        }
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark UI
- (UITableView *)tableView{
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 51;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView addLine_left];
        [_tableView addLine_right];
    }
    return _tableView;
}

//不需要 上个界面传过来了
- (void)getProductDetailUrl{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[RRNetWorkingManager sharedSessionManager] getProductDetail:@{KKey_1:self.productModel.ID} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            self.productModel = (RrOrderItemsListModel*)responseModel.item;
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    }, [RrOrderItemsListModel class])];
}


@end
