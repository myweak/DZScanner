//
//  RrOrderDetailUserInfoCell.m
//  Scanner
//
//  Created by edz on 2020/7/17.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderDetailUserInfoCell.h"

@implementation RrOrderDetailUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
}
- (void)setPostModel:(RrDidProductDeTailModel *)postModel{
    _postModel = postModel;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.phoneTextField == textField) {
        if (text.length >11) {
            return NO;
        }
         return [text containsOnlyNumbers];
    }
   return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.phoneTextField == textField) {
        self.postModel.patientPhone = textField.text;
    }else{
        self.postModel.patientName = textField.text;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
