//
//  RrMineMessageCell.m
//  Scanner
//
//  Created by edz on 2020/8/12.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#import "RrMineMessageCell.h"

@implementation RrMineMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.viewBg addCornerRadius:7.0f];
    self.timeLabel.textColor = [@"#808080" getColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
