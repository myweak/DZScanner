//
//  RrPostOrderListDetailVC.m
//  Scanner
//
//  Created by edz on 2020/7/17.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#import "RrPostOrderListDetailVC.h"
#import "RrDidProductDeTailModel.h"
#import "RrOrderDetailUserInfoCell.h" // 个人信息cell
#import "RrOrderItemsListCell.h" // 商品cell
#import "RrMineAddressVC.h" // 地址列表
#import "RrOrderPayTypeCell.h" // 支付类型cell
#import "RrOrderRemarkCell.h" // 备注
#import "AddPhotoView.h"
#import "JassonSTLVC.h" // 预览3d文件
#import "MineScanFieldVC.h" // 文件库
#import "ScanFileModel.h"
#import "RrOrderListDetailVC.h" // 商品详情
#import "RrOfflinePayTypeCell.h" // 线下支付
#import "RrAddImageView.h"
#import "RrMineAddressMdoel.h" // 收货地址model
@interface RrPostOrderListDetailVC ()<UITableViewDelegate,UITableViewDataSource,RrMineAddressVCDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  NSArray *listArr;
@property (nonatomic, strong) RrDidProductDeTailModel *postModel; //提交数据模型
@property (nonatomic, strong) UIView *addPhoneView; // 上传测量数据
@property (nonatomic, strong) AddPhotoView *addPView;// 上传测量数据cell  添加View


@property (nonatomic, strong) RrAddImageView *addView_scan; // 上传3D扫描

@property (nonatomic, strong) NSMutableArray *scanArr; // 3D扫描 url
@property (nonatomic, strong) NSMutableArray *scanModelArr; // 3D扫描模型

@property (nonatomic, assign) CGFloat postCerCll_h; // 上传凭证 cell 高
@property (nonatomic, strong) AddPhotoView *addPostCerView;// 上传凭证 cell  添加View

@property (nonatomic, assign)   BOOL imageUrlPass_pay;
@property (nonatomic, assign)   BOOL imageUrlPass_data;


@end

@implementation RrPostOrderListDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    //初始化数据
    self.postModel = [RrDidProductDeTailModel new];
    self.postModel.productId = self.productModel.ID;
    self.postModel.payType = @(1); // 默认支付方式
    self.postCerCll_h = 230;
    
    [self getAdressListUrl];
    
    @weakify(self);
    UIButton *btn = [self addBottomBtnWithTitle:@"提交" actionBlock:^(UIButton * _Nonnull btn) {
        @strongify(self)
        [self postOrderDetail];
        
    }];
    self.tableView.height = btn.top;
    
    
    
}
- (NSMutableArray *)scanArr{
    if (!_scanArr) {
        _scanArr = [NSMutableArray array];
    }
    return _scanArr;
}
- (NSMutableArray *)scanModelArr{
    if (!_scanModelArr) {
        _scanModelArr = [NSMutableArray array];
    }
    return _scanModelArr;
}



- (void)addTableView{
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([RrOrderDetailUserInfoCell class]) cellIndentifier:KRrOrderDetailUserInfoCell_ID];
    [self.tableView registerNibString:NSStringFromClass([RrOrderItemsListCell class]) cellIndentifier:KRrOrderItemsListCell_ID];
    
    [self.tableView registerNibString:NSStringFromClass([RrOrderPayTypeCell class]) cellIndentifier:KRrOrderPayTypeCell_ID];
    [self.tableView registerNibString:NSStringFromClass([RrOfflinePayTypeCell class]) cellIndentifier:KRrOfflinePayTypeCell_ID];
    
    
    [self.tableView registerNibString:NSStringFromClass([RrOrderRemarkCell class]) cellIndentifier:KRrOrderRemarkCell_ID];
    
    
    
    
}


# pragma mark - RrMineAddressVCDelegate
- (void)rrMineAddressVCSelectAddress:(NSString *)address AddreId:(NSString *)addreId{
    self.postModel.doctorAddr = address;
    self.postModel.addrId = addreId;
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.tableView reloadData];

    });
}

#pragma  mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2){
        return 2;
    }
    return  1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 17;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 17)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 235;
    }else if(indexPath.section == 1){
        return 154;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            return 154;
        }else{
            return [self.postModel.payType integerValue] == 1 ? 0.01f:self.postCerCll_h;
        }
        
    }else if(indexPath.section == 3){
        return self.addPhoneView.height;
        
    }else if(indexPath.section == 4){
        return self.addView_scan.height;
        
    }else if(indexPath.section == 5){
        return 160;
        
    }
    return 119;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.section == 0) {
        RrOrderDetailUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderDetailUserInfoCell_ID forIndexPath:indexPath];
        cell.nameTextField.text = self.postModel.patientName;
        cell.phoneTextField.text = self.postModel.patientPhone;
        cell.addressTextField.text = self.postModel.doctorAddr;
        cell.postModel = self.postModel;
        [cell.addressViewBg handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
            @strongify(self);
            [self.view endEditing:YES];
            RrMineAddressVC *addreVc = [RrMineAddressVC new];
            addreVc.delegate = self;
            [self.navigationController pushViewController:addreVc animated:YES];
        }];
        return cell;
    }else if (indexPath.section == 1){
        RrOrderItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderItemsListCell_ID forIndexPath:indexPath];
        [cell.lfteImageView sd_setImageWithURL:self.productModel.icon.url placeholderImage:KPlaceholderImage_product];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@  %@",self.productModel.name,self.productModel.productCode];
        cell.subTitleLabel.text = self.productModel.productAbstract;
        cell.moneyTitleLabel.hidden = NO;
        cell.moneyLabel.hidden = NO;
        cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.productModel.productPrice];
        return cell;
    }else if(indexPath.section ==2){ //选择支付方式
        if (indexPath.row == 0) {
            RrOrderPayTypeCell  *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderPayTypeCell_ID forIndexPath:indexPath];
            cell.postModel = self.postModel;
            cell.onTapPayTypeBlock = ^(UIButton *lefBtn, UIButton *rightBtn) {
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                [tableView reloadRowsAtIndexPaths:@[indexP] withRowAnimation:(UITableViewRowAnimationNone)];
            };
            return cell;
        }else{
            RrOfflinePayTypeCell  *cell = [tableView dequeueReusableCellWithIdentifier:KRrOfflinePayTypeCell_ID forIndexPath:indexPath];
            cell.postModel = self.postModel;
            self.addPostCerView = cell.addPhotoView;
            cell.addPhotoView.complemntBlock = ^(AddPhotoView *photoView) {
                @strongify(self);
                self.postCerCll_h =  230 - 85 + photoView.height;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageUrlPass_pay = NO;
                    [tableView reloadData];
                    cell.addPhotoView_H.constant = self.postCerCll_h;
                });
                
            };
            return cell;
        }
        
    }else if(indexPath.section ==3){
        MZCommonCell  *cell = [MZCommonCell blankCell];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.addPhoneView];
        return cell;
    }else if(indexPath.section ==4){
        MZCommonCell  *cell = [MZCommonCell blankCell];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.addView_scan];
        return cell;
    }else if(indexPath.section ==5){
        RrOrderRemarkCell  *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderRemarkCell_ID forIndexPath:indexPath];
        cell.postModel = self.postModel;
        cell.textView.text = self.postModel.remark;
        return cell;
    }
    
    MZCommonCell *cell =  [MZCommonCell blankCell];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        RrOrderListDetailVC *detailVc =[RrOrderListDetailVC new];
        detailVc.title = self.productModel.name;
        detailVc.productModel = self.productModel;
        detailVc.type = RrOrderListDetailVCType_show;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
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
        _tableView.backgroundColor = [UIColor mian_BgColor];
        [_tableView addLine_left];
        [_tableView addLine_right];
    }
    return _tableView;
}

//上传测量数据
- (UIView *)addPhoneView{
    if (!_addPhoneView) {
        _addPhoneView = [[UIView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-34, 186)];
        _addPhoneView.backgroundColor = [UIColor whiteColor];
        [_addPhoneView addCornerRadius:7.0f];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 17, 300, 21)];
        titleLabel.text = @"上传测量数据";
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textColor = [UIColor c_mianblackColor];
        [_addPhoneView addSubview:titleLabel];
        @weakify(self)
        AddPhotoView *addPView = [[AddPhotoView alloc] initWithFrame:CGRectMake(iPH(20), titleLabel.bottom+ iPH(18), _addPhoneView.width -iPH(20)*2, iPH(85))];
        addPView.complemntBlock = ^(AddPhotoView *photoView) {
            @strongify(self)
            self.addPhoneView.height = photoView.bottom + iPH(31);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                self.imageUrlPass_data = NO;
                [self.tableView reloadData];
            });
        };
        self.addPView = addPView;
        [_addPhoneView addSubview:addPView];
        
    }
    return _addPhoneView;
}



//上传3D扫描
- (RrAddImageView *)addView_scan{
    if (!_addView_scan) {
        _addView_scan = [[RrAddImageView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-17*2, 196)];
        _addView_scan.titleLabel.text = @"上传3D扫描";
        _addView_scan.addPView.isCanEdite = YES;
        @weakify(self)
        _addView_scan.complemntBlock = ^(RrAddImageView *photoView) {
            @strongify(self)
            self.addView_scan.height = photoView.height+32;
            [self.tableView reloadData];
        };
        _addView_scan.addPView.photoW = iPH(85);

        //1.点击添查看
        _addView_scan.addPView.addPhotoViewSelectedBlock = ^(NSInteger index) {
            @strongify(self)
            ScanFileModel *model = self.scanModelArr[index];
            JassonSTLVC *showVc =[JassonSTLVC new];
            showVc.title = model.name;
            showVc.curFileName = model.sourceUrl;
            [self.navigationController pushViewController:showVc animated:YES];
        };
        
        // 1.点击添加 Block
        _addView_scan.addPView.onTapAddBtnBlock = ^(AddPhotoView * photoView) {
            @strongify(self)
            MineScanFieldVC * file =[MineScanFieldVC new];
            file.type = MineScanFieldVCType_choose;
            file.tapBlock = ^(ScanFileModel *model) {
                @strongify(self)
                [self.scanArr addObject:model.preview];
                [self.scanModelArr addObject:model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    self.addView_scan.addPView.imageUrl = self.scanArr;
                    [self.addView_scan.addPView updateAddPhotoView];
                });
            };
            [self.navigationController pushViewController:file animated:YES];
        };
        
        // 2.点击删除 Block
        _addView_scan.addPView.deleteSourceBlock = ^(UIImageView * photoView) {
            @strongify(self)
            NSInteger index = photoView.tag;
            if (index >= self.scanArr.count) {
                return;
            }
            [self.scanArr removeObjectAtIndex:index];
            [self.scanModelArr removeObjectAtIndex:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                self.addView_scan.addPView.imageUrl = self.scanArr;
                [self.addView_scan.addPView updateAddPhotoView];
            });
        };
        
    }
    return _addView_scan;
}







#pragma mark -网络 Url

// 1. 上传订单数据 判断
- (void)postOrderDetail{

    
    if (checkStringIsEmty(self.postModel.patientName)) {
        showMessage(@"请输入姓名");
        return;
    }else if(checkStringIsEmty(self.postModel.patientPhone)){
        showMessage(@"请输入联系方式");
        return;
    }else if(checkStringIsEmty(self.postModel.addrId)){
        showMessage(@"请选择您的地址");
        return;
    }
    
    if([self.postModel.payType intValue] == 2){ //2线下支付
       if ([self.addPostCerView.manger.currentAssets count] == 0){
           showMessage(@"请选择上传支付凭证");
           return;
       }else if(checkStringIsEmty(self.postModel.AactualReceipts)){
            showTopMessage(@"请填写线下支付金额");
            return;
        }
    }
    
    if([self.addPView.manger.currentAssets count] == 0){
        showMessage(@"请上传您的测量数据");
        return;
    }else if(self.scanArr.count == 0){
        showMessage(@"请上传您3D扫描");
        return;
    }
    NSMutableArray *scanMutArr = [NSMutableArray array];
    [self.scanModelArr enumerateObjectsUsingBlock:^(ScanFileModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [scanMutArr addObject:model.preview];
        [scanMutArr addObject:model.sourceUrl];
    }];
    NSString *otherAttachment = [scanMutArr componentsJoinedByString:@","];
    self.postModel.otherAttachment = otherAttachment;
    
    [self postQiNiuAll:YES];
}


// 2. 上传图片数据到 七牛 update_next:yes 表示有上传失败的自动再次 上传一次
- (void)postQiNiuAll:(BOOL) update_next{
    
 [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

  static  NSMutableArray *mutArrUrl1;
  static  NSMutableArray *mutArrUrl2 ;
    
    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
    dispatch_group_t group = dispatch_group_create();
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    @weakify(self)
    dispatch_group_async(group, queue, ^{
        // 循环上传数据
        
        // 1.七🐂 上传支付凭证 image ----------------------------------
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        if (!self.imageUrlPass_pay) {
            mutArrUrl1 = [NSMutableArray array];
            [ self.addPostCerView.manger uploadCurrentAssetsWithCompletion:^(BOOL succeed, id imageDatas, id videoDatas) {
                if (succeed) {
                    if (imageDatas) {
                        [imageDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *url =  [obj valueForKey:@"path"];
                            [mutArrUrl1 addObject:[url imageUrlStr]];
                        }];
                    }
                }
                // 请求成功发送信号量(+1)
                dispatch_semaphore_signal(semaphore);
            }];
        }else{
            dispatch_semaphore_signal(semaphore);
        }
        
        
        
        // 2.七🐂 上传测量数据 image ----------------------------------
        dispatch_semaphore_t semaphore2 = dispatch_semaphore_create(0);
        if (!self.imageUrlPass_data) {
             mutArrUrl2 = [NSMutableArray array];
            [self.addPView.manger uploadCurrentAssetsWithCompletion:^(BOOL succeed, id imageDatas, id videoDatas) {
                if (succeed) {
                    if (imageDatas) {
                        [imageDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *url =  [obj valueForKey:@"path"];
                            [mutArrUrl2 addObject:[url imageUrlStr]];
                            
                        }];
                    }
                }
                // 请求成功发送信号量(+1)
                dispatch_semaphore_signal(semaphore2);
            }];
        }else{
            dispatch_semaphore_signal(semaphore2);
        }
        
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER);
//        dispatch_semaphore_wait(semaphore3, DISPATCH_TIME_FOREVER);
        
        
    });
    
    
    
    // 当所有队列执行完成之后
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行下面的判断代码
        if (mutArrUrl1.count == [self.addPostCerView.manger.currentAssets count]) {
            // 返回主线程进行界面上的修改
            self.imageUrlPass_pay = YES;
            NSString *certimg1 = [mutArrUrl1 componentsJoinedByString:@","];
            self.postModel.payImg = certimg1;

        }
        
        if (mutArrUrl2.count == [self.addPView.manger.currentAssets count]) {
            // 返回主线程进行界面上的修改
            self.imageUrlPass_data = YES;
            NSString *certimg2 = [mutArrUrl2 componentsJoinedByString:@","];
             self.postModel.attachment = certimg2;
        }
        
        
        if (mutArrUrl1.count != [self.addPostCerView.manger.currentAssets count]) {
            self.imageUrlPass_pay = NO;
        }else  if (mutArrUrl2.count != [self.addPView.manger.currentAssets count]) {
            self.imageUrlPass_data = NO;
        }
        
        if (! self.imageUrlPass_pay || ! self.imageUrlPass_data ) {
            if (update_next) {
                 [self postQiNiuAll:NO];
            }else{
                if (mutArrUrl1.count != [self.addPostCerView.manger.currentAssets count]) {
                    showMessage(@"上传支付凭证失败");
                }else  if (mutArrUrl2.count != [self.addPView.manger.currentAssets count]) {
                    showMessage(@"上传测量数据失败");
                }
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self PostProductDetailUrlParameter];
            });
        }
        
    });
    
}



// 3.上传订单数据  接口
- (void)PostProductDetailUrlParameter{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.postModel.payType forKey:@"payType"];         // 支付方式:1在线支付，2线下支付
    [parameter setValue:self.postModel.patientPhone forKey:@"patientPhone"];    // 用户手机
    [parameter setValue:self.postModel.patientName forKey:@"patientName"];      //  用户姓名
    [parameter setValue:self.postModel.addrId forKey:@"addrId"];          // 工作人员地址 id
    [parameter setValue:self.postModel.attachment forKey:@"attachment"];      // 附件,逗号分割
    [parameter setValue:self.postModel.otherAttachment forKey:@"otherAttachment"]; // 3d打印附件（用‘，’隔开）
    [parameter setValue:self.productModel.ID forKey:@"productId"];       // 产品主键
    [parameter setValue:self.postModel.remark forKey:@"remark"];          // 订单备注
    [parameter setValue:self.postModel.payImg forKey:@"payImg"];          // 支付凭证，多个逗号分隔
    [parameter setValue:self.postModel.AactualReceipts forKey:@"actualReceipts"];  //线下支付金额
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] postChckeOrderDetail:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            //通知更新订单列表，防止并行操作 订单列表为刷新
            KPostNotification(KNotification_name_updateOrder_list, nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
        [SVProgressHUD dismiss];
        showMessage(responseModel.msg);
    }, nil)];
}



//获取默认地址
- (void)getAdressListUrl{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[RRNetWorkingManager sharedSessionManager] getAddressList:@{KisAddEGOCache_Key:KisAddEGOCache_value} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            NSArray *arr =  responseModel.list;
            if ([arr count] >0) {
                RrMineAddressMdoel *model = [arr firstObject];
                NSString *addreStr = [NSString stringWithFormat:@"%@ %@ %@ %@",model.provinceDesc,model.cityDesc,model.areaDesc,model.addrDetail];
                self.postModel.doctorAddr = addreStr;
                self.postModel.addrId = model.ID;
                @weakify(self)
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    [self.tableView reloadData];
                });
            }
            

        }else{
            showTopMessage(responseModel.msg);
        }
    }, [RrMineAddressMdoel class])];
}

@end
