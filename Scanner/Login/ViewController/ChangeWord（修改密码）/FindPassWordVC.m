//
//  FindPassWordVC.m
//  Scanner
//
//  Created by edz on 2020/7/9.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "FindPassWordVC.h"
#import "RrCodeValidationVC.h" // 获取验证码

@interface FindPassWordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFlield;


@end

@implementation FindPassWordVC

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"找回密码"];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [MobClick beginLogPageView:@"找回密码"];
    
    if (![self.textFlield isFirstResponder]) {
        [self.textFlield becomeFirstResponder];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFlield.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text.length >11) {
        return NO;
    }
    return [text containsOnlyNumbers];
}


- (IBAction)popBtbnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)codeBtnAction:(id)sender {
    if (checkStrEmty(self.textFlield.text)) {
        showTopMessage(@"请输入手机号码");
        return;
    }
    if (![self.textFlield.text isMobileNumber]) {
        showTopMessage(@"手机号码格式错误");
        return;
    }
    RrCodeValidationVC *codeVc =[RrCodeValidationVC new];
    codeVc.phoneNum = self.textFlield.text;
    codeVc.type = RrCodeValidationVC_forget;
    [self.navigationController pushViewController:codeVc animated:YES];
    
}




@end
