//
//  RrAgreementView.m
//  Scanner
//
//  Created by edz on 2020/8/5.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define  KContent_X 93
#import "RrAgreementView.h"
#import "BaseWebViewController.h"
@interface RrAgreementView()
@property (nonatomic ,strong) UIView   * alertViewBg;       // 弹框背景
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIView *label;
@property (nonatomic, strong) UIView *bottomView;
@end
@implementation RrAgreementView


+ (void)showAgreementView{
    [RACScheduler.mainThreadScheduler afterDelay:1.25 schedule:^{
        if (![TZUserDefaults getBoolValueInUDWithKey:KUserDefaul_Key_agreement]) {
            RrAgreementView *agreementView = [[RrAgreementView alloc] init];
            [agreementView show];
        }
    }];
    
}

- (instancetype)init{
    if ([super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor c_alpha_bgWhiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    //标题
    [self.alertViewBg addSubview:self.titleBtn];
    if (self.type == RrAgreementViewType_privacy) {
        [self.titleBtn setImage:R_ImageName(@"user_privacy") forState:UIControlStateNormal];
        [self.titleBtn setTitle:@"隐私声明" forState:UIControlStateNormal];
        self.titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }else{
        [self.titleBtn setTitle:@"隐私保护提示" forState:UIControlStateNormal];
    }
    
    //内容
    if (self.label) {
        [self.label removeFromSuperview];
    }
    self.label = [self addContenLabel];
    [self.alertViewBg addSubview:self.label];
    
    // 底部按钮
    if (self.bottomView) {
       [self.bottomView removeFromSuperview];
    }
    self.bottomView = [self addBottomBtnView];
           [self.alertViewBg addSubview:self.bottomView];
    self.bottomView.top = self.label.bottom;
    
    self.alertViewBg.height = self.bottomView.bottom;
    [self addSubview:self.alertViewBg];
}


- (YYLabel *)addContenLabel{
    
    YYLabel *label1 = [[YYLabel alloc] initWithFrame:CGRectMake(28, self.titleBtn.bottom, self.alertViewBg.width-28*2, 202)];
    label1.textColor = [UIColor blackColor];
    label1.text = [self getContenSt];
    label1.numberOfLines = 0;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[self getContenSt]];
    // 2. 将属性设置为文本，可以使用几乎所有的CoreText属性。
    attributedText.yy_lineSpacing = 5;
    NSRange itemsRange = [label1.text rangeOfString:@"《用户协议》"];
    [attributedText yy_setTextHighlightRange:itemsRange
                                       color:[UIColor c_GreenColor]
                             backgroundColor:[UIColor clearColor]
                                   tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击文本的操作
        NSLog(@"《用户协议》");
        BaseWebViewController *webView = [BaseWebViewController new];
        webView.title = @"用户协议";
        webView.url = Kagreement;
        LXNavigationController *vc = (LXNavigationController *)KAppDelegate.window.rootViewController;
        [vc pushViewController:webView animated:YES];
    }];
    
    NSRange itemsRange2 = [label1.text rangeOfString:@"《隐私政策》"];
    [attributedText yy_setTextHighlightRange:itemsRange2
                                       color:[UIColor c_GreenColor]
                             backgroundColor:[UIColor clearColor]
                                   tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击文本的操作
        NSLog(@"《隐私政策》");
        BaseWebViewController *webView = [BaseWebViewController new];
        webView.title = @"隐私政策";
        webView.url = Kprivacy;
         LXNavigationController *vc = (LXNavigationController *)KAppDelegate.window.rootViewController;
        [vc pushViewController:webView animated:YES];

    }];
    
    label1.attributedText = attributedText;
    label1.font = KFont20;
    label1.userInteractionEnabled =YES;
    label1.numberOfLines = 0;
    [label1 sizeToFit];
    
    return label1;
}


- (NSString *)getContenSt{
    
    NSString *conten = @"";
    if (self.type == RrAgreementViewType_privacy) {
        conten = @"\t\t欢迎使用仁仁德糖橙系列客户端软件，糖橙辅具 APP 由广东仁仁德康复科技有限公司开发、拥有、运营的电子商务应用。\n\n\t\t请您了解，您需要注册成为糖橙用户后并完成相关认证方可使用本软件的网上购物功能。（关于注册，您可参考《用户协议》）。当您成功注册成为糖橙用户后，您可凭糖橙用户账号登录仁仁德旗下糖橙系列的多个平台应用，且无需另行注册账号。\n\n\t\t请您充分了解在使用本软件过程中我们可能收集、使用或共享您个人信息的情形，希望您着重关注：\n\n\t\t关于您个人信息的相关问题请详见《隐私政策》全文，请您认真阅读并充分理解，如您同意我们的政策内容，请点击同意并继续使用本软件。我们会不断完善技术和安全管理，保护您的个人信息。";
    }else{
        conten = @"\t\t亲，您的信任对我们非常重要。\n\n\t\t我们深知个人信息对您的重要性，我们将按法律法规要求，采取相应安全保护措施，尽力保护您的个人信息安全可控。在使用糖橙辅具各项产品或服务前，请您务必同意《隐私政策》。\n\n\t\t若您仍不同意本隐私政策，很遗憾我们将无法为您提供服务。";
    }
    return conten;
}

- (UIView *)addBottomBtnView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.alertViewBg.width, 189)];
    bottomView.backgroundColor =[UIColor clearColor];
    bottomView.bottom = self.alertViewBg.bottom;
    
    CGFloat btn_LR= 30;
    CGFloat btn_w = (self.alertViewBg.width - 50 -btn_LR*2) / 2;
    CGFloat btn_h = iPH(45);
    NSString *leftBtnTitle = @"不同意";
    UIButton *leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, btn_w, btn_h);
    leftBtn.backgroundColor = [@"C1C1C1" getColor];
    leftBtn.centerY = bottomView.height/2.0f;
    leftBtn.left = bottomView.left + btn_LR;
    leftBtn.titleLabel.font = KFont18;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.layer.cornerRadius = btn_h/2.0f;
    [leftBtn addTarget:self action:@selector(onTapLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.type == RrAgreementViewType_out) {
        leftBtnTitle = @"退出应用";
    }
    [leftBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
    
    
    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, btn_w, btn_h);
    rightBtn.titleLabel.font = KFont18;
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.centerY = leftBtn.centerY;
    rightBtn.right = bottomView.right - btn_LR;
    [rightBtn addCornerRadius: btn_h/2.0f];
    [rightBtn setBackgroundImage:R_ImageName(@"login_btn_bg") forState:UIControlStateNormal];
    [rightBtn setTitle:@"同意" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(onTapRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:leftBtn];
    [bottomView addSubview:rightBtn];
    
    return bottomView;
}

- (UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.userInteractionEnabled = NO;
        _titleBtn.frame = CGRectMake(0, 0, self.alertViewBg.width, 120);
        _titleBtn.titleLabel.font = KFont25;
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _titleBtn;
}

-(UIView *)alertViewBg{
    if(!_alertViewBg){
        _alertViewBg = [[UIView alloc]init];
        _alertViewBg.size = CGSizeMake( self.width-KContent_X*2, 360);
        _alertViewBg.backgroundColor = [UIColor whiteColor];
        _alertViewBg.layer.cornerRadius = 6;
        _alertViewBg.layer.masksToBounds = YES;
        _alertViewBg.center = CGPointMake(KScreenWidth/2.f, KScreenHeight/2.0f);
    }
    return _alertViewBg;
}


#pragma mark -- 处理逻辑
- (void)onTapLeftBtnAction:(UIButton *)leftBtn{
    if (self.type == RrAgreementViewType_out) {
        exit(0);
        return;
    }else{
        self.type = RrAgreementViewType_out;
        [self createUI];
        [self show];
    }
}


- (void)onTapRightBtnAction:(UIButton *)rightBtn{
    [TZUserDefaults saveBoolValueInUD:YES forKey:KUserDefaul_Key_agreement];
    [self disMiss];
}
- (void) show {
    WEAKSELF;
//    dispatch_async(dispatch_get_main_queue(), ^{
            [[UIViewController visibleViewController].view addSubview:self];
//    });
    weakSelf.alertViewBg.alpha = 0.f;
    weakSelf.alertViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
    [UIView animateWithDuration:.55 animations:^{
        weakSelf.alertViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
        weakSelf.alertViewBg.alpha = 1.f;
    } completion:^(BOOL finished) {
    }];
    self.alertViewBg.layer.position = CGPointMake(self.center.x, self.center.y);
}

-(void)disMiss{
    [UIView animateWithDuration:.25 animations:^{
        self.alertViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = touches.anyObject;//获取触摸对象
    if ([touch.view isEqual:self.alertViewBg]) {
        return;
    }
//    [self disMiss];
}

@end
