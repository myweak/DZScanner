//
//  MineScanFieldVC.m
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MineScanFieldVC.h"
#import "MineScanFieldCell.h"
#import "FMBDManagerTool.h"
#import "ScanFileModel.h"
#import "JassonSTLVC.h" //文件预览
#import "RrScanFileSearchVC.h"

@interface MineScanFieldVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) BOOL isHeadRefreshing; // 头部刷新

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) UITextField *textFiled ;
@end

@implementation MineScanFieldVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件库";

    [self addTabelView];
    [self.tableView.mj_header beginRefreshing];
    
    //搜索
    @weakify(self)
    [self addNavigationButtonImageRight:@"navi_search_icon" RightActionBlock:^{
        @strongify(self);
        RrScanFileSearchVC *searVc =[RrScanFileSearchVC new];
        searVc.type = RrSearchVCType_scanField;
        searVc.searchTypes = self.type;
        searVc.tapBlock = ^(ScanFileModel *model) {
            !self.tapBlock? :self.tapBlock(model);
        };
        [self.navigationController pushViewController:searVc animated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScanSourceListNotification:) name:KNotification_name_Scan object:nil];
    
}
- (void)updateScanSourceListNotification:(NSNotification *)notify{
    self.pageNum = 1;
    self.isHeadRefreshing =YES;
    [self postScanSourceListUrl];
}

- (void)addTabelView{
    self.pageNum = 1;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([MineScanFieldCell class]) cellIndentifier:KMineScanFieldCell_ID];
    
    @weakify(self)
    self.pageNum = 1;
    self.isHeadRefreshing = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        self.isHeadRefreshing = YES;
        [self postScanSourceListUrl];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isHeadRefreshing = NO;
        [self postScanSourceListUrl];
    }];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}




#pragma  mark - UITableViewDelegate DataSource
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
    
    return iPH(122);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScanFileModel *model = self.listArr[indexPath.section];
    MineScanFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:KMineScanFieldCell_ID forIndexPath:indexPath];
    [cell.imageViewss sd_setImageWithURL:model.preview.url placeholderImage:KPlaceholderImage_product];
    cell.titleLabelss.text = model.name;
    cell.subLabel.text = [model.createTime dateStringFromTimeYMDHMS];
    
    @weakify(self)
    cell.mineScanFieldCellBlock = ^(BOOL isEdite, BOOL isDelete) {
        @strongify(self)
        if (self.type == MineScanFieldVCType_choose) {
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            return;
        }
        if (isEdite) {
            
            
            // 弹窗
            UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"重命名3D扫描文件名称"
                   message: nil
            preferredStyle:UIAlertControllerStyleAlert];
            // 占位符
            [saveAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                @strongify(self)
                self.textFiled = textField;
                textField.placeholder = @"请输入名称";
                [self.textFiled becomeFirstResponder];
                self.textFiled.placeholder = model.name;
                self.textFiled.delegate = self;
                self.textFiled.returnKeyType = UIReturnKeyDone;
            }];
            // 确定按钮
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self)
                [self changeScanSourceUrlWithModel:model];

            }];
            // 取消按钮
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [saveAlert addAction:saveAction];
            [saveAlert addAction:cancelAction];
            [self presentViewController:saveAlert animated:YES completion:nil];

        }else{
            [self AlertWithTitle:@"提示" message:@"是否需要删除文件？" andOthers:@[@"取消",@"确认"] animated:YES action:^(NSInteger index) {
                if (index == 1) {
                    [self deleteScanSourceRULWithModel:model];
                }
            }];
        }
    };
    
    return cell;
}

// MARK: 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无相关产品昵";
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanFileModel *model = self.listArr[indexPath.section];
    if (self.type == MineScanFieldVCType_choose) {
        !self.tapBlock ?: self.tapBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        JassonSTLVC *showVc =[JassonSTLVC new];
        showVc.title = model.name;
        showVc.curFileName = model.sourceUrl;
        [self.navigationController pushViewController:showVc animated:YES];
    }
    
}



#pragma mark textFiled.delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UI
//- (UITextField *)textFiled{
//    if (!_textFiled) {
//        _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(17, 0, iPW(300), 44)];
//        _textFiled.placeholder = @"请输入您要修改的文件名";
//        _textFiled.layer.borderColor = [UIColor c_lineColor].CGColor;
//        _textFiled.layer.borderWidth = 0.5f;
//        _textFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
//        _textFiled.delegate = self;
//        _textFiled.returnKeyType = UIReturnKeyDone;
//        _textFiled.leftViewMode = UITextFieldViewModeAlways;
//
//    }
//    return _textFiled;
//}

- (UITableView *)tableView{
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 120;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor mian_BgColor];
        
    }
    return _tableView;
}

#pragma  mark - 网络url

// 列表数据
- (void)postScanSourceListUrl{
    @weakify(self)
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@(20) forKey:@"pageSize"];
    [parameter setValue:@(self.pageNum) forKey:@"pageNum"];
    [parameter setValue:KisAddEGOCache_value forKey:KisAddEGOCache_Key];
    [[RRNetWorkingManager sharedSessionManager]postScanSourceList:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self);
        if (!error) {
            
            if (self.isHeadRefreshing) {
                self.listArr = [NSMutableArray arrayWithArray:responseModel.list];
            }else{
                [self.listArr addObjectsFromArray:responseModel.list];
            }
            
            RrDataPageModel *pageModel =  responseModel.pageData;
            if ([pageModel.total integerValue] == self.listArr.count && self.listArr.count !=0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            if (responseModel.list.count >0) {
                self.pageNum ++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.tableView reloadData];
            });
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }, [ScanFileModel class])];
}

// 修改 名称
- (void)changeScanSourceUrlWithModel:(ScanFileModel *) model{
    if (checkStrEmty(self.textFiled.text)) {
        showMessage(@"您还没有输入需要修改的名称");
        return;
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.ID forKey:@"id"];
    [parameter setValue:self.textFiled.text forKey:@"name"];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] changeScanSource:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        showMessage(responseModel.msg);
        if (!error) {
            model.name = self.textFiled.text;
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    }, nil)];
    
}
//删除
- (void)deleteScanSourceRULWithModel:(ScanFileModel *) model{
    
    [[RRNetWorkingManager sharedSessionManager] deleteScanSource:@{KKey_1:model.ID} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            [self.listArr removeObject:model];
            [self.tableView reloadData];
        }
        showMessage(responseModel.msg);
    }, nil)];
    
}




@end
