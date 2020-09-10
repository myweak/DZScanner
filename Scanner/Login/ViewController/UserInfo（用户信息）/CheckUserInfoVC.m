//
//  CheckUserInfoVC.m
//  Scanner
//
//  Created by edz on 2020/7/9.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define SName_title               @"名字"
#define SAccount_title            @"账号"
#define SPhone_title              @"手机号"
#define SDepartment_title         @"科室"
#define SProfessional_title       @"职称"
#define SPostTitle_cell           @"证件照"
#define SMerchantsAccount_title   @"关联经销商"

#define KChecking    @"审核中"
#define KChecking_NO @"点击查看驳回原因"


#import "CheckUserInfoVC.h"
#import "AddPhotoView.h"
#import "RrEditeTitleVc.h"  // 修改 Vc
#import "PostUserInfoVC.h"
#import "RrCodeValidationVC.h"

@interface CheckUserInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) RrUserDataModel *model;

@property (nonatomic, strong) UIView *imageBarView; //经销商 证件照
@property (nonatomic, strong) AddPhotoView *addPView;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, assign) BOOL isChangeCertimg; // 是否有修改过 证件照
@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) UIButton *bottomBrtn; // 底部按钮

@end

@implementation CheckUserInfoVC

- (void)dealloc{
    self.rightBtn = nil;
}
- (void)viewDidAppear:(BOOL)animated{
//    self.tableView.width = KFrameWidth;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type != CheckUserInfoVCType_push) {
        NSMutableArray *navArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for (UIViewController *VC in self.navigationController.viewControllers) {
            NSLog(@"-----%@",VC);
            if ([VC isKindOfClass:[RrCodeValidationVC class]] ||
                [VC isKindOfClass:[PostUserInfoVC class]]) {
                [navArr removeObject:VC];
            }
//            if ([VC isKindOfClass:[LoginVC class]]){
//                [navArr addObject:VC];
//            }else if([VC isKindOfClass:[CheckUserInfoVC class]]){
//                [navArr addObject:VC];
//            }else if([VC isKindOfClass:[MineViewController class]]){
//                [navArr addObject:VC];
//            }
        }
        self.navigationController.viewControllers = navArr;
    }
    
    
    self.model = aUser;
    [self configUserData];
    //更新个人信息
    [self getUSerInfoURl];
    
    self.dataArr = @[
        KCell_Space,
        SName_title,
        SAccount_title,
        KCell_Space,
        SPhone_title,
        SDepartment_title,
        SProfessional_title,
        SPostTitle_cell,
        KCell_Space,
        SMerchantsAccount_title,
    ];
    [self.view addSubview:self.tableView];
    [self.tableView registerNibString:NSStringFromClass([RrCommonRowCell class]) cellIndentifier:RrCommonRowCell_ID];
    
    // 底部提交按钮
    if(self.type == CheckUserInfoVCType_unCheck ){
        @weakify(self);
        self.bottomBrtn = [self addBottomBtnWithTitle:@"提交" actionBlock:^(UIButton * _Nonnull btn) {
            @strongify(self)
            [self postUserInfo];
        }];
        self.tableView.height = self.bottomBrtn.top;
    }
}


- (void)configUserData{
    @weakify(self)
    if (self.model) {
        self.addPView.isCanEdite = self.type == CheckUserInfoVCType_unCheck ? YES :NO;
        if (self.model.certimg) {
            NSArray *array = [self.model.certimg componentsSeparatedByString:@","]; //字符串按照【分隔成数组
            self.addPView.imageUrl = array;
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.addPView updateAddPhotoView];
                [self setRightNaviBtn];
            });
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.tableView reloadData];
    });
}


- (void)setRightNaviBtn{
    /**
     firstInfoing = 0, // 0 基本信息待审核
     firstInfoSuccess, // 1 基本信息审核通过
     firstinfoUnSuceess, // 2 基本信息被驳回
     infoChecking, // 3 完整信息待审核
     infoCheckSuccee, // 4 完整信息审核通过
     infoCheckUnSuccess, // 5 完整信息被驳回
     withInfoing, // 6 关联经销商待审核
     withInfoSuccess, // 7 关联经销商审核通过
     withInfoUnSuccess, // 8关联经销商被驳回
     noUserInfo, // 9 用户审核资料没有填写
     */
    NSString *rightTitleStr;
    NSString *rightImageStr;
    switch (aUser.statusType) {
        case firstInfoing:
        case infoChecking:
        case withInfoing:
            // 待审核
        {
            rightTitleStr = KChecking;
            rightImageStr = @"";
        }
            break;
        case firstinfoUnSuceess:
        case infoCheckUnSuccess:
        case withInfoUnSuccess:
            //审核被驳回
        {
            rightTitleStr = KChecking_NO;
            rightImageStr = @"ckeck_notifi";
        }
            break;
            break;
        default:
            break;
    }
    @weakify(self)
    self.rightBtn = [self addRightNavigationCustomButtonWithActionBlock:^{
        @strongify(self)
        if ([self.rightBtn.currentTitle isEqualToString:KChecking_NO]) {
            MZShowAlertView *alert = [[MZShowAlertView alloc] initWithAlerTitle:@"提示" Content:self.model.remark];
            alert.tapEnadle = YES;
            [alert show];
        }
    }];
    [self.rightBtn setTitle:rightTitleStr forState:UIControlStateNormal];
    [self.rightBtn setImage:R_ImageName(rightImageStr) forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[@"FF1010" getColor] forState:UIControlStateNormal];
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return iPH(17);
    }else if([title isEqualToString:SPostTitle_cell]){
        return self.imageBarView.height;
    }
    return KCell_H;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return [MZCommonCell blankSpaceCell];
    }
    if ([title isEqualToString:SPostTitle_cell]) {
        MZCommonCell *cell =   [MZCommonCell blankSpaceCell];
        cell.backgroundColor = [UIColor mian_BgColor];
        [cell.contentView addSubview:self.imageBarView];
        [self.imageBarView addSubview:self.addPView];
        
        return cell;
    }
    RrCommonRowCell *cell = [tableView dequeueReusableCellWithIdentifier:RrCommonRowCell_ID forIndexPath:indexPath];
    cell.mainTitleLabel.text = title;
    cell.rightLabel.hidden = NO;
    cell.pushImageView.hidden = self.type == CheckUserInfoVCType_unCheck ? NO:YES;
    cell.bottonLineView.hidden = NO;
    if ([title isEqualToString:SName_title]) {
        cell.rightLabel.text = self.model.name;
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:7.0f];
        
    }else if ([title isEqualToString:SAccount_title]) {
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadius:7.0f];
        cell.rightLabel.text = self.model.account;
        cell.pushImageView.hidden = YES;
        cell.bottonLineView.hidden = YES;
        
    }else if ([title isEqualToString:SPhone_title]) {
        cell.rightLabel.text = self.model.phone;
        cell.pushImageView.hidden = YES;
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:7.0f];
        
    }else if ([title isEqualToString:SDepartment_title]) {
        cell.rightLabel.text = self.model.dept;
        
    }else if ([title isEqualToString:SProfessional_title]) {
        cell.rightLabel.text = self.model.title;
        
    }else if ([title isEqualToString:SMerchantsAccount_title]) {
        cell.pushImageView.hidden = self.type == CheckUserInfoVCType_check ? YES:NO;
        cell.rightLabel.text = checkStrEmty(self.model.companyCode) ? @"无":self.model.companyCode;
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerAllCorners cornerRadius:7.0f];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @ weakify(self)
    NSString *title = self.dataArr[indexPath.row];
    RrCommonRowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.type == CheckUserInfoVCType_check) {
        return;
    }
    
    
    RrEditeTitleVc *editVc = [RrEditeTitleVc new];
    editVc.title = @"我的信息";
    editVc.mainTitle = [NSString stringWithFormat:@"%@%@",title,@"："];
    editVc.placeholderStr = [NSString stringWithFormat:@"%@%@",@"请输入",title];
    editVc.type =  RrEditeTitleVcType_none;
    if ([title isEqualToString:SName_title]) {
        editVc.parameterKey = @"name";
    }else if([title isEqualToString:SDepartment_title]){
        editVc.parameterKey = @"dept";
    }else if([title isEqualToString:SProfessional_title]){
        editVc.parameterKey = @"title";
    }else if([title isEqualToString:SMerchantsAccount_title]){
        editVc.parameterKey = KRrEditeTitleVc_MerchantsAccount_title;
    }
    editVc.complementBlock = ^(NSString *titleName) {
        @strongify(self)
        cell.rightLabel.text = titleName;
        if ([title isEqualToString:SName_title]) {
            self.model.name = titleName;
        }else if([title isEqualToString:SDepartment_title]){
            self.model.dept = titleName;
        }else if([title isEqualToString:SProfessional_title]){
            self.model.title = titleName;
        }else if([title isEqualToString:SMerchantsAccount_title]){
            self.model.companyCode = titleName;
        }
        if ([title isEqualToString:SMerchantsAccount_title] &&  (self.type == CheckUserInfoVCType_mine || self.type == CheckUserInfoVCType_push)) { // 修改了 关联经销商
            [self.rightBtn setTitle:KChecking forState:UIControlStateNormal];
        }
    };
    
    if ((self.type == CheckUserInfoVCType_mine || self.type == CheckUserInfoVCType_push)) {
        if ([title isEqualToString:SMerchantsAccount_title]) {
            editVc.type = RrEditeTitleVcType_patchInfo;
            [self.navigationController pushViewController:editVc animated:YES];
        }
        return;
    }else{
        if ([title isEqualToString:SAccount_title] || [title isEqualToString:SPhone_title] ||[title isEqualToString:SPostTitle_cell]) {
            return;
        }
        [self.navigationController pushViewController:editVc animated:YES];
        
    }
    
}


#pragma mark UI
- (UITableView *)tableView{
    if (!_tableView) {//UITableViewStyleGrouped

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 120;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor mian_BgColor];
        
        //        [_tableView registerNibString:NSStringFromClass([TZMineRowCell class]) cellIndentifier:TZMineRowCellID];
        
        //        _tableView.separatorInset = UIEdgeInsetsMake(0, iPW(53), 0, iPW(72));
    }
    return _tableView;
}


-(UIView *)imageBarView{
    if (!_imageBarView) {
        _imageBarView = [[UIView alloc] initWithFrame:CGRectMake(17, 0,KFrameWidth -17*2 ,iPH(153))];
        _imageBarView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, iPH(27), 300, iPH(22))];
        titleLabel.text = SPostTitle_cell;
        titleLabel.font = KFont20;
        titleLabel.textColor = [UIColor c_mianblackColor];
        [_imageBarView addSubview:titleLabel];
        
        // 添加相片框
        [_imageBarView addSubview:self.addPView];
        
        [_imageBarView addCornerRadius:7.0f];
        
    }
    return _imageBarView;
}


- (AddPhotoView *)addPView{
    if (!_addPView) {
        @weakify(self)
        _addPView = [[AddPhotoView alloc] initWithFrame:CGRectMake(iPH(27), iPH(60), self.imageBarView.width -iPH(27)*2, iPH(85))];
        _addPView.isCanEdite = self.type == CheckUserInfoVCType_unCheck ? YES :NO;
        _addPView.complemntBlock = ^(AddPhotoView *photoView) {
            @strongify(self)
            self.isChangeCertimg = YES;
            self.imageBarView.height = photoView.bottom +iPH(8);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.tableView reloadData];
            });
        };
    }
    return _addPView;
}


#pragma mark -网路 URL
- (void)getUSerInfoURl{
    @weakify(self)
    if(self.type != CheckUserInfoVCType_mine){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    [[RrUserDataModel sharedDataModel] updateUserDataInfoUrlWithBlock:^(BOOL success,RrUserDataModel *model, RrResponseModel *responseModel) {
        if (success) {
            {
                self.model = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    [self configUserData];
                });
            }
        }else{
            showMessage(responseModel.msg);
        }
        [SVProgressHUD dismiss];
    }];
}


#pragma mark - 上传用户信息 URL
- (void)postUserInfo{
    
    if (checkStrEmty(self.model.name)) {
        showMessage(@"请填写姓名");
        return;
    }else if (checkStrEmty(self.model.dept)) {
        showMessage(@"请填写科室");
        return;
    }else if (checkStrEmty(self.model.title)) {
        showMessage(@"请填写职称");
        return;
    }
    if ([self.addPView.manger.currentAssets count] == 0 && [self.addPView.imageUrl count] == 0) {
        showMessage(@"请上传证件照");
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 提交过的 inage url
    if (([self.imageArr count] >0 && !self.isChangeCertimg)) {
        [self postUserInfo2:self.imageArr];
        return;
    }
    
    self.imageArr = [NSMutableArray arrayWithArray:self.addPView.imageUrl];
    // 七🐂 获取相册图片地址
    @weakify(self)
    [self.addPView.manger uploadCurrentAssetsWithCompletion:^(BOOL succeed, id imageDatas, id videoDatas) {
        @strongify(self)
        if (succeed) {
            if (imageDatas) {
                [imageDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *url =  [obj valueForKey:@"path"];
                    [self.imageArr addObject:[url imageUrlStr]];
                }];
            }else{
                [SVProgressHUD dismiss];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                [self postUserInfo2:self.imageArr];
            });
        }else{
            showMessage(@"上传证件照失败，请重新上传");
            [SVProgressHUD dismiss];
        }
    }];
    
}

//重新提交用户信息
- (void)postUserInfo2:(NSMutableArray *)imageArr{
    @weakify(self)
    self.isChangeCertimg = NO;
    // 提交信息
    NSString *certimg = [imageArr componentsJoinedByString:@","];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:aUser.ID forKey:@"id"];
    [parameter setValue:self.model.name forKey:@"name"];
    [parameter setValue:self.model.dept forKey:@"dept"]; //科室
    [parameter setValue:self.model.title forKey:@"title"]; //职称
    //关联经销商编码
    if (!checkStrEmty(self.model.companyCode)) {
        [parameter setObject:self.model.companyCode forKey:@"companyCode"];
    }
    [parameter setValue:certimg forKey:@"certimg"]; //从业资格图片URL ';'多图逗号隔开
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] POSTNextCheckUserInfo:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self)
        [SVProgressHUD dismiss];
        showMessage(responseModel.msg);
        if (!error) {
            self.type = CheckUserInfoVCType_check;
            self.tableView.height = KScreenHeight-64;
            self.bottomBrtn.hidden = YES;
            [self getUSerInfoURl];
        }
    }, nil)];
    
}


@end
