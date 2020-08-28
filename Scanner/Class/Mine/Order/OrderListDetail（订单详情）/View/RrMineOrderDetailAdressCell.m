//
//  RrMineOrderDetailAdressCell.m
//  Scanner
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineOrderDetailAdressCell.h"

@implementation RrMineOrderDetailAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftBtn.layer.borderWidth = 1.0f;
    self.leftBtn.layer.borderColor = [UIColor c_lineColor].CGColor;
    
    self.rightBtn.layer.borderWidth = 1.0f;
    self.rightBtn.layer.borderColor = [UIColor c_btn_Bg_Color].CGColor;
    [self.contenViewBg bezierPathWithRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadius:7.0f];
    [self.contenViewBg setBackgroundColor:[UIColor whiteColor]];
}

- (void)setModel:(RrDidProductDeTailModel *)model{
    _model = model;
    self.nameLabel.text = model.doctorName;
    self.phoneLabel.text = model.doctorPhone;
    self.adressLabel.text = model.doctorAddr;
    [self setBottomBtn];
}

- (void)setBottomBtn{
    if (!self.model) {
        return;
    }
    NSString *rightStr = @"";
    self.leftBtn.hidden = YES;
    self.bottomViewBg.hidden = NO;
    switch ([self.model.orderStatus intValue]) {
        case 0://已取消
            self.bottomViewBg.hidden = YES;
            break;
        case 1:// 待完善
            rightStr = @"修改信息";
            self.leftBtn.hidden = YES;
            break;
        case 2://待审核
            self.bottomViewBg.hidden = YES;
            break;
        case 3://待付款
            if ([self.model.payType intValue] == 1) {//支付方式:1在线支付，2线下支付
                self.bottomViewBg.hidden = NO;
                rightStr = @"支付提醒";
            }else{
                self.bottomViewBg.hidden = YES;
            }

            break;
        case 4://待加工分配
        case 5://待制作
            self.bottomViewBg.hidden = YES;
            break;
        case 6://制作完成
            self.leftBtn.hidden = NO;
            rightStr = @"确认收货";
            break;
        case 7: // 已完成
            self.bottomViewBg.hidden = YES;
            break;
            
        default:

            break;
    }
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
