//
//  RrOfflinePayTypeCell.m
//  Scanner
//
//  Created by edz on 2020/7/23.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOfflinePayTypeCell.h"

@implementation RrOfflinePayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contenViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:7.0f];
    self.priceTextView.keyboardType =  UIKeyboardTypeNumberPad;
    self.priceTextView.placeholder = @"请输入金额";
    self.priceTextView.delegate = self;
    self.priceTextView.layer.masksToBounds = YES;
    self.priceTextView.layer.cornerRadius = 7.0f;
    self.priceTextView.layer.borderColor = [UIColor c_lineColor].CGColor;
    self.priceTextView.layer.borderWidth = 0.5f;
    
    self.addPhotoView.manger.maxPhotoNum = 3;
    
}
- (void)setPostModel:(RrDidProductDeTailModel *)postModel{
    _postModel = postModel;
    [self.contenViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:7.0f];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [textField.text stringByReplacingCharactersInRange:range withString:string];
}
- (void)textViewDidChange:(UITextView *)textView{
    self.postModel.AactualReceipts =  textView.text;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
