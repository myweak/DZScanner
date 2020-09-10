//
//  RrMineOrderListCell.m
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineOrderListCell.h"
#import "SDWebImageDownloader.h"
#import "OYCountDownManager.h"

@interface RrMineOrderListCell()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtn_xr;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) OYCountDownManager *timeObjct;
@end

@implementation RrMineOrderListCell

- (void)awakeFromNib {
    [kCountDownManager removeAllSource];
    [kCountDownManager invalidate];
    
    self.outRradeNoLabel.font = KFont20;
    self.orderStatusLabel.font = KFont20;
    self.nameLabel.font = KFont20;
    self.feeLabel.font = KFont20;
    self.createTiemLabel.font = KFont17;
    self.userNamePhoneLabel.font = KFont20;
    self.leftBtn.titleLabel.font = KFont20;
    self.rightBtn.titleLabel.font = KFont20;


    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftBtn.layer.borderWidth = 1.0f;
    self.leftBtn.layer.borderColor = [UIColor c_lineColor].CGColor;
    
    self.timeView.layer.borderWidth = 1.0f;
    self.timeView.layer.borderColor = [UIColor c_lineColor].CGColor;
    
    self.rightBtn.layer.borderColor = [UIColor c_btn_Bg_Color].CGColor;
    [self.rightBtn setTitleColor:[UIColor c_btn_Bg_Color] forState:UIControlStateNormal];
    self.rightBtn.layer.borderWidth = 1.0f;
    
    
}



- (void)setModel:(RrMineOrderListModel *)model{
    _model = model;
    @weakify(self)
    self.outRradeNoLabel.text = [NSString stringWithFormat:@"%@%@",@"订单编号：",model.outTradeNo];
    self.orderStatusLabel.text = model.orderStatus_Str;
    [self.iconImageView sd_setImageWithURL:model.productIcon.url placeholderImage:KPlaceholderImage_product];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",model.productName,model.productCode];
    self.createTiemLabel.text = [NSString stringWithFormat:@"%@%@",@"下单时间：",[model.createTime dateStringFromTimeYMDHMS]];
    self.userNamePhoneLabel.text = [NSString stringWithFormat:@"%@%@ %@",@"用户：",model.patientName,model.patientPhone];
    self.feeLabel.text = [NSString stringWithFormat:@"%@%@",@"￥",model.totalFee];
    
    if ([kCountDownManager getIdentifierObject:self.model.outTradeNo]) {
        [kCountDownManager start];
        //          [kCountDownManager addSourceWithIdentifier:self.model.outTradeNo];
        //          [kCountDownManager reloadSourceWithIdentifier:self.model.outTradeNo];
        self.model.timePut = YES;
        self.timeView.hidden = NO;
    }
    //   [kCountDownManager addSourceWithIdentifier:self.model.outTradeNo];
    
    [self setBottomBtn];
    
    
    [self.nameLabel handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
        showMessage(@"复制成功");
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.productName;
    }];
    [self.outRradeNoLabel handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
        showMessage(@"复制成功");
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.outTradeNo;
    }];
    
}

- (void)setBottomBtn{
    if (!self.model) {
        return;
    }
    self.timeView.hidden = YES;
    self.bottomView.hidden = NO;
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    NSString *leftStr = @"取消订单";
    NSString *rightStr = @"";
    switch ([self.model.orderStatus intValue]) {
        case 0://已取消
            self.bottomView.hidden = YES;
            break;
        case 1:// 待完善
            rightStr = @"修改信息";
            self.leftBtn.hidden = YES;
            break;
        case 2://待审核
            self.bottomView.hidden = YES;
            break;
        case 3://待付款
            if ([self.model.payType intValue] == 2) {//支付方式:1在线支付，2线下支付
                self.rightBtn.hidden = YES;
                self.leftBtn_xr.constant = -154;
            }else{
                self.leftBtn_xr.constant = 34;
            }
            if (self.model.timePut) {
                self.timeView.hidden = NO;
            }
            rightStr = @"支付提醒";
            break;
        case 4://待加工分配
        case 5://待制作
            self.bottomView.hidden = YES;
            break;
        case 6://制作完成
            leftStr =  @"查看物流";
            rightStr = @"确认收货";
            break;
        case 7: // 已完成
            self.bottomView.hidden = YES;
            break;
            
        default:
            break;
    }
    [self.leftBtn setTitle:leftStr forState:UIControlStateNormal];
    [self.rightBtn setTitle:rightStr forState:UIControlStateNormal];
}



- (IBAction)leftBtnAction:(id)sender {
    !self.backBlock ?:self.backBlock(YES,NO);
}

- (IBAction)rightBtnAction:(id)sender {
    !self.backBlock ?:self.backBlock(NO,YES);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 付款提醒 倒计时逻辑

// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification:) name:OYCountDownNotification object:nil];
    }
    return self;
}

#pragma mark - 倒计时通知回调
- (void)startTime{
    [kCountDownManager start];
    [kCountDownManager addSourceWithIdentifier:self.model.outTradeNo];
    [kCountDownManager reloadSourceWithIdentifier:self.model.outTradeNo];
    self.model.timePut = YES;
    self.timeView.hidden = NO;
    
    [self countDownNotification:nil];
}
- (void)countDownNotification: (NSNotification *) notify{
    
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    /// 计算倒计时
    NSInteger timeInterval = 0;
    //    self.model.timePut = NO;
    if ([kCountDownManager getIdentifierObject:self.model.outTradeNo]) {
        //        NSLog(@"----%@",self.model.outTradeNo);
        timeInterval = [kCountDownManager timeIntervalWithIdentifier:self.model.outTradeNo];
        //    NSInteger timeInterval = kCountDownManager.timeInterval;
        
        NSInteger countDown = KTimeInterval - timeInterval;
        self.model.timePut = YES;
        
        /// 当倒计时到了进行回调
        if (countDown < 0) {
            self.model.timePut = NO;
            self.timeView.hidden = YES;
            [kCountDownManager removeSourceWithIdentifier:self.model.outTradeNo];
            
            // 回调给控制器
            if (self.countDownZero) {
                self.countDownZero(self.model);
            }
            return;
        }
        /// 重新赋值
        NSString *title = [NSString stringWithFormat:@"%ld",countDown];
        //        [self.rightBtn setTitle:title forState:UIControlStateNormal];
        self.timeLabel.text = title;
    }else{
        self.model.timePut = NO;
        self.timeView.hidden = YES;
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}





@end
