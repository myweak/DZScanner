//
//  PostUserInfoVC.m
//  Scanner
//
//  Created by edz on 2020/7/8.
//  Copyright © 2020 rrdkf. All rights reserved.
//


#define SHeadIcon_cell            @"请上传头像"
#define SName_title               @"请输入姓名"
#define SSex_title                @"请选择性别"
#define SDepartment_title         @"请输入科室"
#define SProfessional_title       @"请输入职称"
#define SMerchantsAccount_title   @"请输入关联经销商账号（非必填）"
#define SPostTitle_cell           @"请上传证件"

#define SBottomBtn_cell            @"提交"

#import "PostUserInfoVC.h"
#import "MZAvatarImagePicker.H"
#import "CheckUserInfoVC.h"  // 审核中vc
#import "RrAddImageView.h"
#import "RegistVC.h"

@interface PostUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,OTAvatarImagePickerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *departmentTextField; //科室
@property (nonatomic, strong) UITextField *professionalTextField; //职称
@property (nonatomic, strong) UITextField *mAccountTextField;
@property (nonatomic, strong) UITextField *sexTextField;
@property (nonatomic, strong) UIImageView *acceImageView; // 箭头
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy)   NSString *headImageUrl;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, assign) NSInteger sexID;
@property (nonatomic, assign) BOOL isChangeAddImage;

@property (nonatomic, strong) RrAddImageView *addView_data;


@end

@implementation PostUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = @[
        SName_title,
        SSex_title,
        SDepartment_title,
        SProfessional_title,
        SMerchantsAccount_title,
        SPostTitle_cell,
        SBottomBtn_cell,
        KCell_Space,
    ];
    self.tableView.tableHeaderView = self.headView;
    

    NSMutableArray *navArr = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    for (UIViewController *VC in self.navigationController.viewControllers) {
        NSLog(@"-----%@",VC);
        if ([VC isKindOfClass:[RegistVC class]]){
            [navArr removeObject:VC];
        }
        
//        if ([VC isKindOfClass:[LoginVC class]]){
//            [navArr addObject:VC];
//        }else if([VC isKindOfClass:[PostUserInfoVC class]]){
//            [navArr addObject:VC];
//        }
    }
    self.navigationController.viewControllers = navArr;
    

}

#pragma mark - tabelview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return iPH(79);
    }else if([title isEqualToString:SPostTitle_cell]){
        return self.addView_data.height;
    }else if([title isEqualToString:SBottomBtn_cell]){
        return self.bottomView.height;
    }
    return iPH(73);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MZCommonCell *cell = [MZCommonCell blankCell];
    //    [cell setInsetWithX:KScreenWidth];
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return cell;
    }else if([title isEqualToString:SBottomBtn_cell]){
        [cell.contentView addSubview:self.bottomView];
        return cell;
    }else if([title isEqualToString:SPostTitle_cell]){
        [cell.contentView addSubview:self.addView_data];
        return cell;
    }
    
    if ([title isEqualToString:SName_title]) {
        self.nameTextField.placeholder = title;
        [cell.contentView addSubview:self.nameTextField];
    }else  if ([title isEqualToString:SDepartment_title]) {
        self.departmentTextField.placeholder = title;
        [cell.contentView addSubview:self.departmentTextField];
    }else  if ([title isEqualToString:SProfessional_title]) {
        self.professionalTextField.placeholder = title;
        [cell.contentView addSubview:self.professionalTextField];
    }else  if ([title isEqualToString:SMerchantsAccount_title]) {
        self.mAccountTextField.placeholder = title;
        [cell.contentView addSubview:self.mAccountTextField];
    }else  if ([title isEqualToString:SSex_title]) {
        self.sexTextField.placeholder = title;
        [cell.contentView addSubview:self.acceImageView];
        [cell.contentView addSubview:self.sexTextField];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:SSex_title]) {
        NSArray *arr = @[@"男",@"女"];
        MZActionSheetView *sheet =[[MZActionSheetView alloc] initWithActionSheetWithTitle:@"请选择性别" ListArray:arr completeSelctBlock:^(NSInteger selectIndex) {
            if (selectIndex>=0) {
                self.sexID = selectIndex+1; // 为男性，2为女性，0是未知
                self.sexTextField.text = arr[selectIndex];
            }
        }];
        if ([arr containsObject:self.sexTextField.text]) {
            [sheet didSelectRowAtIndex:[arr indexOfObject:self.sexTextField.text]];
        }
        sheet.tapEnadle = NO;
        [sheet show];
    }
    
}

#pragma mark - btn Action
//注册按钮
- (void)postBtnAction:(UIButton *)btn{
    [self.view endEditing:YES];
    
    if (checkStringIsEmty(self.nameTextField.text)) {
        showMessage(SName_title);
        return;
    }else if (checkStringIsEmty(self.sexTextField.text)) {
        showMessage(SSex_title);
        return;
    }else if (checkStringIsEmty(self.departmentTextField.text)) {
        showMessage(SDepartment_title);
        return;
    }else if (checkStringIsEmty(self.professionalTextField.text)) {
        showMessage(SProfessional_title);
        return;
    }

    
    if (checkStringIsEmty(self.headImageUrl)) {
        showMessage(SHeadIcon_cell);
        return;
    }else if (self.addView_data.addPView.manger.currentAssets.count == 0) {
        showMessage(SPostTitle_cell);
        return;
    }
    
    [self postUserInfo];
}
// 上传用户信息
- (void)postUserInfo{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    if (self.imageArr.count >0 && !self.isChangeAddImage) {
        [self postUserInfo2:self.imageArr];
        return;
    }
    self.imageArr = [NSMutableArray array];
    // 七🐂 获取图片地址
    @weakify(self)
    [self.addView_data.addPView.manger uploadCurrentAssetsWithCompletion:^(BOOL succeed, id imageDatas, id videoDatas) {
        @strongify(self)
        if (succeed) {
            if (imageDatas) {
                [imageDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  NSString *url =  [obj valueForKey:@"path"];
                    [self.imageArr addObject:[url imageUrlStr]];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    [self postUserInfo2:self.imageArr];
                });
            }
        }else{
            [SVProgressHUD dismiss];
        }
    }];
    
}

#pragma mark - 上传用户信息 URL
- (void)postUserInfo2:(NSMutableArray *)imageArr{
    self.isChangeAddImage = NO;
    // 提交信息
    NSMutableString *certimg = [NSMutableString string];
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [certimg appendString:@","];
        }
        [certimg appendString:obj];
    }];

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.headImageUrl forKey:@"headimg"];
    [parameter setValue:self.nameTextField.text forKey:@"name"];
    [parameter setValue:@(self.sexID) forKey:@"sex"]; // 1为男性，2为女性;
    [parameter setValue:self.departmentTextField.text forKey:@"dept"]; //科室
    [parameter setValue:self.professionalTextField.text forKey:@"title"]; //职称
 //关联经销商编码
    if (!checkStrEmty(self.mAccountTextField.text)) {
        [parameter setObject:self.mAccountTextField.text forKey:@"companyCode"];

     }
    [parameter setValue:certimg forKey:@"certimg"]; //从业资格图片URL ';'多图逗号隔开

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] postUserInfo:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            [self pushToCheckUserInfoVC];
        }else{
            [SVProgressHUD dismiss];
        }
        showMessage(responseModel.msg);
    }, nil)];

}


#pragma mark - PUSH VC
- (void)pushToCheckUserInfoVC{
    
    [[RrUserTypeModel sharedDataModel] updateUserTypeUrlWithBlock:^(BOOL success,RrUserTypeModel *typeModel) {
        [SVProgressHUD dismiss];
         if (success) {
             CheckUserInfoVC *checkVc = [CheckUserInfoVC new];
             checkVc.title = @"我的信息";
             checkVc.type = CheckUserInfoVCType_check;
             [self.navigationController pushViewController:checkVc animated:YES];
         }

     }];
    


}


#pragma mark UI

- (RrAddImageView *)addView_data{
    if (!_addView_data) {
        _addView_data = [[RrAddImageView alloc] initWithFrame:CGRectMake(iPW(80)-17, 0, KFrameWidth-(iPW(80)-17)*2, 182)];
        _addView_data.titleLabel.text =  @"上传证件  （可上传多张）";
        _addView_data.titleLabel.textColor = [UIColor c_GrayColor];
        _addView_data.titleLabel.keywords =@"（可上传多张）";
        _addView_data.titleLabel.keywordsColor = [UIColor c_redColor];
        [_addView_data.titleLabel reloadUIConfig];
        @weakify(self)
        _addView_data.addPView.isCanEdite = YES;
        _addView_data.complemntBlock = ^(RrAddImageView *photoView) {
            @strongify(self)
            self.isChangeAddImage = YES;
            self.addView_data.height = photoView.height+25 ;
            [self.tableView reloadData];
        };
    }
    return _addView_data;
}

- (UITableView *)tableView{
    
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, (KScreenHeight-64)) style:UITableViewStyleGrouped];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 73;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _nameTextField.font = KFont20;
        _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameTextField;
}
- (UITextField *)departmentTextField{
    if (!_departmentTextField) {
        _departmentTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _departmentTextField.font = KFont20;
//        _departmentTextField.keyboardType =  UIKeyboardTypeNumberPad;
        [_departmentTextField addLine_bottom];
        _departmentTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _departmentTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _departmentTextField;
}

- (UITextField *)professionalTextField{
    if (!_professionalTextField) {
        _professionalTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _professionalTextField.font = KFont20;
//        _professionalTextField.keyboardType =  UIKeyboardTypeNumberPad;
        _professionalTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _professionalTextField.leftViewMode = UITextFieldViewModeAlways;
        [_professionalTextField addLine_bottom];
    }
    return _professionalTextField;
}

- (UITextField *)mAccountTextField{
    if (!_mAccountTextField) {
        _mAccountTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _mAccountTextField.font = KFont20;
        _mAccountTextField.keyboardType =  UIKeyboardTypeNumberPad;
        _mAccountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _mAccountTextField.leftViewMode = UITextFieldViewModeAlways;
        [_mAccountTextField addLine_bottom];
    }
    return _mAccountTextField;
}

- (UITextField *)sexTextField{
    if (!_sexTextField) {
        _sexTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _sexTextField.font = KFont20;
        _sexTextField.keyboardType =  UIKeyboardTypeNumberPad;
        _sexTextField.userInteractionEnabled = NO;
        [_sexTextField addLine_bottom];
        _sexTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _sexTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _sexTextField;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, iPH(159))];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPH(111), iPH(111))];
        imageView.image = R_ImageName(@"register_upload");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = iPH(111)/2.0f;
        imageView.layer.masksToBounds = YES;
        imageView.center = _headView.center;
        self.headImageView = imageView;
        [imageView handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
//            NSLog(@"点击头像");
            [self.view endEditing:YES];
            [[LXObjectTools sharedManager] tapAddPhotoImageBlock:^(NSString * imageUrl, UIImage * image) {
                self.headImageUrl = imageUrl;
                self.headImageView.image = image;
            }];
            
        }];
        [_headView addSubview:imageView];
    }
    return _headView;
}



- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(iPW(64), 0, KScreenWidth-iPW(64)*2, iPH(122))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, _bottomView.width, 44);
        btn.bottom = _bottomView.bottom;
        [btn setTitle:@"注册" forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height/2.0f;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = KFont17;
        btn.backgroundColor = [UIColor grayColor];
        [_bottomView addSubview:btn];
        [btn setBackgroundImage:R_ImageName(@"login_btn_bg") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(postBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addLine_top];
        
    }
    return _bottomView;
}


-(UIImageView *)acceImageView{
    if (!_acceImageView) {
        _acceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 9, 16)];
        _acceImageView.right = KScreenWidth - iPW(93);
        _acceImageView.centerY = KCell_H/2.0f;
//        _acceImageView.hidden = YES;
        _acceImageView.image = R_ImageName(@"back_icon");
    }
    return _acceImageView;
}

@end
