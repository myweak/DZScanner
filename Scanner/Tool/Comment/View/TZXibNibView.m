//
//  WkkeeperNibView.m
//  Wkkeeper
//
//  Created by 飞礼科技 on 2019/7/3.
//  Copyright © 2019 Darcy. All rights reserved.
//

#import "TZXibNibView.h"


@interface TZXibNibView ()
{
    CGRect myframe;
    BOOL isInit;
}
@end
@implementation TZXibNibView

-(void)awakeFromNib{
    [super awakeFromNib];
}


- (instancetype)viewWithName:(NSString *)name
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
    if (array.count) return array[0];
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self = [self viewWithName:NSStringFromClass([self class])];
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self viewWithName:NSStringFromClass([self class])];
        isInit = YES;
        myframe = frame;
    }
    return self;
    
}

-(void)drawRect:(CGRect)rect
{
    self.frame= isInit? myframe:self.frame;//关键点在这里
    
}


@end
