//
//  MineScanFieldCell.m
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MineScanFieldCell.h"

@implementation MineScanFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)editeBtnAction:(id)sender {
    !self.mineScanFieldCellBlock ?:self.mineScanFieldCellBlock(YES,NO);
}

- (IBAction)deleteBtnAction:(id)sender {
    !self.mineScanFieldCellBlock ?:self.mineScanFieldCellBlock(NO,YES);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
