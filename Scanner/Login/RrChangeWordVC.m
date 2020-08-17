//
//  RrChangeWordVC.m
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrChangeWordVC.h"

@interface RrChangeWordVC ()
@property (weak, nonatomic) IBOutlet UIView *oneViewBg;
@property (weak, nonatomic) IBOutlet UIView *twoViewBg;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;


@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *textfieldTwo;

@end

@implementation RrChangeWordVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
      
   if (![self.textFieldOne isFirstResponder]) {
       [self.textFieldOne becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
//    [MobClick beginLogPageView:@"修改密码"];

}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
//    [MobClick endLogPageView:@"修改密码"];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.oneViewBg addLine_bottom];
    [self.twoViewBg addLine_bottom];
    [self.oneLabel changeAligLeftAndRight];
    self.textFieldOne.secureTextEntry = NO;
    self.textFieldOne.keyboardType =  UIKeyboardTypeNumberPad;
    self.textfieldTwo.secureTextEntry = NO;
    self.textfieldTwo.keyboardType =  UIKeyboardTypeNumberPad;

}
// 返回按钮
- (IBAction)popBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//保存
- (IBAction)saveBtnAction:(id)sender {
    [self.view endEditing:YES];
     if (![self.textFieldOne.text isEqualToString:self.textfieldTwo.text]) {
        showMessage(@"密码不一致");
        return;
    }
    if (![self.textFieldOne.text checkPassWorld]) {
        showMessage(@"请输入6位以上字母、数字的密码");
        return;
    }
    [self postChangeWordUrl];
}

- (void)postChangeWordUrl{
    //  phone code password
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.phoneNum forKey:@"phone"];
    [parameter setValue:self.phoneCode forKey:@"code"];
    [parameter setValue:[self.textFieldOne.text base64String] forKey:@"password"];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] postChangeWord:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            showTopMessage(@"修改成功");
            KWindow.rootViewController = [[LXNavigationController alloc] initWithRootViewController: [LoginVC new]];
        }else{
            showTopMessage(responseModel.msg);
        }
    }, nil)];
}


@end
