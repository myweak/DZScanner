//
//  RegistVC.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define SAccount_title      @"请设置账号"
#define SPassWord_title     @"请设置密码"
#define SNextPassWord_title @"请再次输入密码"
#define SPhone_title        @"请输入手机号码"
#define SCode_title         @"请请输入验证码"

#define SAgreement_cell     @"协议"
#define SBottomBtn_cell     @"注册按钮"
#import "GetCodeButton.h"

#import "RegistVC.h"
#import "BaseWebViewController.h"
#import "PostUserInfoVC.h"
#import "RrLonginModel.h"

@interface RegistVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passWordTextField;
@property (nonatomic, strong) UITextField *nextPassWordTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) GetCodeButton *codeBtn;

@property (nonatomic, strong) UIView *agreementView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, strong) UIView *phoneTextFieldViewBg;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = @[
        KCell_Space,
        SAccount_title,
        SPassWord_title,
        SNextPassWord_title,
        SPhone_title,
        SCode_title,
        SAgreement_cell,
        SBottomBtn_cell,
    ];
    //    CGRect frame =self.view.frame;
    //    NSLog(@"%f==%f",KScreenWidth,KScreenHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return iPH(23);
    }else if([title isEqualToString:SAgreement_cell]){
        return self.agreementView.height;
    }else if([title isEqualToString:SBottomBtn_cell]){
        return self.bottomView.height;
    }
    return iPH(73);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell blankCell];
    //    [cell setInsetWithX:KScreenWidth];
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return cell;
    }else if([title isEqualToString:SAgreement_cell]){
        [cell.contentView addSubview:self.agreementView];
        return cell;
    }else if([title isEqualToString:SBottomBtn_cell]){
        [cell.contentView addSubview:self.bottomView];
        return cell;
    }
    if ([title isEqualToString:SAccount_title]) {
        self.accountTextField.placeholder = title;
        [cell.contentView addSubview:self.accountTextField];
    }else  if ([title isEqualToString:SPassWord_title]) {
        self.passWordTextField.placeholder = title;
        [cell.contentView addSubview:self.passWordTextField];
    }else  if ([title isEqualToString:SNextPassWord_title]) {
        self.nextPassWordTextField.placeholder = title;
        [cell.contentView addSubview:self.nextPassWordTextField];
    }else  if ([title isEqualToString:SPhone_title]) {
        self.phoneTextField.placeholder = title;
        [cell.contentView addSubview:self.phoneTextFieldViewBg];
    }else  if ([title isEqualToString:SCode_title]) {
        self.codeTextField.placeholder = title;
        [cell.contentView addSubview:self.codeTextField];
    }
    return cell;
}

#pragma mark btn Action
// 获取验证码
- (void)againCodeBtnAction:(GetCodeButton *)btn
{
    if (checkStrEmty(self.phoneTextField.text)) {
        showTopMessage(@"请输入您的手机号码");
        return;
    }
    if ([self.phoneTextField.text isMobileNumber]) {
        [btn counting];
        //{phone}/{type}type : 1 注册短信 2 忘记密码 3 登录验证码
        [[RRNetWorkingManager sharedSessionManager] getCode:@{@"phone":self.phoneTextField.text,@"type":@"1"} basicToken:YES result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
            showTopMessage(responseModel.msg);
            if (error) {
                [self.codeBtn reset];
                return;
            }
        }, nil)];
    }else{
        showTopMessage(@"手机号码格式错误");
    }
    
}

//注册按钮
- (void)registBtnAction:(UIButton *)btn{
    [self.view endEditing:YES];
    
    if (checkStringIsEmty(self.accountTextField.text)) {
        showMessage(SAccount_title);
        return;
    }else if (checkStringIsEmty(self.passWordTextField.text)) {
        showMessage(SPassWord_title);
        return;
    }else if (checkStringIsEmty(self.nextPassWordTextField.text)) {
        showMessage(SNextPassWord_title);
        return;
    }else if (checkStringIsEmty(self.phoneTextField.text)) {
        showMessage(SPhone_title);
        return;
    }if (checkStringIsEmty(self.codeTextField.text)) {
        showMessage(SCode_title);
        return;
    }
    
    if (![self.accountTextField.text checkPassWorld]) {
        showMessage(@"请输入6位以上字母、数字的账号");
        return;
    }
    
    if (![self.passWordTextField.text isEqualToString:self.nextPassWordTextField.text]) {
        showMessage(@"密码不一致");
        return;
    }
    if (![self.passWordTextField.text checkPassWorld]) {
        showMessage(@"请输入6位以上字母、数字的密码");
        return;
    }
    
    if (!self.agreementBtn.selected) {
        showTopMessage(@"请选择已阅读并同意协议");
        return;
    }
    
    [self postRegistUrl];
    
}
#pragma mark Post URL
- (void)postRegistUrl{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.accountTextField.text forKey: @"username"];
    [parameter setValue:self.phoneTextField.text forKey:@"phone"];
    [parameter setValue:[self.passWordTextField.text base64String] forKey:@"password"];
    [parameter setValue:self.codeTextField.text forKey:@"code"];
    
////
//    NSLog(@"--->%@",[parameter mj_JSONString]);
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] postRegister:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (error) {
            showMessage(responseModel.msg);
            [SVProgressHUD dismiss];
        }else{
            RrLonginModel *model = (RrLonginModel *)responseModel.item;
            [model saveUserData];
            [[RrUserTypeModel sharedDataModel] updateUserTypeUrlWithBlock:^(BOOL success,RrUserTypeModel *model) {
                [SVProgressHUD dismiss];
                if (success) {
                    showMessage(@"注册成功");
                    PostUserInfoVC *info =[PostUserInfoVC new];
                    info.title = @"注册";
                    [self.navigationController pushViewController:info animated:YES];
                }
            }];
        }
    }, [RrLonginModel class])];
}



#pragma mark UI

- (UITableView *)tableView{
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 120;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        
        //        [_tableView registerNibString:NSStringFromClass([TZMineRowCell class]) cellIndentifier:TZMineRowCellID];
        
        //        _tableView.separatorInset = UIEdgeInsetsMake(0, iPW(53), 0, iPW(72));
    }
    return _tableView;
}

- (UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _accountTextField.font = KFont20;
        _accountTextField.keyboardType =  UIKeyboardTypeNumberPad;
        [_accountTextField addLine_bottom];
        _accountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _accountTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _accountTextField;
}
- (UITextField *)passWordTextField{
    if (!_passWordTextField) {
        _passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _passWordTextField.font = KFont20;
        _passWordTextField.keyboardType =  UIKeyboardTypeNumberPad;
        [_passWordTextField addLine_bottom];
        _passWordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _passWordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passWordTextField.secureTextEntry = YES;
    }
    return _passWordTextField;
}
- (UITextField *)nextPassWordTextField{
    if (!_nextPassWordTextField) {
        _nextPassWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _nextPassWordTextField.font = KFont20;
        _nextPassWordTextField.keyboardType =  UIKeyboardTypeNumberPad;
        [_nextPassWordTextField addLine_bottom];
        _nextPassWordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _nextPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
        _nextPassWordTextField.secureTextEntry = YES;
        
    }
    return _nextPassWordTextField;
}

- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72))-iPW(150), iPH(73))];
        _phoneTextField.font = KFont20;
        _phoneTextField.keyboardType =  UIKeyboardTypeNumberPad;
        [_phoneTextField addLine_bottom];
        _phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}
- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(iPW(53), 0, KScreenWidth-iPW((53+72)), iPH(73))];
        _codeTextField.font = KFont20;
        _codeTextField.keyboardType =  UIKeyboardTypeNumberPad;
        [_codeTextField addLine_bottom];
        _codeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, iPW(27), iPW(27))];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _codeTextField;
}

- (UIView *)phoneTextFieldViewBg{
    if (!_phoneTextFieldViewBg) {
        _phoneTextFieldViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, iPH(73))];
        
        // 获取验证码倒计时
        GetCodeButton *codeBtn = [GetCodeButton buttonWithType:UIButtonTypeCustom];
        codeBtn.frame = CGRectMake(0, 0, iPW(150), _phoneTextField.height);
        codeBtn.left =_phoneTextField.right;
        codeBtn.titleLabel.font = KFont18;
        codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        codeBtn.buttonEnableColor = [UIColor redColor];
        codeBtn.buttonDisableColor = [UIColor grayColor];
        codeBtn.disableTitleColor = [UIColor c_GreenColor]; // 倒计时
        codeBtn.enableTitleColor = [UIColor blackColor]; // 结束后的颜色
        [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeBtn addTarget:self action:@selector(againCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:codeBtn];
        self.codeBtn = codeBtn;
        codeBtn.backgroundColor = [UIColor whiteColor];
        [_phoneTextFieldViewBg addSubview:codeBtn];
        [_phoneTextFieldViewBg addSubview:self.phoneTextField];
        [codeBtn addLine_bottom];
        
    }
    return _phoneTextFieldViewBg;
}
- (UIView *)agreementView{
    if (!_agreementView) {
        _agreementView = [[UIView alloc] initWithFrame:CGRectMake(iPW(64), 0, KScreenWidth-iPW(64)*2, iPH(30))];
        //点击按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, iPH(60), iPH(60));
        btn.centerY = _agreementView.height/2.0f;
        [btn setImage:R_ImageName(@"regist_agree_n") forState:UIControlStateNormal];
        [btn setImage:R_ImageName(@"regist_agree_y") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.agreementBtn = btn;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [_agreementView addSubview:btn];
        
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 0, _agreementView.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"已阅读并同意《用户协议》《隐私政策》";
        label.textColor = [UIColor c_mainBackColor];

        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"已阅读并同意《用户协议》《隐私政策》"];
        // 2. 将属性设置为文本，可以使用几乎所有的CoreText属性。
        NSRange itemsRange = [label.text rangeOfString:@"《用户协议》"];
        [attributedText yy_setTextHighlightRange:itemsRange
                                           color:[UIColor c_GreenColor]
                                 backgroundColor:[UIColor clearColor]
                                       tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            //点击文本的操作
            NSLog(@"《用户协议》");
            BaseWebViewController *webView = [BaseWebViewController new];
            webView.title = @"用户协议";
            webView.url = [[Kagreement.url absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [self.navigationController pushViewController:webView animated:YES];
        }];
        NSRange itemsRange2 = [label.text rangeOfString:@"《隐私政策》"];
        [attributedText yy_setTextHighlightRange:itemsRange2
                                           color:[UIColor c_GreenColor]
                                 backgroundColor:[UIColor clearColor]
                                       tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            //点击文本的操作
            NSLog(@"《隐私政策》");
            BaseWebViewController *webView = [BaseWebViewController new];
            webView.title = @"用户协议";
            webView.url = Kprivacy;
            [self.navigationController pushViewController:webView animated:YES];
        }];
        label.attributedText = attributedText;
        label.font = KFont16;

        [label sizeToFit];
        label.right = _agreementView.width;
        label.bottom = _agreementView.bottom;
        btn.right = label.left-10;
        btn.centerY = label.centerY;
        label.userInteractionEnabled =YES;
        _agreementView.userInteractionEnabled = YES;
        
        
        [_agreementView addSubview:label];
    }
    return _agreementView;
}

- (void)agreementBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(iPW(64), 0, KScreenWidth-iPW(64)*2, iPH(113))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, _bottomView.width, 44);
        btn.bottom = _bottomView.bottom;
        [btn setTitle:@"注册" forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height/2.0f;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = KFont20;
        btn.backgroundColor = [UIColor grayColor];
        [_bottomView addSubview:btn];
        [btn setBackgroundImage:R_ImageName(@"login_btn_bg") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(registBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}


#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.phoneTextField == textField) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (text.length >11) {
            return NO;
        }
        return [text containsOnlyNumbers];
    }
    
    return YES;
}

@end
