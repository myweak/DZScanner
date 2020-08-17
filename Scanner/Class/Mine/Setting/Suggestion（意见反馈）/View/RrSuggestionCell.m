//
//  RrSuggestionCell.m
//  Scanner
//
//  Created by edz on 2020/8/13.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrSuggestionCell.h"

@implementation RrSuggestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentViewBg addCornerRadius:7.0f];
    [self.textFieldBgView addCornerRadius:7.0f];
    self.textView.placeholder = @"如：某个功能无法正常使用；页面白屏/卡顿/闪退；或者其他产品建议等（5个字以上）";
    self.textView.placeholderLabel.width = KFrameWidth-(17+10)*2;
    self.addPhotoView.photoW = 108;
    self.addPhotoView.manger.maxPhotoNum = 5;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
