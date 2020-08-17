//
//  RrEditeTitleVc.m
//  Scanner
//
//  Created by edz on 2020/7/13.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrEditeTitleVc.h"

@interface RrEditeTitleVc ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation RrEditeTitleVc

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mainTitleLabel.text = self.mainTitle;
    self.textField.placeholder = self.placeholderStr;
    if (self.type == RrEditeTitleVcType_patchInfo) {
        if ([self.parameterKey isEqualToString:KRrEditeTitleVc_MerchantsAccount_title]) {
            self.textField.keyboardType =  UIKeyboardTypeNumberPad;
        }
    }
    if (![self.textField isFirstResponder]) {
         [self.textField becomeFirstResponder];
     }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate =  self;

    if (self.type == RrEditeTitleVcType_patchInfo) {
        if ([self.parameterKey isEqualToString:KRrEditeTitleVc_MerchantsAccount_title]) {
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.type == RrEditeTitleVcType_patchInfo) {
        if ([self.parameterKey isEqualToString:KRrEditeTitleVc_MerchantsAccount_title]) {
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
             return [text numberOrLetterChangeformat];
        }
    }

    return YES;
}

#pragma mnark - 确认按钮
- (IBAction)changeBtnAction:(id)sender {
    if (self.type == RrEditeTitleVcType_patchInfo) {
        if ([self.parameterKey isEqualToString:KRrEditeTitleVc_MerchantsAccount_title]) {
            [self getAssociatedUrl];
            return;
        }else{
            [self patchHeadImageWithBlock:nil];
            return;
        }
    }
    
    !self.complementBlock ?: self.complementBlock(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 网路 url
//修改个人资料
- (void)patchHeadImageWithBlock:(void (^)())block{
    @weakify(self)
    if (checkStrEmty(self.textField.text)) {
        showTopMessage([NSString stringWithFormat:@"%@%@",@"请填写",self.mainTitle]);
        return;
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:aUser.ID forKey:@"id"];
    [parameter setValue:self.textField.text forKey:self.parameterKey];
    [[RRNetWorkingManager sharedSessionManager] patchChangeUserInfo:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self)
        if (!error) {
            !block?:block();
            //更新个人信息
            [RrUserDataModel updateUserInfo];
            !self.complementBlock ?: self.complementBlock(self.textField.text);
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            showMessage(responseModel.msg);
        }
    }, nil)];
}
//工作人员绑定经销商
- (void)getAssociatedUrl{
    @weakify(self)
    if (checkStrEmty(self.textField.text)) {
        showTopMessage([NSString stringWithFormat:@"%@%@",@"请填写",self.mainTitle]);
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *dict = @{KKey_1:self.textField.text,KKey_2:aUser.ID};
    [[RRNetWorkingManager sharedSessionManager] getAssociated:dict result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self)
          if (!error) {
              //更新个人信息
              [RrUserDataModel updateUserInfo];
              !self.complementBlock ?: self.complementBlock(self.textField.text);
              [self.navigationController popViewControllerAnimated:YES];

          }
        showMessage(responseModel.msg);
        [SVProgressHUD dismiss];
    }, nil)];
}


@end
