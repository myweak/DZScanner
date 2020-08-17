//
//  MZShowalertViewBg.m
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/19.
//  Copyright © 2018年 Simple. All rights reserved.
//


#define KContent_X   iPW(300)
#define Kcontent_Top 123

#define KSelfAlert_W (self.width-KContent_X*2)

#define KAnimateDuration     0.3   //  弹框动画时间
#define Kbutton_H            KCell_H  //buttonArrays 按钮高度 73
#define SPACE                25.0f // 左边间隙
#import "MZShowAlertView.h"
#import "MZKeyboardDetectManager.h"

@interface MZShowAlertView()
@property (nonatomic, strong) UIButton *buttonArrays;     // 按钮数组

@property (nonatomic ,strong) UIView   * alertViewBg;       // 弹框背景
@property (nonatomic ,strong) UILabel  * titleLabel;      // 标题
//@property (nonatomic ,strong) UILabel  * contentLabel;    // 内容
@property (nonatomic ,strong) UIButton * cancelButton;    // 右上角 x 取消弹框按钮
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) UIView  *lineView;

@end

@implementation MZShowAlertView
@synthesize tapEnadle = _tapEnadle;

- (instancetype)init{
    if ([super init]) {
        [self addNSNotificationCenter];
    }
    return self;
}

#pragma mark -键盘弹出添加监听事件
- (void)addNSNotificationCenter{
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)dealloc{
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect startRact = [textField convertRect:textField.bounds toView:self.view];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
//        if ((startRact.origin.y+40)>keyboardF.origin.y )
//        { // 键盘的Y值已经远远超过了控制器view的高度
//            // 30工具栏
//            self.top =  keyboardF.origin.y - startRact.origin.y - 40;
//        }

    }];
    
    
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    //    self.textFiledScrollView.frame = CGRectMake(0, 64, kViewWidth, 455.5);
    // 动画的持续时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{

        
    }];
}



// ---
- (instancetype) initWithAlerTitle:(NSString *)title
                           Content:(NSString *)content
                       buttonArray:(NSArray *)buttonArrays
                   blueButtonIndex:(NSInteger) buttonIndex
                  alertButtonBlock:(ButtonActonBlock)alertButtonBlock{
 
    
    if (self == [super init]) {
        self.buttonActonBlock = [alertButtonBlock copy];
        self.buttonArrays = [buttonArrays copy];
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor c_alpha_bgWhiteColor];
        
        self.titleLabel.text   = title;
        self.contentLabel.text = content;
        
        CGFloat contentLabel_Y ;
        if (checkStringIsEmty(title)) {
            contentLabel_Y = 25;
            self.contentLabel.textColor = [UIColor whiteColor];
        }else{
            contentLabel_Y = self.titleLabel.bottom+5;
        }
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.numberOfLines = 0;
        CGRect frame = [self.contentLabel getLableHeightWithMaxWidth:self.contentLabel.width];
        self.contentLabel.frame = CGRectMake(SPACE, contentLabel_Y, self.alertViewBg.width - 2*SPACE, frame.size.height);
        
        
        // 按钮布局
        UIView *buttonViewBg = [UIView new];
        buttonViewBg.userInteractionEnabled = YES;
        buttonViewBg.backgroundColor = [UIColor clearColor];
        CGFloat buttonViewBg_y = checkStringIsEmty(title) ? 20:20;
        buttonViewBg.frame = CGRectMake(0, self.contentLabel.bottom+buttonViewBg_y, self.alertViewBg.width,(buttonArrays.count>=3 ? Kbutton_H *buttonArrays.count:Kbutton_H));
        buttonViewBg.clipsToBounds =YES;
        
        CGFloat Kbutton_W =  buttonViewBg.width /buttonArrays.count;
        for (int i =0; i<buttonArrays.count; i++) {
            
            UIButton *button = [[UIButton alloc] init];
            
            if (buttonArrays.count >=3) {
                [button setFrame:CGRectMake(0, i*(Kbutton_H), self.alertViewBg.width, Kbutton_H)];
            }else{
                [button setFrame:CGRectMake(i*Kbutton_W, 0, Kbutton_W, Kbutton_H)];
            }
            
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:buttonArrays[i] forState:UIControlStateNormal];
            [button.titleLabel setFont:KFont20];
            [button setTag:i];
            button.layer.cornerRadius = 5.0f;
            button.userInteractionEnabled =YES;
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = KFont18;
            UIColor *titleColor = nil;
            if (i == buttonIndex) {
                titleColor = [UIColor c_GreenColor] ;
            } else {
                titleColor =  [UIColor blackColor] ;
            }
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            [button setTitleColor:titleColor forState:UIControlStateHighlighted];
            
            // 加线
            [button addLine_top];
            // 中间线条
            if (buttonArrays.count > 1 && (i<buttonArrays.count-1) && buttonArrays.count < 3) {
                [button addLine_right];
            }
            
            [buttonViewBg addSubview:button];
        }
        
        [self.alertViewBg addSubview:buttonViewBg];
        self.alertViewBg.height = buttonViewBg.bottom;
        [self.alertViewBg addSubview:self.titleLabel];
        [self.alertViewBg addSubview:self.contentLabel];
        
        [self addSubview:self.alertViewBg];
        
    }
    return self;
}




- (instancetype) initWithAddViewAlerTitle:(NSString *)title
                              ContentView:(UIView *)contentView
                              buttonArray:(NSArray *)buttonArrays
                          blueButtonIndex:(NSInteger) buttonIndex
                         alertButtonBlock:(ButtonActonBlock)alertButtonBlock{
    if ([super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor c_alpha_bgWhiteColor];
        self.buttonActonBlock = [alertButtonBlock copy];
        self.titleLabel.text   = title;
        
        [self addSubview:self.alertViewBg];
        [self.alertViewBg addSubview:self.titleLabel];
        
        [self.alertViewBg addSubview:self.scrollView];
        [self.scrollView addSubview:contentView];
        self.titleLabel.text = title;

        contentView.width = self.scrollView.width-contentView.left *2;
        
        CGFloat contentView_max_h = self.height-76*2 - self.titleLabel.height -44-20;
        self.scrollView.contentSize = CGSizeMake(self.alertViewBg.width, contentView.height+contentView.top);

        self.scrollView.height = MIN(contentView_max_h, contentView.height+contentView.top+17);
    

        CGFloat Kbutton_W =  KSelfAlert_W /buttonArrays.count;
        for (int i =0; i<buttonArrays.count; i++) {
            
            UIButton *button = [[UIButton alloc] init];
            
            if (buttonArrays.count >=3) {
                [button setFrame:CGRectMake(0,self.scrollView.bottom+i*(Kbutton_H), self.alertViewBg.width, Kbutton_H)];
            }else{
                [button setFrame:CGRectMake(i*Kbutton_W, self.scrollView.bottom+0, Kbutton_W, Kbutton_H)];
            }
            
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:buttonArrays[i] forState:UIControlStateNormal];
            [button.titleLabel setFont:KFont20];
            [button setTag:i];
            button.layer.cornerRadius = 5.0f;
            button.userInteractionEnabled =YES;
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIColor *titleColor = nil;
            if (i == buttonIndex) {
                titleColor = [UIColor redColor] ;
            } else {
                titleColor =  [UIColor blackColor] ;
            }
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            [button setTitleColor:titleColor forState:UIControlStateHighlighted];
            
            // 加线
            [button addLine_top];
            // 中间线条
            if (buttonArrays.count > 1 && (i<buttonArrays.count-1) && buttonArrays.count < 3) {
                [button addLine_right];
            }
            
            [self.alertViewBg addSubview:button];
            self.alertViewBg.height = button.bottom;
        }

    }
    
    return self;
}



- (instancetype) initWithAlerTitle:(NSString *)title
                           Content:(NSString *)content{
    if ([super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor c_alpha_bgWhiteColor];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.alertViewBg];
        self.alertViewBg.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel.top = 0.f;
        [self.alertViewBg addSubview:self.titleLabel];
        UIView *textViewBg = [self addTextView];
        [self.alertViewBg addSubview:textViewBg];
//        [self.alertViewBg addSubview:self.cancelButton];
        
        self.titleLabel.text = title;
        self.textView.text = content;
        self.textView.textAlignment = NSTextAlignmentCenter;
        
        // 此计算比较准确
        CGSize size =[self.textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)];
        CGFloat textView_H = size.height;
        // 上下最大间隙
        CGFloat max_height = KScreenHeight - Kcontent_Top * 2 - self.titleLabel.height - 15 - 15;
        self.textView.height = textView_H  > max_height ? max_height:textView_H;
        self.textView.scrollEnabled = textView_H > max_height;
        
        textViewBg.height = self.textView.height;
        self.alertViewBg.height = textViewBg.bottom+15;
    }
    return  self;
}


#pragma mark -- 处理逻辑
- (void) show {
    WEAKSELF;
    [IQKeyboardManager sharedManager].enable = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        weakSelf.alertViewBg.alpha = 0.f;
        weakSelf.alertViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
        
        [UIView animateWithDuration:KAnimateDuration*0.6f animations:^{
            weakSelf.alertViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.06, 1.06);
            weakSelf.alertViewBg.alpha = 0.8;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:KAnimateDuration*0.4f animations:^{
                weakSelf.alertViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
                weakSelf.alertViewBg.alpha = 1.f;
            }];
        }];
        
        CGFloat keyboardHeight = 0.f;
        //键盘检测
        if ([MZKeyboardDetectManager sharedInstance].isVisible){
            keyboardHeight = 226.f;
        }
        self.alertViewBg.layer.position = CGPointMake(self.center.x, self.center.y-keyboardHeight/2.f);
    });
}
-(void)disMiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];

//        [UIView animateWithDuration:.1 animations:^{
//            self.alertViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
//            self.backgroundColor = [UIColor clearColor];
//        } completion:^(BOOL finished) {
//            [self removeFromSuperview];
//        }];
    });
    
    
    [IQKeyboardManager sharedManager].enable = YES;
}


#pragma mark - 事件监听
- (void)buttonClickedAction:(UIButton *)sender {
    NSLog(@"%ld",sender.tag);
    !self.buttonActonBlock ? : self.buttonActonBlock(sender.tag);
    !self.ShowAlertViewActonBlock ? : self.ShowAlertViewActonBlock(sender.tag);
    
    [self disMiss];
}
- (void)cancelButtonClickedAction:(UIButton *)sender {
    !self.cancelButtonBlock ? :self.cancelButtonBlock();
    [self disMiss];
}
//
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = touches.anyObject;//获取触摸对象
    if ([touch.view isEqual:self.alertViewBg]) {
        return;
    }
    if (self.tapEnadle) {
        !self.cancelButtonBlock ? :self.cancelButtonBlock();
        [self disMiss];
    }
}


#pragma mark -Set Get  commeUI

-(void)setTapEnadle:(BOOL)tapEnadle{
    _tapEnadle = tapEnadle;
}
// get
-(BOOL)tapEnadle{
    return _tapEnadle;
}

-(UIView *)addTextView{
    
    // 添加遮掩clipsToBounds背景
    UIView *contentTextViewBg = [[UIView alloc] initWithFrame: CGRectMake(0, self.titleLabel.bottom + 5, self.alertViewBg.width, 20)];
    contentTextViewBg.backgroundColor = [UIColor whiteColor];
    contentTextViewBg.layer.masksToBounds = YES;
    self.textView.clipsToBounds  = NO;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    self.textView.frame = CGRectMake(20, 0, contentTextViewBg.width-20-17, 30);
    [contentTextViewBg addSubview:self.textView];
    
    return contentTextViewBg;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.origin = CGPointMake(0, self.titleLabel.bottom);
        _scrollView.width = KSelfAlert_W;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.frame = CGRectMake(25, 64.5, 230, 1.0f);
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = KFont18;
        _textView.editable = NO;
        _textView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
        _textView.textColor = [UIColor blackColor];
    }
    return _textView;
}
-(UIView *)alertViewBg{
    if(!_alertViewBg){
        _alertViewBg = [[UIView alloc]init];
        _alertViewBg.size = CGSizeMake( self.width-KContent_X*2, 216);
        _alertViewBg.backgroundColor = [UIColor whiteColor];
        _alertViewBg.layer.cornerRadius = 5;
        _alertViewBg.layer.masksToBounds = YES;
        _alertViewBg.center = CGPointMake(KScreenWidth/2.f, KScreenHeight/2.0f);
    }
    return _alertViewBg;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.alertViewBg.width, iPH(73))];
        _titleLabel.font = KFont20;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE,self.titleLabel.bottom+SPACE,self.titleLabel.width-2*SPACE,20)];
        _contentLabel.font =KFont18;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.size = CGSizeMake(60, self.titleLabel.height);
        _cancelButton.top = 0;
        _cancelButton.right = self.alertViewBg.width - 16;
        [_cancelButton setImage:[UIImage imageNamed:@"new_icon-close"] forState:UIControlStateNormal];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_cancelButton setBackgroundColor:[UIColor clearColor]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelButton;
}

@end
