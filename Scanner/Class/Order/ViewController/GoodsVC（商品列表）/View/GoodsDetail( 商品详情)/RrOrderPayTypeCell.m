//
//  RrOrderPayTypeCell.m
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderPayTypeCell.h"

@implementation RrOrderPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.onLinePayLBtn.selected = YES;
    [self.contenViewBg bezierPathWithRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadius:7.0f];
    
}

-(void)setPostModel:(RrDidProductDeTailModel *)postModel{
    _postModel = postModel;
    if ([self.postModel.payType integerValue] == 2) {
        self.offLinePayBtn.selected = YES;
    }else{
        self.offLinePayBtn.selected = NO;
    }
    self.onLinePayLBtn.selected =  !self.offLinePayBtn.selected;
}

- (IBAction)payTypeBtnAcion:(id)sender {
    if (self.tapPayTypeBlock) {
        self.tapPayTypeBlock(sender);
        return;
    }
    
    //支付方式:1在线支付，2线下支付
    NSInteger cornerRadius = 0.0f;
    if (self.offLinePayBtn == sender) { // 线下支付
        self.offLinePayBtn.selected = YES;
        self.onLinePayLBtn.selected = NO;
        self.postModel.payType = @(2);
        cornerRadius = 0.0f;
    }else{
        cornerRadius = 7.0f;
        self.offLinePayBtn.selected = NO;
        self.onLinePayLBtn.selected = YES;
        self.postModel.payType = @(1);
    }
    [self.contenViewBg bezierPathWithRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadius:cornerRadius];
    !self.onTapPayTypeBlock ? :self.onTapPayTypeBlock(self.onLinePayLBtn,self.offLinePayBtn);
}


- (void)changeBtnTypeWithBtn:(UIButton *) sender{
    //支付方式:1在线支付，2线下支付
    NSInteger cornerRadius = 0.0f;
    if (self.offLinePayBtn == sender) { // 线下支付
        self.offLinePayBtn.selected = YES;
        self.postModel.payType = @(2);
        cornerRadius = 0.0f;
    }else{
        cornerRadius = 7.0f;
        self.offLinePayBtn.selected = NO;
        self.postModel.payType = @(1);
    }
    self.onLinePayLBtn.selected = !self.offLinePayBtn.selected;

//    [self.contenViewBg bezierPathWithRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadius:cornerRadius];
    self.onLinePayLBtn.selected =  !self.offLinePayBtn.selected;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
