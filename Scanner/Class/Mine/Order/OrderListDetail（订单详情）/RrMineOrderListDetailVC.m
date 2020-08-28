//
//  RrMineOrderListDetailVC.m
//  Scanner
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define KUserInfo    @"用户信息"
#define KData        @"测量数据"
#define KScan        @"3D扫描"
#define KPay         @"支付凭证"
#define KPayType     @"支付方式"
#define KProduct     @"产品信息"
#define KOrderConten @"订单信息"

#import "RrMineOrderListDetailVC.h"
#import "RrDidProductDeTailModel.h"
#import "RrAddImageView.h" // 添加➕ view
#import "RrOrderItemsListCell.h" // 产品
#import "RrMineOrderDetailAdressCell.h" // 地址
#import "RrOrderLabelView.h"
#import "RrOrderPayTypeCell.h"
//3D扫描文件
#import "JassonSTLVC.h"
#import "ScanFileModel.h"

#import "RrMineOrderListDetailEdittingVC.h" //修改信息

@interface RrMineOrderListDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AddPhotoViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) RrDidProductDeTailModel *model;
@property (nonatomic, strong) RrAddImageView *addView_pay;
@property (nonatomic, strong) RrAddImageView *addView_data;
@property (nonatomic, strong) RrAddImageView *addView_scan;

@property (nonatomic, strong) UITextField *payTextField;

@property (nonatomic, strong) RrOrderLabelView *bottonLabelView;

@property (nonatomic, assign) CGFloat postPayCerCll_h;
@property (nonatomic, strong) UIView *payMoneyView;

@property (nonatomic, strong) UIButton *rightNaviBtn;
@property (nonatomic, strong) NSMutableArray *scanArrModelData; //3D 预览数据

@end

@implementation RrMineOrderListDetailVC

- (void)dealloc{
    
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
    self.title = @"订单详情";
    
    self.dataArr = [NSMutableArray arrayWithArray:@[KUserInfo,KData,KScan,KProduct,KOrderConten,KCell_Space,
    ]];
    [self getUserChckeOrderDetailUrl];
    
    [self addTabelView];
    [self.view addSubview:self.notNetWorkView];
    
    @weakify(self)
    [self.notNetWorkView.tapViewBg handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
        @strongify(self)
        [self getUserChckeOrderDetailUrl];
    }];
    
    self.postPayCerCll_h = 140+iPH(159);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserChckeOrderDetailUrl) name:KNotification_name_updateOrder_list object:nil];
    
    
}

// 添加 右边导航栏 按钮
- (void)addRightNavigationBtn{
    @weakify(self)
    self.rightNaviBtn = [self addRightNavigationCustomButtonWithActionBlock:^{
        @strongify(self)
        if ([self.model.orderStatus intValue] == 1) { // 待完善
            MZShowAlertView *show = [[MZShowAlertView alloc] initWithAlerTitle:@"驳回原因" Content:self.model.rejectReason];
            show.tapEnadle = YES;
            [show show];
        }else if ([self.model.orderStatus intValue] == 3) { // 待付款
            AddPhotoView *addPView = self.addView_pay.addPView;
            if ([addPView.manger.currentAssets count] == 0) {
                showMessage(@"请上传支付凭证");
                return;
            }else if (checkStrEmty(self.model.AactualReceipts) || [self.model.AactualReceipts floatValue] == 0) {
                showMessage(@"请输入您的支付凭金额");
                return;
            }
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            NSMutableArray *imageArr = [NSMutableArray array];
            [addPView.manger uploadCurrentAssetsWithCompletion:^(BOOL succeed, id imageDatas, id videoDatas) {
                if (succeed) {
                    if (imageDatas) {
                        [imageDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *url =  [obj valueForKey:@"path"];
                            [imageArr addObject:[url imageUrlStr]];
                        }];
                        self.model.payImg = [imageArr componentsJoinedByString:@","];
                        
                        [self postOrderPayImgUrl];
                        
                    }else{
                        [SVProgressHUD dismiss];
                    }
                }else{
                    [SVProgressHUD dismiss];
                }
            }];
            
            
        }
    }];
    
}



- (void)addTabelView{
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([RrCommonRowCell class]) cellIndentifier:RrCommonRowCell_ID];
    [self.tableView registerNibString:NSStringFromClass([RrOrderItemsListCell class]) cellIndentifier:KRrOrderItemsListCell_ID];
    [self.tableView registerNibString:NSStringFromClass([RrMineOrderDetailAdressCell class]) cellIndentifier:KRrMineOrderDetailAdressCell_ID];
    [self.tableView registerNibString:NSStringFromClass([RrOrderPayTypeCell class]) cellIndentifier:KRrOrderPayTypeCell_ID];
    
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

- (RrOrderLabelView *)bottonLabelView{
    if (!_bottonLabelView) {
        _bottonLabelView = [[RrOrderLabelView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-17*2, 0.01f)];
        _bottonLabelView.titleLabel.text = @"订单信息";
    }
    return _bottonLabelView;
}

- (UIView *)payMoneyView{
    if (!_payMoneyView) {
        _payMoneyView = [[UIView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-17*2, 70)];
        _payMoneyView.backgroundColor = [UIColor whiteColor];
        [_payMoneyView bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:7.0f];
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.text = @"支付金额：";
        moneyLabel.font = KFont20;
        [moneyLabel sizeToFit];
        moneyLabel.right = self.payTextField.left ;
        moneyLabel.centerY = self.payMoneyView.centerY;
        [_payMoneyView addSubview:moneyLabel];
        
        [_payMoneyView addSubview:self.payTextField];
        
    }
    return _payMoneyView;
}


- (UITextField *)payTextField{
    if (!_payTextField) {
        _payTextField = [[UITextField alloc] initWithFrame:CGRectMake(KFrameWidth-17*3-iPW(150), 0, iPW(150), iPH(44))];
        _payTextField.centerY = self.payMoneyView.centerY;
        _payTextField.keyboardType = UIKeyboardTypePhonePad;
        _payTextField.placeholder = @"请输入金额";
        _payTextField.font = KFont20;
        _payTextField.layer.masksToBounds = YES;
        _payTextField.layer.cornerRadius = 7.0f;
        _payTextField.layer.borderColor = [UIColor c_lineColor].CGColor;
        _payTextField.layer.borderWidth = 0.5f;
        _payTextField.delegate = self;
        _payTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(17), iPW(17))];
        _payTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _payTextField;
}

- (RrAddImageView *)addView_pay{
    if (!_addView_pay) {
        _addView_pay = [[RrAddImageView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-17*2, iPH(159)+70)];
        _addView_pay.titleLabel.text = KPay;
//        _addView_pay.addPView.isCanEdite = YES;
        _addView_pay.addPView.maxPhotoNum = 3;
        @weakify(self)
        _addView_pay.complemntBlock = ^(RrAddImageView *photoView) {
            @strongify(self)
            self.addView_pay.height = photoView.height +18;
            [self.tableView reloadData];
        };
    }
    return _addView_pay;
}

- (RrAddImageView *)addView_data{
    if (!_addView_data) {
        _addView_data = [[RrAddImageView alloc] initWithFrame:CGRectMake(17, 0, KFrameWidth-17*2, 275)];
        _addView_data.titleLabel.text = KData;
        _addView_data.addPView.photoW = iPH(159);
        _addView_data.addPView.isCanEdite = NO;
        
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
        _addView_scan.addPView.photoW = iPH(159);
        _addView_scan.addPView.isCanEdite = NO;
        _addView_scan.addPView.delegate = self;
        @weakify(self)
        _addView_scan.complemntBlock = ^(RrAddImageView *photoView) {
            @strongify(self)
            self.addView_scan.height = photoView.height+53 ;
            [self.tableView reloadData];
        };
    }
    return _addView_scan;
}

#pragma maerk - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL b = [textField shouldChangeCharactersInRange:range replacementString:string];
    if (b) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.model.AactualReceipts = text;
    }
    return b;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.keyboardType = UIKeyboardTypePhonePad;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.dataArr.count-1] atScrollPosition:(UITableViewScrollPositionNone) animated:NO];
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        self.tableView.top = -100;
    });
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.tableView.top = 0;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *title = self.dataArr[section];
    if ([title isEqualToString:KUserInfo]) {
        return 3;
    }else  if ([title isEqualToString:KProduct]) {
        return 2;
    }else if ([title isEqualToString:KPay]) {
        return 2;
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
    }else if ([title isEqualToString:KPay]) {
        if (indexPath.row == 0) {
            return self.addView_pay.height;
        }
        return self.payMoneyView.height;
    }else if ([title isEqualToString:KPayType]) {
        return 180;
    }else if ([title isEqualToString:KProduct]) {
        if (indexPath.row == 0) {
            return 156;
        }else{
            if (!self.model) {
                        return 185;
                    }
            switch ([self.model.orderStatus intValue]) {
                case 1:// 待完善
                case 6://制作完成
                    return 185;
                case 3://待付款
                {
                    if ([self.model.payType intValue] == 1) {
                        return 185;
                    }
                    return 110;
                }
            }
            return 110;
            
        }
        return 185;
    }else if ([title isEqualToString:KOrderConten]) {
        return self.bottonLabelView.height;
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
    }else if ([title isEqualToString:KPay]) {
        MZCommonCell *cell = [MZCommonCell blankClearCell];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:self.addView_pay];
            return cell;
        }else{
            [cell.contentView addSubview:self.payMoneyView];
            return cell;
        }
        return cell;
        
    }else if([title isEqualToString:KPayType]){
        RrOrderPayTypeCell  *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderPayTypeCell_ID forIndexPath:indexPath];
        [cell.contenViewBg addCornerRadius:7.0f];
        cell.postModel = self.model;
        cell.leftBtn_bottom.constant = 40;
        __weak typeof(cell) weakCell = cell;
        cell.tapPayTypeBlock = ^(UIButton* actionBtn) {
            @strongify(self)
            NSString *payStr = @"线下支付";
            if (actionBtn == weakCell.onLinePayLBtn) {
                payStr = @"线上支付";
            }
            [self AlertWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您是否确定选择:%@\n修改后立即生效",payStr] andOthers:@[@"取消",@"确定"] animated:YES action:^(NSInteger index) {
                @strongify(self)
                NSNumber *payType = @(1);
                if (actionBtn == weakCell.offLinePayBtn) {
                    payType = @(2);
                }
                if (index == 1) {
                    [self changePayTypesUrlwithPayType:payType Block:^(BOOL success) {
                        //                        [weakCell changeBtnTypeWithBtn:actionBtn];
                        //支付方式:1在线支付，2线下支付
                        NSInteger cornerRadius = 0.0f;
                        if (weakCell.offLinePayBtn == actionBtn) { // 线下支付
                            weakCell.offLinePayBtn.selected = YES;
                            weakCell.postModel.payType = @(2);
                            cornerRadius = 0.0f;
                        }else{
                            cornerRadius = 7.0f;
                            weakCell.offLinePayBtn.selected = NO;
                            weakCell.postModel.payType = @(1);
                        }
                    }];
                }
            }];
        };
        return cell;
    }else if ([title isEqualToString:KProduct]) {
        if (indexPath.row == 0) {
            RrOrderItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrOrderItemsListCell_ID forIndexPath:indexPath];
            [cell.lfteImageView sd_setImageWithURL:self.model.productIcon.url placeholderImage:KPlaceholderImage_product];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %@",self.model.productName,self.model.productCode];
            cell.subTitleLabel.text = self.model.productAbstract;
            cell.moneyTitleLabel.hidden = NO;
            cell.moneyLabel.hidden = NO;
            cell.stautsLabel.hidden = NO;
            cell.stautsLabel.text = self.model.orderStatus_Str;
            cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.model.totalFee];
            [cell.contentViewBg bezierPathWithRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadius:0.0f];
            
            return cell;
        }else if(indexPath.row == 1){//收货地址
            RrMineOrderDetailAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrMineOrderDetailAdressCell_ID forIndexPath:indexPath];
            cell.model = self.model;
            cell.backBlock = ^(BOOL onTapLeft, BOOL onTapRight) {
                @strongify(self)
                if (onTapLeft) {
                    
                    NSString *content = [NSString stringWithFormat:@"%@  %@",self.model.express,self.model.trackingNumber];
                    if ([self.model.orderStatus intValue] == 6) {  //制作完成6
                        [self AlertWithTitle:@"物流信息"  message:content andOthers:@[@"复制"] animated:YES action:^(NSInteger index) {
                            showMessage(@"复制成功!");
                            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                            pasteboard.string = self.model.trackingNumber;
                            
                        }];
                    }
                    
                    
                }else{
                    
                    if ([self.model.orderStatus intValue] == 1) {  //审核被驳回 修改信息
                        RrMineOrderListDetailEdittingVC *editVc = [RrMineOrderListDetailEdittingVC new];
                        editVc.model = self.model;
                        [self.navigationController pushViewController:editVc animated:YES];
                    }else if ([self.model.orderStatus intValue] == 3) {
                        [self showPayNotifi];
                    }else if ([self.model.orderStatus intValue] == 6) {  //制作完成6
                        [self AlertWithTitle:@"温馨提示" message:@"是否确认收货" andOthers:@[@"取消",@"确认"] animated:YES action:^(NSInteger index) {
                            if(index == 1){
                                [self changeOrderStatusUrlWithModel:self.model SelectOrderStatus:@(7)];
                            }
                        }];
                        
                    }
                    
                }
            };
            return cell;
            
        }
        
    }else if ([title isEqualToString:KOrderConten]) {
    
        MZCommonCell *cell = [MZCommonCell blankClearCell];
        [cell.contentView addSubview:self.bottonLabelView];
        return cell;
    }
    return [MZCommonCell blankClearCell];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.payTextField isFirstResponder]) {
        [self.payTextField becomeFirstResponder];
    }
    
}


#pragma mark - addPhotoViewDelegate
- (void)addPhotoView:(AddPhotoView *)addView selectedImageViewIndex:(NSInteger)index
{
    if ((addView == self.addView_scan.addPView) && (index < self.scanArrModelData.count)) {
        JassonSTLVC *showVc =[JassonSTLVC new];
        showVc.curFileName = self.scanArrModelData[index];
        [self.navigationController pushViewController:showVc animated:YES];
    }
    
}



#pragma mark - 获取网络Url
/**
 orderStatus=0  取消订单
 orderStatus=2  完善测量数据
 orderStatus=7  确认收货
 */
- (void)changeOrderStatusUrlWithModel:(RrDidProductDeTailModel *)model SelectOrderStatus:(NSNumber *)orderStatus{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.outTradeNo forKey:@"outTradeNo"];
    [parameter setValue:orderStatus forKey:@"orderStatus"];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] changeOrderStatus:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            KPostNotification(KNotification_name_updateOrder_list, nil);
            [self getUserChckeOrderDetailUrl];
        }
        [SVProgressHUD dismiss];
        showMessage(responseModel.msg);
    }, nil)];
    
}


//改变支付状态
- (void)postOrderPayImgUrl{
    @weakify(self)
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.model.outTradeNo forKey:@"outTradeNo"];
    [parameter setValue:self.model.payImg forKey:@"payImg"];          // 支付凭证，多个逗号分隔
    [parameter setValue:self.model.AactualReceipts forKey:@"actualReceipts"];  //线下支付金额
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] postOrderPayImg:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            [self getUserChckeOrderDetailUrl];
            KPostNotification(KNotification_name_updateOrder_list, nil);
        }else{
            [SVProgressHUD dismiss];
            showMessage(responseModel.msg);
        }
        
    }, nil)];
    
}

//改变支付状态
- (void)changePayTypesUrlwithPayType:(NSNumber *)payType Block:(void (^)(BOOL success))block{
    @weakify(self)
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.model.outTradeNo forKey:@"outTradeNo"];
    [parameter setValue:payType forKey:@"payType"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] changeOrderStatus:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        
        if (!error) {
            !block ? :block(YES);
            // 根据支付类型 更新 ui
            [self updatePayTypeDataUI];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.tableView reloadData];
                showMessage(responseModel.msg);
            });
        }else{
            showMessage(responseModel.msg);
        }
        [SVProgressHUD dismiss];
        
    }, nil)];
    
}


//付款提醒
- (void)showPayNotifi{
    if (checkStrEmty(self.model.outTradeNo)) {
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] putOrderPayNotifi:@{@"outTradeNo":self.model.outTradeNo} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            showMessage(@"已发送付款提醒");
        }else{
            showMessage(responseModel.msg);
        }
        [SVProgressHUD dismiss];
    }, nil)];
    
}

//列表详情
- (void)getUserChckeOrderDetailUrl{
    @weakify(self)
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] getUserChckeOrderDetail:@{KKey_1:self.outTradeNo} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self)
        if (!error) {
            self.notNetWorkView.hidden = YES;
            self.model = (RrDidProductDeTailModel *)responseModel.item;
            [self dataConfigUI];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            });
            
            
        }else{
            self.notNetWorkView.hidden = NO;
            showMessage(responseModel.msg);
            [SVProgressHUD dismiss];
        }
        
    }, [RrDidProductDeTailModel class])];
}


- (void)dataConfigUI{
    @weakify(self)
    self.rightNaviBtn.hidden = YES;////默认
    self.addView_pay.addPView.isCanEdite = NO;//默认
    self.addView_pay.addPView.photoW = iPH(159);//默认
    self.payTextField.userInteractionEnabled = NO;//默认
    //默认
    self.payTextField.text = [NSString stringWithFormat:@"¥%@",self.model.AactualReceipts];
    self.payTextField.textColor = [UIColor c_btn_Bg_Color];
    self.payTextField.layer.borderColor = [UIColor clearColor].CGColor;

    
    self.addView_data.addPView.imageUrl = [self.model.attachment componentsSeparatedByString:@","];
    self.addView_pay.addPView.imageUrl = [self.model.payImg componentsSeparatedByString:@","];
    
    //--------------------------- 3D 扫描数据处理 star--------------------------------------------
    __autoreleasing NSMutableArray *scanMutArr = [NSMutableArray array];
    self.scanArrModelData = [NSMutableArray array];
    NSArray *scanArr = [self.model.otherAttachment componentsSeparatedByString:@","];
    
    for (int i = 0; i<scanArr.count; i++) {
        if ((i+1)%2 == 1) {
            [scanMutArr addObject:scanArr[i]];
        }else{
            [self.scanArrModelData addObject:scanArr[i]];
        }
    }
    self.addView_scan.addPView.imageUrl = scanMutArr;
    
    if (checkStrEmty(self.model.otherAttachment)) {//没有上传3D扫描文件
        if ([self.dataArr containsObject:KScan]) {
            [self.dataArr removeObject:KScan];
        }
    }else{
        if (![self.dataArr containsObject:KScan]) {
            [self.dataArr addObject:KScan];
        }
    }
    //--------------------------- 3D 扫描数据处理 end--------------------------------------------
    
    
    //---------------------- 待完善 1-------------------------------
    if ([self.model.orderStatus intValue] == 1) { // 审核被驳回
        [self addRightNavigationBtn];
        self.rightNaviBtn.hidden = NO;
        [self.rightNaviBtn setTitle:@"驳回原因" forState:UIControlStateNormal];
        [self.rightNaviBtn setImage:R_ImageName(@"ckeck_notifi") forState:UIControlStateNormal];
        [self.rightNaviBtn setTitleColor:[@"FF1010" getColor] forState:UIControlStateNormal];
        self.rightNaviBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    //------------------------ 待完善  end ----------------------------------
    
    

    
    //---------------------- 待支付 3-------------------------------
    if ([self.model.orderStatus intValue] == 3) { //用户提交订单时是线上支付--》待支付   // 可修改支付方式
        [self addRightNavigationBtn];
        self.rightNaviBtn.hidden = NO;
        [self.rightNaviBtn setTitle:@"提交" forState:UIControlStateNormal];
        if (![self.dataArr containsObject:KPayType]) {
            NSInteger insert = [self.dataArr indexOfObject:KOrderConten];
            [self.dataArr insertObject:KPayType atIndex:insert];
        }
        self.addView_pay.addPView.photoW = iPH(85);
        self.addView_pay.addPView.isCanEdite = YES;
        self.payTextField.userInteractionEnabled = YES;
        self.payTextField.text = @"";
        self.payTextField.textColor = [UIColor blackColor];
        self.payTextField.layer.borderColor = [UIColor c_lineColor].CGColor;
        
    }else if([self.model.orderStatus intValue] == 2){//用户提交订单时是线下支付--》待审核
        if ([self.model.payType intValue] == 2) {//支付方式:1在线支付，2线下支付
            if (![self.dataArr containsObject:KPay]) {
                [self.dataArr insertObject:KPay atIndex:4];
            }
        }
    }
    
    // 根据支付类型 更新 ui
       [self updatePayTypeDataUI];
    
    //----------------------------------------------------------
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self setOrerMesaageUI];
        
        [self.bottonLabelView updateConfigUI];
        [self.addView_data.addPView updateAddPhotoView];
        [self.addView_scan.addPView updateAddPhotoView];
        [self.addView_pay.addPView updateAddPhotoView];
    });

}

//订单信息x
- (void)setOrerMesaageUI{
    
    NSString *title1 = [NSString stringWithFormat:@"%@%@",@"发票信息：",self.model.partnerName];
    NSString *title2 = [NSString stringWithFormat:@"%@%@",@"订单编号：",self.model.outTradeNo];
    NSString *title3 = [NSString stringWithFormat:@"%@%@",@"创建时间：",[self.model.createTime dateStringFromTimeYMDHMS]];
    
    NSString *title4 = [NSString stringWithFormat:@"%@%@",@"付款金额：",[NSString stringWithFormat:@"%@ 元",self.model.AactualReceipts]];
    NSString *title5 = [NSString stringWithFormat:@"%@%@",@"支付方式：",self.model.payTypeStr];
    NSString *title6 = [NSString stringWithFormat:@"%@%@",@"付款时间：",[self.model.payTime dateStringFromTimeYMDHMS]];
    NSString *title7 = [NSString stringWithFormat:@"%@%@",@"交易流水号：",self.model.transactionId];
    NSString *title8 = [NSString stringWithFormat:@"%@%@",@"发货时间：",[self.model.expressTime dateStringFromTimeYMDHMS]];
    
    NSString *title9 = [NSString stringWithFormat:@"%@%@",@"备注：",self.model.remark];
    
    NSString *title10 = [NSString stringWithFormat:@"%@%@",@"收货时间：",[self.model.completeTime dateStringFromTimeYMDHMS]];

    
    NSMutableArray *itemArr = [NSMutableArray array];
    if (!checkStrEmty(self.model.partnerName)) {
        [itemArr addObject:title1];
    }
    if (!checkStrEmty(self.model.outTradeNo)) {
        [itemArr addObject:title2];
    }
    if (!checkStrEmty(self.model.createTime)) {
        [itemArr addObject:title3];
    }
    if (!checkStrEmty(self.model.AactualReceipts)) {
        [itemArr addObject:title4];
    }
    if (self.model.payTypeStr) {
        [itemArr addObject:title5];
    }
    if (!checkStrEmty(self.model.payTime)) {
        [itemArr addObject:title6];
    }
    if (!checkStrEmty(self.model.transactionId)) {
        [itemArr addObject:title7];
    }
    if (!checkStrEmty(self.model.expressTime)) {
        [itemArr addObject:title8];
    }
    if (!checkStrEmty(self.model.remark)) {
        [itemArr addObject:title9];
    }
    if (!checkStrEmty(self.model.completeTime)) {
           [itemArr addObject:title10];
       }
    self.bottonLabelView.itemLabelArr = itemArr;
    
}

// 根据支付类型 更新 ui
- (void)updatePayTypeDataUI{
    if ([self.model.payType intValue] == 1) { //线上支付
//        self.rightNaviBtn.hidden = YES;
        if ([self.dataArr containsObject:KPay]) {
            [self.dataArr removeObject:KPay];
        }
    }else{//线下支付
//        self.rightNaviBtn.hidden = NO;
        if (![self.dataArr containsObject:KPay]) {
            NSInteger insert = [self.dataArr indexOfObject:KOrderConten];
            [self.dataArr insertObject:KPay atIndex:insert];
        }
    }
}


@end
