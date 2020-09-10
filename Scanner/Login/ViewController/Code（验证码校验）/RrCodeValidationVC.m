//
//  RrCodeValidationVC.m
//  Scanner
//
//  Created by edz on 2020/7/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KNotifyTitle    @"请输入验证码"
#define DIGIT_HEIGHT    50
#define MARKER_X        18
#define MARKER_Y        18
#define NAVBAR_HEIGHT   64
#define SLIDE_DURATION  0.3 //  动漫时间
#define KdigitImageViewsBG_W iPW(300) //

#import "RrCodeValidationVC.h"
#import "GetCodeButton.h" // 倒计时
#import "RrLonginModel.h"
#import "PostUserInfoVC.h"// 提交资料
#import "CheckUserInfoVC.h" // 审核中
#import "RrChangeWordVC.h" // 修改密码VC
#import "RrCodeValidationVC.h"
@interface RrCodeValidationVC ()<UITextFieldDelegate>
{
    UITextField *passcodeTextField;
    UIView *contentView;
    UIImageView *digitImageViews[6];
    UILabel *messageLabel;
    UIImageView *failedImageView;
    UILabel *failedAttemptsLabel;
    UIView *digitPanel;   // textFiel 背景
    UILabel *lable;
    UILabel *subLable;
    NSInteger phase;
    UIImageView *snapshotImageView;
    
}
@property (nonatomic, strong)  UILabel *phoneLabel;
@property (retain) NSString *passcode;
@property (nonatomic, strong) GetCodeButton *codeBtn;


@end

@implementation RrCodeValidationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [[IQKeyboardManager sharedManager] setEnable:NO];
    //    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    if (![passcodeTextField isFirstResponder]) {
        [passcodeTextField becomeFirstResponder];
    }
    [IQKeyboardManager sharedManager].enable = NO;

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        [IQKeyboardManager sharedManager].enable = YES;
    //TODO: 页面Disappear 启用
    //   [[IQKeyboardManager sharedManager] setEnable:YES];
    //    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeadSendCodeTimeView];
    
    [self addTextFileldView];
    
    [self getCodeUrl];
}


- (void)addHeadSendCodeTimeView{
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, iPH(100)-64, 400, 30);
    titleLabel.centerX = KFrameWidth/2.0f;
    titleLabel.text = @" 请输入验证码";
    titleLabel.font = KFont17;
    titleLabel.textAlignment= NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *phoneLabel = [UILabel new];
    phoneLabel.frame = CGRectMake(0, titleLabel.bottom+iPH(30), 400, 30);
    phoneLabel.text = [NSString stringWithFormat:@"%@%@",@"已发送至手机",self.phoneNum];
    phoneLabel.font = KFont15;
    phoneLabel.textAlignment = NSTextAlignmentRight;
    [phoneLabel sizeToFit];
    phoneLabel.height = 30;
    phoneLabel.centerX = (KFrameWidth-100)/2.0f;
    self.phoneLabel = phoneLabel;
    [self.view addSubview:phoneLabel];
    
    // 获取验证码倒计时
    GetCodeButton *codeBtn = [GetCodeButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(phoneLabel.right+20, phoneLabel.top, 150, 30);
    codeBtn.titleLabel.font = KFont15;
    codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    codeBtn.buttonEnableColor = [UIColor redColor];
    codeBtn.buttonDisableColor = [UIColor grayColor];
    codeBtn.disableTitleColor = [UIColor c_GreenColor]; // 倒计时
    codeBtn.enableTitleColor = [UIColor c_GreenColor]; // 结束后的颜色
    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [codeBtn setTitle:@"60s" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(againCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    self.codeBtn = codeBtn;
    [codeBtn counting];
    [codeBtn getSubmitCodeWithAction:^{
        
    } completeCounting:^{
        
    }];
    
    
}

- (void)againCodeBtnAction:(GetCodeButton *)btn{
    [btn counting];
    [self getCodeUrl];
}


- (void)addTextFileldView{
    
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.phoneLabel.bottom+iPH(10), KScreenWidth, iPH(200))];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor mian_BgColor];
    [self.view addSubview:contentView];
    
    
    
    // View  背景
    digitPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KdigitImageViewsBG_W+22*5, DIGIT_HEIGHT)];  // 53
    digitPanel.backgroundColor = [UIColor mian_BgColor];
    digitPanel.centerX = KScreenWidth/2.0f;
    
    
    [contentView addSubview:digitPanel];
    contentView.userInteractionEnabled = YES;
    [digitPanel handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
        if ([self->passcodeTextField canBecomeFirstResponder]) {
            [self->passcodeTextField becomeFirstResponder];
        }
    }];
    
    UIImage *markerImage = [UIImage imageNamed:@"papasscode_marker"];  // 点
    
    for (int i=0;i<6;i++) {
        
        UIView *line = [[UIView alloc] init];
        line.frame =  CGRectMake(i*(KdigitImageViewsBG_W/6.0f+MARKER_X), 0, KdigitImageViewsBG_W/6.0f, DIGIT_HEIGHT);
        [digitPanel addSubview:line];
        line.layer.borderColor = [UIColor blackColor].CGColor;
        line.layer.borderWidth = 1.0f;
        
        digitImageViews[i] = [[UIImageView alloc] initWithImage:markerImage];
        digitImageViews[i].autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        digitImageViews[i].frame = CGRectOffset(digitImageViews[i].frame, i*(KdigitImageViewsBG_W/6.0f+MARKER_X)+MARKER_X+1, MARKER_Y);
        
        //
        [digitPanel addSubview:digitImageViews[i]];
        digitImageViews[i].hidden = i >= [self.passcode length];
    }
    
    passcodeTextField = [[UITextField alloc] initWithFrame:digitPanel.frame];
    passcodeTextField.hidden = YES;
    passcodeTextField.delegate =self;
    passcodeTextField.returnKeyType = UIReturnKeySend;
    passcodeTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    passcodeTextField.borderStyle = UITextBorderStyleNone;
    passcodeTextField.secureTextEntry = YES;
    passcodeTextField.textColor = [UIColor colorWithRed:0.23 green:0.33 blue:0.52 alpha:1.0];
    passcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [passcodeTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:passcodeTextField];
    
    
}

#pragma mark --验证码输入
- (void)passcodeChanged:(UITextField *)sender {
    
    NSString *text = passcodeTextField.text;
    self.passcode = text;
    NSLog(@"-------%@",text);
    if ([text length] > 6) {
        text = [text substringToIndex:6];
    }
    for (int i=0;i<6;i++) {
        digitImageViews[i].hidden = i >= [text length];
    }
    if ([text length] == 6) {
        [passcodeTextField resignFirstResponder];
        if (self.type == RrCodeValidationVC_codeLogin) {
            [self postCodeLoginUrl];
        }else if(self.type == RrCodeValidationVC_forget){
            [self getCodeCheckUrl];
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 6){
        return NO;//限制长度
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.type == RrCodeValidationVC_codeLogin) {
        [self postCodeLoginUrl];
    }else if(self.type == RrCodeValidationVC_forget){
        [self getCodeCheckUrl];
    }
    return YES;
}



#pragma mark - 网路 Url

- (void)postCodeLoginUrl{
    
    if (checkStringIsEmty(self.phoneNum)) {
        //获取用户数据 phone
        return;
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.phoneNum forKey:@"phone"];
    [parameter setValue:self.passcode forKey:@"code"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] codeLogin:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        
        if (error) {
            [self->passcodeTextField becomeFirstResponder];
            showTopMessage(responseModel.msg);
            [SVProgressHUD dismiss];
        }else{
            RrLonginModel *model = (RrLonginModel *)responseModel.item;
            [model saveUserData];
            [[RrUserTypeModel sharedDataModel] updateUserTypeUrlWithBlock:^(BOOL success,RrUserTypeModel *model) {
                [SVProgressHUD dismiss];
                if (success) {
//                    [[LXObjectTools sharedManager] updateAddressUrlPlist];
                    [self choseStatus:model];
                }
            }];
            
        }
    }, [RrLonginModel class])];
}

- (void)choseStatus:(RrUserTypeModel *)model{
    //status 工作人员 ( 0 基本信息待审核， 1 基本信息审核通过，2 基本信息被驳回 3 完整信息待审核  4完整信息审核通过， 5 完整信息被驳回 关联经销商待审核，7 关联经销商审核通过，8 关联经销商被驳回)
    CheckStatusType userStatus = model.statusType;
    if (userStatus == firstInfoSuccess ||
        userStatus == infoCheckSuccee ||
        userStatus == withInfoing ||
        userStatus == withInfoSuccess ||
        userStatus == withInfoUnSuccess) {
        //进入首页
        
        [[RrUserDataModel sharedDataModel] updateUserDataInfoUrlWithBlock:^(BOOL success, RrUserDataModel * _Nonnull model, RrResponseModel * _Nonnull responseModel) {
            [SVProgressHUD dismiss];
            if (success) {
                [UserDataManager registJPUSHServiceAlias];
                if ([KWindow.rootViewController isKindOfClass:[MainTabBarVC class]]) {
                    self.hidenLeftTaBar = NO;
                    
                    NSMutableArray *navArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                         for (UIViewController *VC in self.navigationController.viewControllers) {
                             NSLog(@"-----%@",VC);
                             if ([VC isKindOfClass:[LoginVC class]]){
                                 [navArr removeObject:VC];
                             }
                         }
                         self.navigationController.viewControllers = [navArr mutableCopy];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    KWindow.rootViewController = [MainTabBarVC new];
                }
            }else{
                showMessage(@"登陆失败");
            }
        }];
    } else if (userStatus == noUserInfo) {
        [SVProgressHUD dismiss];
        // 没有提交审核资料
        showMessage(@"您还没有提交审核资料");
        PostUserInfoVC *info =[PostUserInfoVC new];
        info.title = @"注册";
        [self.navigationController pushViewController:info animated:YES];
    } else if (userStatus == firstinfoUnSuceess ||
               userStatus == infoCheckUnSuccess ||
               userStatus == firstInfoing) {
        [SVProgressHUD dismiss];
        // 审核资料没有通过
        showMessage(userStatus == firstInfoing ? @"资料审核中":@"资料审核没有通过");
        CheckUserInfoVC *checkVc = [CheckUserInfoVC new];
        checkVc.title = @"我的信息";
        checkVc.type =  CheckUserInfoVCType_unCheck;
        
        [self.navigationController pushViewController:checkVc animated:YES];
        
    }
    
}


//获取验证码 url
- (void)getCodeUrl{
    // 1 注册短信 2 忘记密码 3 登录验证码
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[RRNetWorkingManager sharedSessionManager] getCode:@{@"phone":self.phoneNum,@"type":@(self.type)} basicToken:YES result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (error) {
            [self.codeBtn reset];
//            showTopMessage(@"获取验证码失败");
//            return;
        }
        showTopMessage(responseModel.msg);
    }, nil)];
}

// 验证码校验
- (void)getCodeCheckUrl{
    //code}/{phone}
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] getCodeCheck:@{KKey_1:self.passcode,KKey_2:self.phoneNum} basicToken:YES result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            RrChangeWordVC *changVc =[RrChangeWordVC new];
            changVc.phoneNum = self.phoneNum;
            changVc.phoneCode = self.passcode;
            changVc.title = self.title;
            [self.navigationController pushViewController:changVc animated:YES];
        }else{
            [self->passcodeTextField becomeFirstResponder];
            showTopMessage(responseModel.msg);
        }
        [SVProgressHUD dismiss];
    }, nil)];
}





@end
