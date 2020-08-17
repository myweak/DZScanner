//
//  RrMineOrderListDetailEdittingVC.m
//  Scanner
//
//  Created by edz on 2020/7/31.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KUserInfo    @"用户信息"
#define KData        @"测量数据"
#define KScan        @"3D扫描"

#import "RrMineOrderListDetailEdittingVC.h"
#import "RrAddImageView.h" // 添加➕ view

//3D扫描文件
#import "JassonSTLVC.h"
#import "ScanFileModel.h"
#import "MineScanFieldVC.h" // 文件库

@interface RrMineOrderListDetailEdittingVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) RrAddImageView *addView_data;
@property (nonatomic, strong) RrAddImageView *addView_scan;

@property (nonatomic, strong) NSMutableArray *dataImageUrlArr; // 测量数据 image url
@property (nonatomic, strong) NSMutableArray *scanImageUrlArr; // 3d扫描 image url
@property (nonatomic, strong) NSMutableArray *scanSourceUrlArr; // 3D 预览数据 URL
@end

@implementation RrMineOrderListDetailEdittingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.dataArr = [NSMutableArray arrayWithArray:@[KUserInfo,KData,KScan,KCell_Space]];
    
    if (self.model) {
        [self configeData];
        [self addTabelView];
    }else{
        [self getUserChckeOrderDetailUrl];
    }
    
    @weakify(self)
    [self.notNetWorkView.tapViewBg handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
        @strongify(self)
        [self getUserChckeOrderDetailUrl];
    }];
    
    UIButton *bottomBtn = [self addBottomBtnWithTitle:@"提交" actionBlock:^(UIButton * _Nonnull btn) {
        @strongify(self)
        [self postChangeOrderStatus];
    }];
    self.tableView.height = bottomBtn.top;
    
    
}

- (void)configeData{
    //测量数据
    self.dataImageUrlArr = [NSMutableArray arrayWithArray:[self.model.attachment componentsSeparatedByString:@","]];
    self.addView_data.addPView.imageUrl =  self.dataImageUrlArr;
    
    // 3D文件
    self.scanImageUrlArr = [NSMutableArray array]; // 图片 url数据
    self.scanSourceUrlArr = [NSMutableArray array]; // 预览资源 URL 数据
    NSArray *scanArr = [self.model.otherAttachment componentsSeparatedByString:@","];
    
    for (int i = 0; i<scanArr.count; i++) {
        if ((i+1)%2 == 1) {
            [self.scanImageUrlArr addObject:scanArr[i]];
        }else{
            [self.scanSourceUrlArr addObject:scanArr[i]];
        }
    }
    
    self.addView_scan.addPView.imageUrl = self.scanImageUrlArr;
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.addView_data.addPView updateAddPhotoView];
        [self.addView_scan.addPView updateAddPhotoView];
        
        [self.tableView reloadData];
    });
    
    
}

- (void)addTabelView{
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([RrCommonRowCell class]) cellIndentifier:RrCommonRowCell_ID];
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


- (RrAddImageView *)addView_data{
    if (!_addView_data) {
        _addView_data = [[RrAddImageView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-17*2, 275)];
        _addView_data.titleLabel.text = KData;
        _addView_data.addPView.photoW = iPH(159);
        _addView_data.addPView.isCanEdite = YES;
        @weakify(self)
        _addView_data.complemntBlock = ^(RrAddImageView *photoView) {
            @strongify(self)
            self.addView_data.height = photoView.height+53 ;
            [self.tableView reloadData];
        };
    }
    return _addView_data;
}
- (RrAddImageView *)addView_scan{
    if (!_addView_scan) {
        _addView_scan = [[RrAddImageView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-17*2, 275)];
        _addView_scan.titleLabel.text = KScan;
        _addView_scan.addPView.isCanEdite = YES;
        @weakify(self)
        _addView_scan.complemntBlock = ^(RrAddImageView *photoView) {
            @strongify(self)
            self.addView_scan.height = photoView.height+53 ;
            [self.tableView reloadData];
        };
        _addView_scan.addPView.photoW = iPH(159);

        //1.点击添查看
        _addView_scan.addPView.addPhotoViewSelectedBlock = ^(NSInteger index) {
            @strongify(self)
            JassonSTLVC *showVc =[JassonSTLVC new];
            showVc.curFileName = self.scanSourceUrlArr[index];
            [self.navigationController pushViewController:showVc animated:YES];
        };
        
        // 1.点击添加 Block
        _addView_scan.addPView.onTapAddBtnBlock = ^(AddPhotoView * photoView) {
            @strongify(self)
            MineScanFieldVC * file =[MineScanFieldVC new];
            file.type = MineScanFieldVCType_choose;
            file.tapBlock = ^(ScanFileModel *model) {
                @strongify(self)
                [self.scanImageUrlArr addObject:model.preview];
                [self.scanSourceUrlArr addObject:model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    self.addView_scan.addPView.imageUrl = self.scanImageUrlArr;
                    [self.addView_scan.addPView updateAddPhotoView];
                });
            };
            [self.navigationController pushViewController:file animated:YES];
        };
        
        // 2.点击删除 Block
        _addView_scan.addPView.deleteSourceBlock = ^(UIImageView * photoView) {
            @strongify(self)
            NSInteger index = photoView.tag;
            if (index >= self.scanImageUrlArr.count) {
                return;
            }
            [self.scanImageUrlArr removeObjectAtIndex:index];
            [self.scanSourceUrlArr removeObjectAtIndex:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                self.addView_scan.addPView.imageUrl = self.scanImageUrlArr;
                [self.addView_scan.addPView updateAddPhotoView];
            });
        };
        
    }
    return _addView_scan;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *title = self.dataArr[section];
    if ([title isEqualToString:KUserInfo]) {
        return 3;
    }
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
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = self.dataArr[indexPath.section];
    if ([title isEqualToString:KUserInfo]) {
        if (indexPath.row ==0) {
            return 53;
        }else{
            return 70;
        }
    }else if ([title isEqualToString:KData]) {
        return self.addView_data.height;
    }else if ([title isEqualToString:KScan]) {
        return self.addView_scan.height;
    }
    return 122;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.section];
    @weakify(self)
    if ([title isEqualToString:KUserInfo]) {
        RrCommonRowCell *cell = [tableView dequeueReusableCellWithIdentifier:RrCommonRowCell_ID forIndexPath:indexPath];
        cell.mainTitleLabel_X.constant = 17;
        if (indexPath.row ==0) {
            [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:7.0f];
            cell.mainTitleLabel.text = KUserInfo;
        }else if (indexPath.row ==1) {
            cell.bottonLineView.hidden = NO;
            cell.mainTitleLabel.text = @"姓名";
            cell.rightLabel.text =self.model.patientName;
        }else if (indexPath.row ==2) {
            [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:7.0f];
            cell.mainTitleLabel.text = @"联系方式";
            cell.rightLabel.text = self.model.patientPhone;
        }
        return cell;
    }else if ([title isEqualToString:KData]) {
        MZCommonCell *cell = [MZCommonCell blankClearCell];
        [cell.contentView addSubview:self.addView_data];
        return cell;
    }else if ([title isEqualToString:KScan]) {
        MZCommonCell *cell = [MZCommonCell blankClearCell];
        [cell.contentView addSubview:self.addView_scan];
        return cell;
    }
    
    return [MZCommonCell blankClearCell];
    
}


#pragma mark - addPhotoViewDelegate
- (void)addPhotoView:(AddPhotoView *)addView selectedImageViewIndex:(NSInteger)index
{
    if ((addView == self.addView_scan.addPView) && (index < self.scanSourceUrlArr.count)) {
        JassonSTLVC *showVc =[JassonSTLVC new];
        showVc.curFileName = self.scanSourceUrlArr[index];
        [self.navigationController pushViewController:showVc animated:YES];
    }
    
}

#pragma  mark - 网络 url
- (void)postChangeOrderStatus{
    
    if(self.dataImageUrlArr.count == 0){
        showMessage(@"请上传测量数据");
        return;
    }else  if(self.scanImageUrlArr.count == 0){
        showMessage(@"请上传3D扫描文件");
        return;
    }
    
    // 七牛
    @weakify(self)
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[MZAssetsManager shareManager] uploadCurrentAssetsWithCompletion:^(BOOL succeed, id imageDatas, id videoDatas) {
        @strongify(self)
        if (succeed) {
            if (imageDatas) {
                [imageDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *url =  [obj valueForKey:@"path"];
                    [self.dataImageUrlArr addObject:[url imageUrlStr]];
                }];
            }
        }else{
            showMessage(@"上传证件照失败，请重新上传");
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    
    // 测量数据
    NSString *attachment = [self.dataImageUrlArr componentsJoinedByString:@","];
    self.model.attachment = attachment;
    
    //3d 扫描文件
    NSMutableArray *scanMutArr = [NSMutableArray array];
    [self.scanImageUrlArr enumerateObjectsUsingBlock:^(NSString *imageUrlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        [scanMutArr addObject:imageUrlStr];
        [scanMutArr addObject:self.scanSourceUrlArr[idx]];
    }];
    
    NSString *otherAttachment = [scanMutArr componentsJoinedByString:@","];
    self.model.otherAttachment = otherAttachment;
    
    [self changeOrderStatusUrlWithModel:self.model];
}

#pragma mark -网络 Url
- (void)getUserChckeOrderDetailUrl{
    @weakify(self)
    [[RRNetWorkingManager sharedSessionManager] getUserChckeOrderDetail:@{KKey_1:self.outTradeNo,KisAddEGOCache_Key:KisAddEGOCache_value} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self)
        if (!error) {
            self.notNetWorkView.hidden = YES;
            self.model = (RrDidProductDeTailModel *)responseModel.item;
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self configeData];
                [self addTabelView];
            });
        }else{
            self.notNetWorkView.hidden = NO;
            showMessage(responseModel.msg);
        }
        
        [SVProgressHUD dismiss];
    }, [RrDidProductDeTailModel class])];
}


/**
 orderStatus=0  取消订单
 orderStatus=2  完善测量数据
 orderStatus=7  确认收货
 */
- (void)changeOrderStatusUrlWithModel:(RrDidProductDeTailModel *)model{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.outTradeNo forKey:@"outTradeNo"];
    [parameter setValue:@(2) forKey:@"orderStatus"];
    [parameter setValue:self.model.attachment forKey:@"attachment"];      // 附件,逗号分割
    [parameter setValue:self.model.otherAttachment forKey:@"otherAttachment"]; // 3d打印附件（用‘，’隔开）
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] changeOrderStatus:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            KPostNotification(KNotification_name_updateOrder_list, nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
        [SVProgressHUD dismiss];
        showMessage(responseModel.msg);
    }, nil)];
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
