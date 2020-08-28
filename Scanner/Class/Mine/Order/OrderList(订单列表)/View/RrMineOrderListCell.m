//
//  RrMineOrderListCell.m
//  Scanner
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineOrderListCell.h"
#import "SDWebImageDownloader.h"
@interface RrMineOrderListCell()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtn_xr;

@end
@implementation RrMineOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftBtn.layer.borderWidth = 1.0f;
    self.leftBtn.layer.borderColor = [UIColor c_lineColor].CGColor;
    
    self.rightBtn.layer.borderWidth = 1.0f;
    self.rightBtn.layer.borderColor = [UIColor c_btn_Bg_Color].CGColor;
}

- (void)setModel:(RrMineOrderListModel *)model{
    _model = model;
    self.outRradeNoLabel.text = [NSString stringWithFormat:@"%@%@",@"订单编号：",model.outTradeNo];
    self.orderStatusLabel.text = model.orderStatus_Str;
    [self.iconImageView sd_setImageWithURL:model.productIcon.url placeholderImage:KPlaceholderImage_product];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",model.productName,model.productCode];
    self.createTiemLabel.text = [NSString stringWithFormat:@"%@%@",@"下单时间：",[model.createTime dateStringFromTimeYMDHMS]];
    self.userNamePhoneLabel.text = [NSString stringWithFormat:@"%@%@ %@",@"用户：",model.patientName,model.patientPhone];
    self.feeLabel.text = [NSString stringWithFormat:@"%@%@",@"￥",model.totalFee];
    
    [self setBottomBtn];
}

- (void)setBottomBtn{
    if (!self.model) {
        return;
    }
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
            rightStr = @"付款提醒";
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

@end
