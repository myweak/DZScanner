//
//  UITableViewCell+NATools.m
//  StraightPin
//
//  Created by Nathan Ou on 15/3/17.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UITableViewCell+NATools.h"

@implementation UITableViewCell (NATools)

-(UIView *)viewContent{
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setViewContent:(UIView *)viewContent{
    objc_setAssociatedObject(self,  @selector(viewContent), viewContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}






+ (instancetype)blankWhiteCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_blankCellReuseId];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInsetWithX:KScreenWidth];
    return cell;
}

+ (instancetype)blankWhiteCellWithID:(NSString *)indentifier
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    cell.backgroundColor =  [UIColor whiteColor];;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInsetWithX:KScreenWidth];
    return cell;
}

+ (instancetype)blankCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_blankCellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setInsetWithLeftAndRight:(CGFloat)xpoint
{
    self.separatorInset = UIEdgeInsetsMake(0, xpoint, 0, xpoint);
    if ([(UITableViewCell *)self respondsToSelector:@selector(setLayoutMargins:)]) {
        [(UITableViewCell *)self setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)setInsetWithLeft:(CGFloat)lpoint AndRight:(CGFloat)rpoint
{
    self.separatorInset = UIEdgeInsetsMake(0, lpoint, 0, rpoint);
    if ([(UITableViewCell *)self respondsToSelector:@selector(setLayoutMargins:)]) {
        [(UITableViewCell *)self setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)setInsetWithX:(CGFloat)xpoint
{
    self.separatorInset = UIEdgeInsetsMake(0, xpoint, 0, 0);
    if ([(UITableViewCell *)self respondsToSelector:@selector(setLayoutMargins:)]) {
        [(UITableViewCell *)self setLayoutMargins:UIEdgeInsetsZero];
    }
}
+ (UITableViewCell *)setCustomCell:(Class)cellClass insetWithX:(NSInteger)insetWidth tableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ID",NSStringFromClass(cellClass)]];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellClass) owner:nil options:nil] lastObject];
        NSLog(@"创建cell");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (insetWidth && insetWidth>=0) {
        [cell setInsetWithX:insetWidth];
    }else if(insetWidth==0){
        [cell setInsetWithX:0.f];
    }
    return cell;
}
@end
