//
//  RrOrderLabelView.m
//  Scanner
//
//  Created by edz on 2020/7/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderLabelView.h"

@implementation RrOrderLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    
    [self addSubview:self.contenViewBg];
    [self.contenViewBg addSubview:self.titleLabel];
}

- (NSMutableArray *)itemLabelViewArr{
    if (!_itemLabelViewArr) {
        _itemLabelViewArr = [NSMutableArray array];
    }
    return _itemLabelViewArr;
}


- (void)updateConfigUI{
    
    [self.itemLabelViewArr enumerateObjectsUsingBlock:^(UILabel  * label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx <= self.itemLabelArr.count) {
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }
    }];
    
    for (int i =0; i< self.itemLabelArr.count; i++) {
        UILabel *label;
        NSString *title = self.itemLabelArr[i];
        if (i< self.itemLabelViewArr.count) {
            label = self.itemLabelViewArr[i];
        }else{
            label  = [[UILabel alloc] init];
            label.frame = CGRectMake(self.titleLabel.left, 25+self.titleLabel.bottom+i*(25+20), self.width - 17*2, 20);
            label.font = KFont19;
            label.textColor = [UIColor c_mianblackColor];
            [self.itemLabelViewArr addObject:label];
        }
        label.text = title;

        if ((i == self.itemLabelArr.count -1) &&[title containsString:@"备注："] ) {
            label.numberOfLines = 0;
            label.lineSpace = 8;
            label.height = [label getLableHeightWithMaxWidth: self.width - 17*2].size.height;
        }else{
            label.numberOfLines = 1;
            label.height = 20;
        }
        
        [self.contenViewBg addSubview:label];
        self.contenViewBg.height = label.bottom + 36;
    }
    self.height =  self.contenViewBg.height;
    
}


- (UIView *)contenViewBg{
    if (!_contenViewBg) {
        _contenViewBg =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _contenViewBg.backgroundColor = [UIColor whiteColor];
        [_contenViewBg addCornerRadius:7.0f];
    }
    return _contenViewBg;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 17, 400, 21)];
        _titleLabel.font =KFont20;
    }
    return _titleLabel;;
}

@end
