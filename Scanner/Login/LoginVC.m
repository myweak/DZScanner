//
//  LoginVC.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "LoginVC.h"
#import "MainTabBarVC.h"
#import "RrLonginModel.h"
#import "RrLonginModel.h"
#import "RrCodeValidationVC.h" // 获取验证码
#import "RegistVC.h"
#import "BaseWebViewController.h"
#import "FindPassWordVC.h" // `忘记密码

#import "PostUserInfoVC.h"// 提交用户信息
#import "CheckUserInfoVC.h"  //审核 Vc

typedef NS_ENUM(NSInteger,LoginVCType) {
    LoginVCType_password = 0, // 密码登录
    LoginVCType_code, //验证码登录
};



@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;

@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet UIButton *enSourceBtn;//眼睛
@property (weak, nonatomic) IBOutlet UIView *passView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFild;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

// 忘记密码
@property (weak, nonatomic) IBOutlet UIView *forgoteView;
@property (weak, nonatomic) IBOutlet UILabel *forgotPassWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *registeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgotView_top; // 默认50



// 手机号码登录Veiw
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIButton *longinBtn;//登陆
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;//手机验证码登录

// 验证码登陆
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;// 获取验证码
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;// 账号登陆


// ----------- 属性
@property (nonatomic, strong) MainTabBarVC *tabarVc;
@property (nonatomic, assign) LoginVCType type;


@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"登陆"];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //清除token 及用户数据，
    [[UserDataManager sharedManager] deleteAllUserInfo];
    self.navigationController.navigationBar.hidden = YES;
     self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"登陆"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self configUI];
    
    
    [self addBottomView];
    
    
#pragma mark -键盘弹出添加监听事件
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (void)configUI{
    @weakify(self)
    //1.先隐藏验证码登录模块 , 留登录模块
    self.codeView.hidden =YES;
    self.accountView.hidden =NO;
    
    self.phoneTextFild.delegate = self;
    self.phoneTextFild.keyboardType =  UIKeyboardTypeNumberPad;
    [self.phoneTextFild addTarget:self action:@selector(textFildValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.passTextField.secureTextEntry = YES;
    self.passTextField.keyboardType =  UIKeyboardTypeNumberPad;

    // 登陆
    self.longinBtn.layer.cornerRadius = 44/2.0f;
    [self.longinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.longinBtn setBackgroundImage:R_ImageName(@"login_btn_bg") forState:UIControlStateNormal];
    //    [self.longinBtn setBackgroundImage:[UIImage imageWithColor:[UIColor c_BgGrayColor]] forState:UIControlStateNormal];
    
    // 验证码登陆
    self.codeLoginBtn.layer.borderWidth = 0.5f;
    self.codeLoginBtn.layer.cornerRadius = 44/2.0f;
    self.codeLoginBtn.layer.borderColor = [UIColor c_GreenColor].CGColor;
    
    
    
    // 账号登陆
    self.accountBtn.layer.borderWidth = 0.5f;
    self.accountBtn.layer.cornerRadius = 44/2.0f;
    self.accountBtn.layer.borderColor = [UIColor c_GreenColor].CGColor;
    
    
    //获取验证码
    self.getCodeBtn.layer.cornerRadius = 44/2.0f;
    self.getCodeBtn.backgroundColor = [UIColor c_BgGrayColor];
    
    
    
    // 忘记密码
    [self.forgotPassWordLabel handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
        @strongify(self)
        FindPassWordVC *findVc = [FindPassWordVC new];
        findVc.title = @"找回密码";
        [self.navigationController pushViewController:findVc animated:YES];
    }];
    
    // 立即注册
    [self.registeLabel handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
        @strongify(self)
        RegistVC *regist = [RegistVC new];
        regist.title = @"注册";
        [self.navigationController pushViewController:regist animated:YES];
    }];
    self.registeLabel.underlineColor = [UIColor c_GreenColor];
    self.registeLabel.underlineStr = self.registeLabel.text;
    [self.registeLabel reloadUIConfig];
    
    
}


#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.phoneTextFild == textField) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (text.length >11) {
            return NO;
        }
        return [text containsOnlyNumbers];
    }
    
    return YES;
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    UITextField *textField = self.phoneTextFild;
    if ([self.passTextField isFirstResponder]) {
        textField = self.passTextField;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect startRact = [textField convertRect:textField.bounds toView:self.view];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if ((startRact.origin.y+40)>keyboardF.origin.y )
        { // 键盘的Y值已经远远超过了控制器view的高度
            // 30工具栏
            self.view.top =  keyboardF.origin.y - startRact.origin.y - 40;
        }
    }];
    
    
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    //    self.textFiledScrollView.frame = CGRectMake(0, 64, kViewWidth, 455.5);
    // 动画的持续时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.top = 0;
    }];
}


- (void)textFildValueChanged:(UITextField *)textField{
    //    self.longinBtn.selected = textField.text.length >=11;
}


#pragma mark - btn Action  按钮事件



//眼睛
- (IBAction)ensoureBtnAction:(id)sender {
    BOOL b = !self.enSourceBtn.selected;
    self.enSourceBtn.selected = b;
    self.passTextField.secureTextEntry = !b;
        
}
#pragma mark -登陆
- (IBAction)loginBtnAction:(id)sender {
    
    if (checkStringIsEmty(self.phoneTextFild.text)) {
        showMessage(@"请输入账号");
        return;
    }else if(checkStringIsEmty(self.passTextField.text)){
        showMessage(@"请输入密码");
        return;
    }
    if (![self.phoneTextFild.text isMobileNumber]) {
        showMessage(@"手机号码格式错误");
        return;
    }else if(self.passTextField.text.length <6){
        showMessage(@"密码至少为六位字符");
        return;
    }
    [self postPhoneLoginUrl];
    
}
//手机验证码登录
- (IBAction)codeLoginBtnAction:(id)sender {
    self.codeView.hidden = NO;
    self.accountView.hidden = YES;
    self.forgotPassWordLabel.hidden = YES;
    self.passView.hidden = YES;
    self.forgotView_top.constant = 0;
}

// 账号登陆
- (IBAction)accountBtnAction:(id)sender {
//    KWindow.rootViewController = self.tabarVc;
    
    self.codeView.hidden = YES;
    self.accountView.hidden = NO;
    self.forgotPassWordLabel.hidden = NO;
    self.passView.hidden = NO;
    self.forgotView_top.constant = 65;
}

// 获取验证码
- (IBAction)getCodeBtnAction:(id)sender {
    if (checkStringIsEmty(self.phoneTextFild.text)) {
        showMessage(@"请输入账号");
        return;
    }
    if (![self.phoneTextFild.text isMobileNumber]) {
        showMessage(@"手机号码格式错误");
        return;
    }
    
    
    RrCodeValidationVC *codeVc =[RrCodeValidationVC new];
    codeVc.phoneNum = self.phoneTextFild.text;
    codeVc.type = RrCodeValidationVC_codeLogin;
    codeVc.title = @"验证码登陆";
    [self.navigationController pushViewController:codeVc animated:YES];
}

//登陆接口
- (void)postPhoneLoginUrl{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *dict = @{@"username":self.phoneTextFild.text,@"password":[self.passTextField.text base64String]};
    [[RRNetWorkingManager sharedSessionManager] login:dict result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (error) {
            showMessage(responseModel.msg);
            [SVProgressHUD dismiss];
        }else{
            RrLonginModel *model = (RrLonginModel *)responseModel.item;
            [model saveUserData];
            [[RrUserTypeModel sharedDataModel] updateUserTypeUrlWithBlock:^(BOOL success,RrUserTypeModel *typeModel) {
                if (success) {
                    [[LXObjectTools sharedManager] updateAddressUrlPlist];
                    [self choseStatus:typeModel];
                }else{
                    [SVProgressHUD dismiss];
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
        userStatus == withInfoUnSuccess)
    {
        //进入首页
        [[RrUserDataModel sharedDataModel] updateUserDataInfoUrlWithBlock:^(BOOL success, RrUserDataModel * _Nonnull model, RrResponseModel * _Nonnull responseModel) {
            [SVProgressHUD dismiss];
            if (success) {
                [UserDataManager registJPUSHServiceAlias];
                if ([KWindow.rootViewController isKindOfClass:[MainTabBarVC class]]) {
                    self.hidenLeftTaBar = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    KWindow.rootViewController = self.tabarVc;
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
        checkVc.type = userStatus == firstInfoing  ?  CheckUserInfoVCType_check:CheckUserInfoVCType_unCheck;
//        checkVc.type =  CheckUserInfoVCType_unCheck;

        [self.navigationController pushViewController:checkVc animated:YES];
        
    }
    
}


- (MainTabBarVC *)tabarVc{
    if (!_tabarVc) {
        _tabarVc = [MainTabBarVC new];
    }
    return _tabarVc;
}

- (void)addBottomView{
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(110, 0, KScreenWidth,30)];
    label.text = @"登录注册既表示您同意并愿意遵守用户协议、隐私条款";
    label.textColor = [UIColor c_mainBackColor];
    label.bottom = KScreenHeight;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"登录注册既表示您同意并愿意遵守用户协议、隐私条款"];
    // 2. 将属性设置为文本，可以使用几乎所有的CoreText属性。
    NSRange itemsRange = [label.text rangeOfString:@"用户协议、"];
    [attributedText yy_setTextHighlightRange:itemsRange
                                       color:[UIColor c_GreenColor]
                             backgroundColor:[UIColor clearColor]
                                   tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击文本的操作
        NSLog(@"《用户协议》");
        BaseWebViewController *webView = [BaseWebViewController new];
        webView.title = @"用户协议";
        webView.url = Kagreement;
        [self.navigationController pushViewController:webView animated:YES];
    }];
    NSRange itemsRange2 = [label.text rangeOfString:@"隐私条款"];
    [attributedText yy_setTextHighlightRange:itemsRange2
                                       color:[UIColor c_GreenColor]
                             backgroundColor:[UIColor clearColor]
                                   tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击文本的操作
        NSLog(@"《隐私政策》");
        BaseWebViewController *webView = [BaseWebViewController new];
        webView.title = @"隐私政策";
        webView.url = Kprivacy;
        [self.navigationController pushViewController:webView animated:YES];
    }];
    label.attributedText = attributedText;
    label.userInteractionEnabled =YES;
    label.font = KFont14;
    [label sizeToFit];
    label.centerX = KScreenWidth/2.0f;
    
    [self.view addSubview:label];
    
}


@end
