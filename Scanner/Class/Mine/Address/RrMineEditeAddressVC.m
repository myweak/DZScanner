//
//  RrMineEditeAddressVC.m
//  Scanner
//
//  Created by edz on 2020/7/14.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KTextFieldFrame           CGRectMake(iPW(17), 0, KFrameWidth-iPW((17+17)), KCell_H)
#define KLeftView_frame           CGRectMake( 0, 0, iPW(18), iPW(18))
#define SName_title               @"收货人"
#define SPhone_title              @"手机号码"
#define SAddress_title            @"所在地区"
#define SDetailAddre_title        @"详细地址：如道路、门牌号、小区、楼栋号、单元室等"
#define SDefineAddress_title      @"设为默认地址"
#define SDelectAddre_title        @"删除地址"

#import "RrMineEditeAddressVC.h"
#import "RrMineAddressVC.h" // 地址
#import "AreaPickerView.h"

@interface RrMineEditeAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;


@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *phoneTextField; //
@property (nonatomic, strong) UITextField *addressTextField; //所在地区
@property (nonatomic, strong) UITextField *detalAddreTextField; // 详细地址
@property (nonatomic, strong) UIView      *definTextViewBg;
@property (nonatomic, strong) UITextView  *definTextView;

@property (nonatomic, strong) UIView      *definAddreView;// 默认地址
@property (nonatomic, strong) UIButton    *definAddreBtn;// 默认地址按钮
@property (nonatomic, strong) UIView      *deleteView; // 删除按钮

@end

@implementation RrMineEditeAddressVC
@synthesize addreModel = _addreModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    NSArray *arr = @[
        KCell_Space,
        SName_title,
        SPhone_title,
        SAddress_title,
        SDetailAddre_title,
        KCell_Space,
        SDefineAddress_title,
        KCell_Space,
    ];
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    
    [self.view addSubview:self.tableView];
    
    [self addNavigationButtonRight:@"保存" RightActionBlock:^{
        @strongify(self);
        [self PostAddressURL];
    }];
    
    
    if (self.type == RrMineEditeAddressType_edit) {
        if (![self.dataArr containsObject:SDelectAddre_title]) {
            [self.dataArr addObject:SDelectAddre_title];
        }
        self.nameTextField.text = self.addreModel.consignee;
        self.phoneTextField.text = self.addreModel.phone;
        if (!checkStrEmty(self.addreModel.provinceDesc)) {
            self.addressTextField.text = [NSString stringWithFormat:@"%@%@%@",self.addreModel.provinceDesc,self.addreModel.cityDesc,self.addreModel.areaDesc];
        }
        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            
            self.definTextView.text = self.addreModel.addrDetail;
            self.definAddreBtn.selected = [self.addreModel.defaultAddr boolValue];
            
        });
        
    }
    
}

- (RrMineAddressMdoel *)addreModel{
    if (!_addreModel) {
        _addreModel = [RrMineAddressMdoel new];
    }
    return _addreModel;
}

#pragma mark - tabelview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return iPH(17);
    }else if ([title isEqualToString:SDetailAddre_title]) {
        return self.definTextViewBg.height;
    }
    return KCell_H;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MZCommonCell *cell = [MZCommonCell blankSpaceCell];
    //    [cell setInsetWithX:KScreenWidth];
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return cell;
    }
    
    if ([title isEqualToString:SName_title]) {
        self.nameTextField.placeholder = title;
        [self.nameTextField bezierPathWithRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:7.0f];
        [cell.contentView addSubview:self.nameTextField];
    }else  if ([title isEqualToString:SPhone_title]) {
        self.phoneTextField.placeholder = title;
        [cell.contentView addSubview:self.phoneTextField];
    }else  if ([title isEqualToString:SAddress_title]) {
        self.addressTextField.placeholder = title;
        self.addressTextField.enabled = NO;
        [cell.contentView addSubview:self.addressTextField];
    }else  if ([title isEqualToString:SDetailAddre_title]) {
        self.definTextView.text = self.addreModel.addrDetail;
        [cell.contentView addSubview:self.definTextViewBg];
        [self.definTextViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:7.0f];
        
    }else  if ([title isEqualToString:SDefineAddress_title]) {
        self.definAddreBtn.selected = [self.addreModel.defaultAddr boolValue];
        [cell.contentView addSubview:self.definAddreView];
        [self.definAddreView addCornerRadius:7.0f];
    }else if ([title isEqualToString:SDelectAddre_title]){
        [cell.contentView addSubview:self.deleteView];
        [self.deleteView addCornerRadius:7.0f];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.row];
    @weakify(self)
    if ([title isEqualToString:SName_title]) {
        
    }else  if ([title isEqualToString:SPhone_title]) {
        
    }else  if ([title isEqualToString:SAddress_title]) {
        [[[AreaPickerView alloc] initWithShowPickerView:^(RrAddressModel *provinceModel, RrAddressModel *cityMdoel, RrAddressModel *areaModel) {
            @strongify(self)
            self.addreModel.provinceId = provinceModel.areaCode;
            self.addreModel.cityId = cityMdoel.areaCode;
            self.addreModel.areaId = areaModel.areaCode;
            
            self.addreModel.provinceDesc = provinceModel.areaName;
            self.addreModel.cityDesc = cityMdoel.areaName;
            self.addreModel.areaDesc = areaModel.areaName;
            
            self.addressTextField.text = [NSString stringWithFormat:@"%@ %@ %@",provinceModel.areaName,cityMdoel.areaName,checkStrEmty(areaModel.areaName)?@"":areaModel.areaName];
        }] show];
    }else  if ([title isEqualToString:SDelectAddre_title]) {
        [self AlertWithTitle:@"温馨提示" message:@"是否删除该地址？"  andOthers:@[@"取消",@"确认"] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                [self deleteAddressUrlWith:self.addreModel];
            }
        }];        
    }
    
}

#pragma mark - 按钮 事件 Action
- (void)agreementBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
}

#pragma mark - textField UITextView deleget
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.nameTextField) {
        self.addreModel.consignee =  text;
    }else  if (textField == self.phoneTextField) {
        if (text.length >11) {
            return NO;
        }
        self.addreModel.phone =  text;
        return [text containsOnlyNumbers];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    self.addreModel.addrDetail = textView.text;
}


#pragma mark --网络 url
- (void)PostAddressURL{
    
    if (checkStrEmty(self.addreModel.consignee)) {
        showTopMessage([NSString stringWithFormat:@"%@%@",@"请填写",SName_title]);
        return;
    }else if (checkStrEmty(self.addreModel.phone)) {
        showTopMessage([NSString stringWithFormat:@"%@%@",@"请填写",SPhone_title]);
        return;
    }else if (checkStrEmty(self.addressTextField.text)) {
        showTopMessage([NSString stringWithFormat:@"%@%@",@"请选择",SAddress_title]);
        return;
    }else if (checkStrEmty(self.addreModel.addrDetail)) {
        showTopMessage(@"请填写详细地址");
        return;
    }
    
    if(![self.addreModel.phone isMobileNumber]){
        showTopMessage(@"手机号码格式错误");
        return;
    }else  if(checkStrEmty(self.addreModel.provinceDesc) || checkStrEmty(self.addreModel.cityDesc)){
        showMessage(@"地址出错咯，请重新选择");
        [[LXObjectTools sharedManager] updateAddressUrlPlist];
        return;
    }
    
    if (self.type == RrMineEditeAddressType_add) {
        [self postAddGoodsAddressUrl];
    }else{
        [self changeAddressUrl];
    }
}


// 添加 地址 url
- (NSMutableDictionary *)getParameter{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.addreModel.consignee forKey:@"consignee"];
    [parameter setValue:self.addreModel.phone forKey:@"phone"];
    [parameter setValue:self.addreModel.provinceId forKey:@"provinceId"];
    [parameter setValue:self.addreModel.provinceDesc forKey:@"provinceDesc"];
    [parameter setValue:self.addreModel.cityId forKey:@"cityId"];
    [parameter setValue:self.addreModel.cityDesc forKey:@"cityDesc"];
    [parameter setValue:self.addreModel.areaId forKey:@"areaId"];
    [parameter setValue:self.addreModel.areaDesc forKey:@"areaDesc"];
    [parameter setValue:self.definAddreBtn.selected ? @"1": @"0" forKey:@"defaultAddr"];
    [parameter setValue:self.addreModel.addrDetail forKey:@"addrDetail"];
    [parameter setValue:aUser.ID forKey:@"doctorId"];
    if (!checkStrEmty(self.addreModel.ID)) {
        [parameter setValue:self.addreModel.ID forKey:@"id"];
    }
    return parameter;
}

// 添加地址 
- (void)postAddGoodsAddressUrl{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] postAddGoodsAddress:[self getParameter] result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            !self.backSaveSucceedBlock ?: self.backSaveSucceedBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
        showTopMessage(responseModel.msg);
    }, nil)];
}

//删除地址
- (void)deleteAddressUrlWith:(RrMineAddressMdoel *) model{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.ID forKey:@"id"];
    [[RRNetWorkingManager sharedSessionManager] deleteAdressList:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            !self.backSaveSucceedBlock ?: self.backSaveSucceedBlock();
                 [self.navigationController popViewControllerAnimated:YES];
             }
        showMessage(responseModel.msg);
    }, nil)];
}

//修改地址
- (void)changeAddressUrl
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] putCahngeAdressList:[self getParameter] result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            !self.backSaveSucceedBlock ?: self.backSaveSucceedBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
        showMessage(responseModel.msg);
        
    }, nil)];
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
    }
    return _tableView;
}

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:KTextFieldFrame];
        _nameTextField.font = KFont20;
        [_nameTextField addLine_bottom];
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.leftView = [[UIView alloc] initWithFrame:KLeftView_frame];
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:KTextFieldFrame];
        _phoneTextField.font = KFont20;
        [_phoneTextField addLine_bottom];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.leftView = [[UIView alloc] initWithFrame:KLeftView_frame];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}
- (UITextField *)addressTextField{
    if (!_addressTextField) {
        _addressTextField = [[UITextField alloc] initWithFrame:KTextFieldFrame];
        _addressTextField.font = KFont20;
        [_addressTextField addLine_bottom];
        _addressTextField.backgroundColor = [UIColor whiteColor];
        _addressTextField.leftView = [[UIView alloc] initWithFrame:KLeftView_frame];
        _addressTextField.leftViewMode = UITextFieldViewModeAlways;
        _addressTextField.delegate = self;
    }
    return _addressTextField;
}
- (UITextField *)detalAddreTextField{
    if (!_detalAddreTextField) {
        _detalAddreTextField = [[UITextField alloc] initWithFrame:KTextFieldFrame];
        _detalAddreTextField.font = KFont20;
        [_detalAddreTextField addLine_bottom];
        _detalAddreTextField.backgroundColor = [UIColor whiteColor];
        _detalAddreTextField.leftView = [[UIView alloc] initWithFrame:KLeftView_frame];
        _detalAddreTextField.leftViewMode = UITextFieldViewModeAlways;
        _detalAddreTextField.delegate = self;
    }
    return _detalAddreTextField;
}

- (UIView *)definTextViewBg{
    if (!_definTextViewBg) {
        _definTextViewBg = [[UIView alloc] initWithFrame:KTextFieldFrame];
        _definTextViewBg.backgroundColor = [UIColor whiteColor];
        _definTextViewBg.height = iPH(133);
        [_definTextViewBg addSubview:self.definTextView];
    }
    return _definTextViewBg;
}
- (UITextView *)definTextView{
    if (!_definTextView) {
        _definTextView = [[UITextView alloc] initWithFrame:CGRectMake(iPW(17),  iPH(26), self.definTextViewBg.width-iPW((17+17)),  iPH(81))];
        _definTextView.font = KFont20;
        _definTextView.delegate = self;
        _definTextView.text = self.addreModel.addrDetail;
        _definTextView.placeholder = SDetailAddre_title;
    }
    return _definTextView;;
}

- (UIView *)definAddreView{
    if (!_definAddreView) {
        _definAddreView = [[UIView alloc] initWithFrame:KTextFieldFrame];
        _definAddreView.backgroundColor = [UIColor whiteColor];
        //左边标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:KTextFieldFrame];
        titleLabel.text = SDefineAddress_title;
        titleLabel.width = 300;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = KFont20;
        [_definAddreView addSubview:titleLabel];
        
        //右边按钮
        [_definAddreView addSubview:self.definAddreBtn];
        
    }
    return _definAddreView;
}

- (UIButton *)definAddreBtn{
    if (!_definAddreBtn) {
        _definAddreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _definAddreBtn.frame = CGRectMake(0, 0, self.definAddreView.height, self.definAddreView.height);
        _definAddreBtn.right = self.definAddreView.right-36;
        [_definAddreBtn setImage:R_ImageName(@"regist_agree_n") forState:UIControlStateNormal];
        [_definAddreBtn setImage:R_ImageName(@"regist_agree_y") forState:UIControlStateSelected];
        [_definAddreBtn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _definAddreBtn;
}

- (UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView alloc] initWithFrame:KTextFieldFrame];
        _deleteView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:_deleteView.bounds];
        titleLabel.text = SDefineAddress_title;
        titleLabel.textColor = [UIColor c_redColor];
        titleLabel.font = KFont20;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = SDelectAddre_title;
        [_deleteView addSubview:titleLabel];
    }
    return  _deleteView;
}





@end
