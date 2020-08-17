//
//  DatepickerView.m
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/31.
//  Copyright © 2018年 Simple. All rights reserved.
//


#import "DatepickerView.h"

@interface DatepickerView ()
{
    NSString *dateModeStr;
}
/// 时间选择器
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation DatepickerView

// -----------
- (id)initWithDateMode:(UIDatePickerMode)dateMode block:(DatePickerBlock) datePickerBlock;{
    
    if (self = [super init]) {
        self.frame = KScreen;
        self.datePickerBlock = [datePickerBlock copy];
        self.backgroundColor = [UIColor c_alpha_bgWhiteColor];
        [self dh_setDateMode:dateMode];
        dateModeStr = [self getTimeFormatStr:dateMode];
    }
    return self;
}

-(NSString *)getTimeFormatStr:(UIDatePickerMode)dateMode{
    //完成
    NSString * f = @"YYYY-MM-dd";
    /** 如果设置了时间模式*/
    if (dateMode == UIDatePickerModeTime) {
        f = @"HH:mm";
    }else
   if (dateMode == UIDatePickerModeCountDownTimer) {
       f = @"HH:mm";
   }else
    if (dateMode == UIDatePickerModeDateAndTime) {
       f = @"YYYY-MM-dd HH:mm";
    }else
    if (dateMode == UIDatePickerModeDate) {
        f = @"YYYY-MM-dd";
    }
    
    return f;
}

- (void)dh_setDateMode:(UIDatePickerMode)dateMode{
    _dateMode = dateMode;
    [self addSubview:self.datePicker];
    [_datePicker setCalendar:[NSCalendar currentCalendar]];
    [_datePicker setDatePickerMode:dateMode];
    [self addSelectView];
}
// ------------

- (void)addDatePickerView:(BOOL)isDate {
    
    [self addSelectView];
    [self addSubview:self.datePicker];
    
    if (isDate) {
        
        [_datePicker setCalendar:[NSCalendar currentCalendar]];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        //        _datePicker.minimumDate = [NSDate date];
    }else {
        [_datePicker setDatePickerMode:UIDatePickerModeTime];
    }
    
    
}


#pragma mark - select view Instance Methods

- (void)addSelectView {
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44)];
    self.bgView.backgroundColor = [UIColor redColor];
    self.bgView.userInteractionEnabled = YES;
    [self addSubview:self.bgView];
    
    UIButton *button = [self custmButton:CGRectMake(10, 5, 40, 35) buttonTag:2 title:@"取消"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *button2 = [self custmButton:CGRectMake(self.width - 50, 5, 40, 35) buttonTag:1 title:@"确认"];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.bgView addSubview:button];
    [self.bgView addSubview:button2];
    
    //
    self.bgView.bottom = self.datePicker.top;
}

- (UIButton *)custmButton:(CGRect)frame
                buttonTag:(NSInteger)tag
                    title:(NSString *)title {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:0];
    button.tag = tag;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:1<<6];
    
    return button;
    
}


- (void)buttonAction:(UIButton *)sender {
    
    NSString *date = @"";
    
    if (sender.tag == 1) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:dateModeStr];
        
        date = [dateFormatter stringFromDate:_datePicker.date];
        // 判断时间大小
        [self down:date];
        
    } else if (sender.tag == 2) {
        
        [self cancel];
    }
        
}

#pragma mark - Getter Instance Methods

- (UIDatePicker *)datePicker {
    
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, KScreenHeight, self.width, iPH(180))];
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        _datePicker.backgroundColor = [UIColor whiteColor] ;
        
    }
    
    return _datePicker;
}

#pragma mark - Setter Instance Methods
- (void)setMinTime:(NSString *)minTime{
    
    if (_minTime) {
        _minTime = minTime;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:dateModeStr];
        NSDate *date=[formatter dateFromString:_minTime];
        //最小日期
        _datePicker.minimumDate = date;
    }

}
-(void)setMaxTime:(NSString *)maxTime{
    if (maxTime) {
        _maxTime = maxTime;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:dateModeStr];
        NSDate *date=[formatter dateFromString:_maxTime];
        //最大日期
        _datePicker.maximumDate = date;
    }
}

#pragma mark - animate Instance Methods

- (void)show {

    [KWindow.rootViewController.view addSubview:self];
    @weakify(self)
    [UIView animateWithDuration:0.15 animations:^{
        @strongify(self)
        self.datePicker.bottom = self.bottom;
        self.bgView.bottom = self.datePicker.top;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)down:(NSString *)date {
    @weakify(self)

    [UIView animateWithDuration:0.25 animations:^{
     @strongify(self)
        self.datePicker.top = KScreenHeight;
        self.bgView.top = KScreenHeight;
        
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        
        if(self.datePickerBlock) {
            self.datePickerBlock(date);
        }
        [self removeFromSuperview];
    }];
}

- (void)cancel {
    @weakify(self)
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        self.datePicker.top = KScreenHeight;
        self.bgView.top = KScreenHeight;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = touches.anyObject;//获取触摸对象
    if ([touch.view isEqual:self.bgView]) {
        return;
    }
    if (self.isTap) {
        [self cancel];
    }
}


@end
