//
//  RrCommonRowCell.m
//  Scanner
//
//  Created by edz on 2020/7/10.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrCommonRowCell.h"
typedef void(^BackBOOLBlock)(BOOL obj1,BOOL obj2);

@interface RrCommonRowCell ()
@property (nonatomic, copy)   BackBOOLBlock block;
@end
@implementation RrCommonRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mainTitleLabel.font = KFont20;
    self.subTitleLabel.font = KFont18;
    self.centerLabel.font = KFont20;
    self.rightLabel.font = KFont20;
 

}

- (void)getCellSelectedBlock:(void (^)(BOOL selected ,BOOL animated)) block{
    self.block = [block copy];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if ([self.delegate respondsToSelector:@selector(getCellSelected:animated:)]) {
        [self.delegate getCellSelected:selected animated:animated];
    }
    !self.block ? :self.block(selected,animated);

}


- (void)setIsHidden_mianImageView:(BOOL)isHidden_mianImageView{
    _isHidden_mianImageView = isHidden_mianImageView;
    self.mianImageView.hidden = isHidden_mianImageView;
   
    self.mainTitleLabel_X.constant = isHidden_mianImageView ? 27 : 77;
}

@end
