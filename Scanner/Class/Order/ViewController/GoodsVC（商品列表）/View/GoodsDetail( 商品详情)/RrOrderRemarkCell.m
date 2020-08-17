//
//  RrOrderRemarkCell.m
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#import "RrOrderRemarkCell.h"

@implementation RrOrderRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.placeholder = @"请输入你需要备注的信息";
    self.textView.delegate = self;
}



- (void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    if (text.length >100) {
        textView.text = [text substringToIndex:99];
    }
    self.postModel.remark = textView.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
