//
//  MZCommonCell.m
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/20.
//  Copyright © 2018年 Simple. All rights reserved.
//

#import "MZCommonCell.h"

@interface MZCommonCell()
@property (nonatomic, strong) UILabel  *subLabel;

@end

@implementation MZCommonCell

+ (instancetype)cellWithId:(NSString *)cellId
{
    MZCommonCell *cell = [[MZCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    MZCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MZCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isBlankCell = NO;
        [cell.contentView addSubview:cell.subLabel];
        [cell.contentView addSubview:cell.rightLabel];
        [cell.contentView addSubview:cell.acceImageView];
        cell.textLabel.font = KFont16;
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:cell.leftLabel];
        cell.rightLabel.right = KScreenWidth-iPW(72);
    }
    return cell;
}
-(void)setShowAccessoryView:(BOOL)showAccessoryView{
    self.acceImageView.hidden = !showAccessoryView;
}

-(void)setSubTitle:(NSString *)subTitle{

    NSString *titlestr = checkStringIsEmty(self.leftLabel.text)? self.textLabel.text:self.leftLabel.text;
    CGSize size = [titlestr dd_stringCalculateSize:CGSizeMake(MAXFLOAT, KCell_H) font:self.leftLabel.font];
    self.subLabel.text = subTitle;
    self.subLabel.left = size.width+70;
}

+ (MZCommonCell *)blankSpaceCell
{
    MZCommonCell *cell = [[MZCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"No Need To Reused"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isBlankCell = YES;
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    cell.accessoryView = nil;
    cell.showAccessoryView = NO;
    cell.backgroundColor = [UIColor clearColor];
    [cell setInsetWithX:0];
    return cell;
}

+ (MZCommonCell *)blankCell
{
    MZCommonCell *cell = [[MZCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"No Need To Reused"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isBlankCell = YES;
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    cell.accessoryView = nil;
    cell.showAccessoryView = NO;
    cell.backgroundColor = [UIColor whiteColor];
    [cell setInsetWithX:0];
    return cell;
}
+ (MZCommonCell *)blankClearCell
{
    MZCommonCell *cell = [[MZCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"No Need To Reuseds"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isBlankCell = YES;
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    cell.accessoryView = nil;
    cell.showAccessoryView = NO;
    cell.backgroundColor = [UIColor clearColor];
    [cell setInsetWithX:0];
    return cell;
}
+(MZCommonCell *)cellWithLoadMoreButtonWithBlock:(BackTapAction)blcok{
   MZCommonCell* cell = [[self class] cellWithLoadMoreButton];
    cell.block = blcok;
    return cell;
}
+(MZCommonCell *)cellWithLoadMoreButton{
    MZCommonCell *cell = [[MZCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"No loadMoreButton"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:cell.loadMoreButton];
    [cell setInsetWithX:0];
    return cell;
}

-(UIButton *)loadMoreButton{
    if (!_loadMoreButton) {
        @weakify(self)
        _loadMoreButton = [UIButton dd_buttonSystemButtonWithFrame:CGRectMake(0, 0,KScreenWidth, 50.f) tapAction:^(UIButton *button) {
            @strongify(self)
            !self.block ?:self.block(button);
        }];
        _loadMoreButton.selected = NO;
        _loadMoreButton.userInteractionEnabled = YES;
        [_loadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
        [_loadMoreButton setTitle:@"正在加载..." forState:UIControlStateSelected];
        [_loadMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _loadMoreButton;
}



// ui
-(UIImageView *)acceImageView{
    if (!_acceImageView) {
        _acceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 9, 16)];
        _acceImageView.right = KScreenWidth - iPW(93);
        _acceImageView.centerY = KCell_H/2.0f;
        _acceImageView.hidden = YES;
        _acceImageView.image = R_ImageName(@"back_icon");
    }
    return _acceImageView;
}
-(UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, iPW(150), KCell_H)];
        _subLabel.font = KFont12;
        _subLabel.backgroundColor = [UIColor clearColor];
        _subLabel.textColor = [UIColor c_GrayColor];
    }
    return _subLabel;
}
-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel  =[[UILabel alloc] initWithFrame:CGRectMake(16, 0, iPW(140), KCell_H)];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = KFont16;
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.textColor = [UIColor c_mainBackColor];
    }
    return _leftLabel;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, iPW(140), KCell_H)];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = KFont16;
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textColor = [UIColor c_mainBackColor];
        _rightLabel.right = KScreenWidth -40;
    }
    return _rightLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (!self.isBlankCell) {
        [UIView animateWithDuration:0.3 animations:^{
            if(highlighted){
                self.backgroundColor = [UIColor whiteColor];
            }else
                self.backgroundColor = [UIColor whiteColor];
        }];
    }
}



@end
