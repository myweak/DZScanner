//
//  RrMineAddressVC.m
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineAddressVC.h"
#import "RrMineEditeAddressVC.h" // 编辑地址
#import "RrMineAddressCell.h"
#import "RrMineAddressMdoel.h"
@interface RrMineAddressVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation RrMineAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.title = @"收货地址";
    [self.view addSubview:self.tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        
        [self getAdressListUrl];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    [self addNavigationButtonRight:@"添加新地址" RightActionBlock:^{
        @strongify(self);
        RrMineEditeAddressVC *editeVc =[RrMineEditeAddressVC new];
        editeVc.type = RrMineEditeAddressType_add;
        editeVc.title = @"添加新地址";
        editeVc.backSaveSucceedBlock = ^{
            @strongify(self);
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:editeVc animated:YES];
    }];
    
}

#pragma mark -  tabelview 侧滑删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return   UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return YES;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
        return NO;
}


//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    RrMineAddressMdoel *model = self.dataArr[indexPath.section];
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self deleteAddressUrlWith:model];
    }
    
}

#pragma mark - tabelview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
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
    @weakify(self)
    RrMineAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrMineAddressCell_ID forIndexPath:indexPath];
    RrMineAddressMdoel *model = self.dataArr[indexPath.section];
    cell.model = model;
    cell.tapediteBtnAction = ^{
        @strongify(self)
        RrMineEditeAddressVC *editeVc =[RrMineEditeAddressVC new];
        editeVc.type = RrMineEditeAddressType_edit;
        editeVc.title = @"编辑地址";
        editeVc.addreModel = model;
        editeVc.backSaveSucceedBlock = ^{
            [self getAdressListUrl];
        };
        [self.navigationController pushViewController:editeVc animated:YES];
    };
    
    return cell;
    
}


// MARK: 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没有收获地址，快去添加吧！";
    
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
    return -64;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"去添加地址";
       
       NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
       paragraph.lineBreakMode = NSLineBreakByWordWrapping;
       paragraph.alignment = NSTextAlignmentCenter;
       
       NSDictionary *attributes = @{
           NSFontAttributeName:KFont19,
           NSForegroundColorAttributeName:[UIColor c_GreenColor],
           NSParagraphStyleAttributeName:paragraph
       };
       
       return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    @weakify(self)
  RrMineEditeAddressVC *editeVc =[RrMineEditeAddressVC new];
        editeVc.type = RrMineEditeAddressType_add;
        editeVc.title = @"添加新地址";
        editeVc.backSaveSucceedBlock = ^{
            @strongify(self);
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:editeVc animated:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RrMineAddressMdoel *model = self.dataArr[indexPath.section];
    if ([self.delegate respondsToSelector:@selector(rrMineAddressVCSelectAddress:AddreId:)]) {
        aUser.userAddressMdoel = model;
        NSString *addreStr = [NSString stringWithFormat:@"%@ %@ %@ %@",model.provinceDesc,model.cityDesc,model.areaDesc,model.addrDetail];
        [self.delegate rrMineAddressVCSelectAddress:addreStr AddreId:model.ID];
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark UI

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
        
        [_tableView registerNibString:NSStringFromClass([RrMineAddressCell class]) cellIndentifier:KRrMineAddressCell_ID];
        
        //        _tableView.separatorInset = UIEdgeInsetsMake(0, iPW(53), 0, iPW(72));
    }
    return _tableView;
}

#pragma mark - 网络 URL
- (void)getAdressListUrl{
    //    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    @weakify(self)
    [[RRNetWorkingManager sharedSessionManager] getAddressList:@{KisAddEGOCache_Key:KisAddEGOCache_value} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        @strongify(self)
        if (!error) {
            self.dataArr = [NSMutableArray arrayWithArray: responseModel.list];
            [self.tableView reloadData];
        }else{
            showTopMessage(responseModel.msg);
        }
        if (!responseModel.isCashEQO) {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
        }
        [self.dataArr enumerateObjectsUsingBlock:^(RrMineAddressMdoel   *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([aUser.userAddressMdoel.ID isEqualToString:model.ID]) {
                aUser.userAddressMdoel = model;
                return;
            };
        }];
        if (self.dataArr.count == 0) {
            aUser.userAddressMdoel = nil;
        }
        
    }, [RrMineAddressMdoel class])];
}


//删除地址
- (void)deleteAddressUrlWith:(RrMineAddressMdoel *) model{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.ID forKey:@"id"];
    [[RRNetWorkingManager sharedSessionManager] deleteAdressList:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            if ([aUser.userAddressMdoel.ID isEqualToString:model.ID]) {
                aUser.userAddressMdoel = nil;
            };
            [self.dataArr removeObject:model];
            [self.tableView reloadData];
        }
        showMessage(responseModel.msg);
    }, nil)];
}

@end
