//
//  RrMineAddressCell.m
//  Scanner
//
//  Created by edz on 2020/7/15.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrMineAddressCell.h"

@implementation RrMineAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (IBAction)editeBtnAction:(id)sender {
    !self.tapediteBtnAction ? :self.tapediteBtnAction();
}

- (void)setModel:(RrMineAddressMdoel *)model{
    _model = model;
    self.namePhoneLabel.text = [NSString stringWithFormat:@"%@ %@",model.consignee,model.phone];
    self.definBtn.hidden = !model.defaultAddr.boolValue;
    self.addressLabel_x.constant = !_model.defaultAddr.boolValue ? 0:75;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.provinceDesc,model.cityDesc,model.areaDesc,model.addrDetail];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
