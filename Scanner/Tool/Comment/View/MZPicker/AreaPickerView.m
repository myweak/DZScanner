//
//  MZPickerView.m
//  MiZi
//
//  Created by 飞礼科技 on 2018/7/30.
//  Copyright © 2018年 Simple. All rights reserved.
//
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

#import "AreaPickerView.h"

@interface AreaPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIButton    *_chooseBtn;
    UIButton    *_ensureBtn;
    //    NSDictionary *areaDic;
    
    RrAddressModel *  _selectedProvinceModel;
    RrAddressModel *  _selectedCityModel;
    RrAddressModel *  _selectedAraeModel;
    
    
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIPickerView * pickerView;

@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (nonatomic, assign) NSInteger count;
@end

@implementation AreaPickerView


#pragma mark -  更新数据


+ (void)saveArrayToData:(NSArray *)array
{
    
    NSString *filePath = [[self class] getAreaFilePathWithFileName:KFileNameAllAddress];

    BOOL status = [array writeToFile:filePath atomically:YES];
    
    if (status == YES) {
        NSLog(@"----> 保存成功！！！");
    }else{
        NSLog(@"----> 保存失败！！！");
    }
}

+ (NSString *)getAreaFilePathWithFileName:(NSString *)fileName
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.plist",fileName]];
    NSLog(@"-------> Log area plist : %@", filePath);
    return filePath;
}


- (instancetype) initWithShowPickerView:(ShowPickerViewRegionBlock)showPickerViewRegionBlock {
    
    if (self = [super init]) {
        @weakify(self)
        self.showPickerViewRegionBlock = [showPickerViewRegionBlock copy];
        self.frame = KScreen;
        self.backgroundColor = [UIColor c_alpha_bgWhiteColor];
        // 数据
        [self initDatas];
        //顶部确认取消 view
        [self addSelectView];
        
    }
    return self;
}

#pragma mark - select view Instance Methods

- (void)addSelectView {
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KFrameWidth, KCell_H)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    UIButton *button = [self custmButton:CGRectMake(iPW(10), 0, iPW(60), self.bgView.height) buttonTag:2 title:@"取消"];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *button2 = [self custmButton:CGRectMake(KFrameWidth - iPW(80), 0, iPW(60), self.bgView.height) buttonTag:1 title:@"确认"];
    [button2 setTitleColor:[UIColor c_GreenColor] forState:UIControlStateNormal];
    [self.bgView addSubview:button];
    [self.bgView addSubview:button2];
    [self.bgView addLine_bottom];
    //
    [self addSubview:self.pickerView];
    self.pickerView.delegate = self;
    
    self.bgView.bottom = self.pickerView.top;
}
-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KFrameWidth, KScreenHeight*2/5 -64)];
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIButton *)custmButton:(CGRect)frame
                buttonTag:(NSInteger)tag
                    title:(NSString *)title {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:0];
    button.tag = tag;
    button.titleLabel.font = KFont18;
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:1<<6];
    
    return button;
    
}

- (void)buttonAction:(UIButton *)sender {
    
    if (sender.tag == 2) {
        [self hide];
    }else if (sender.tag == 1){
        [self ensure];
    }
}

#pragma mark -根据表名路径。获取数据-->提取省 市 区 名称 areaName
// 数据排序
- (void)initDatas
{

    @weakify(self)
    NSString *areaPath = [AreaPickerView getAreaFilePathWithFileName:KFileNameAllAddress];
    NSArray * dataArrray =  [RrAddressModel mj_objectArrayWithFile:areaPath];
    if (dataArrray.count == 0 || !areaPath) {
        if (self.count >=2) {
            [self hide];
            [[RACScheduler mainThreadScheduler] afterDelay:0.5 schedule:^{
                showMessage(@"数据加载失败！");
            }];
            return;
        }
        [[LXObjectTools sharedManager] updateAddressUrlPlist];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            @strongify(self)
            [SVProgressHUD dismiss];
            self.count++;
            [self initDatas];
        }];
        return;
    }
    // 第一个 省份 市 用于 初始化
    RrAddressModel *provincModel = [dataArrray firstObject];
    
    
    // 第一个 省份 市 区 用于 初始化
    RrAddressModel *cityModel = [dataArrray firstObject];
    
    self.provinceArray = [[NSArray alloc] initWithArray: dataArrray];
    self.cityArray = [[NSArray alloc] initWithArray:  provincModel.item];
    self.townArray = [[NSArray alloc] initWithArray: cityModel.item];
    
    // 设置默认选中
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
}




#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 25)];
    titlLabel.backgroundColor = [UIColor clearColor];
    titlLabel.font = KFont20;
    titlLabel.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        RrAddressModel *model = [self.provinceArray objectAtIndex:row];
        titlLabel.text = model.areaName;
        return titlLabel;
    } else if (component == 1) {
        RrAddressModel *model = [self.cityArray objectAtIndex:row];
        titlLabel.text = model.areaName;
        return titlLabel;
    } else {
        RrAddressModel *model = [self.townArray objectAtIndex:row];
        titlLabel.text = model.areaName;
        
        return titlLabel;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return (KFrameWidth - 60) / 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return KCell_H;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    @weakify(self)
    if (self.provinceArray.count == 0) {
        return;
    }
    
    
    if (component == PROVINCE_COMPONENT) {
        _selectedProvinceModel = [self.provinceArray objectAtIndex: row];
        //选中的市
        self.cityArray =  _selectedProvinceModel.item;
        //选中的区 默认第一个
        _selectedCityModel =  [self.cityArray firstObject];
        self.townArray = _selectedCityModel.item;
        
        _selectedAraeModel = [self.townArray firstObject];
        
        [self.pickerView reloadAllComponents];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
            [self.pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        });
    }
    else if (component == CITY_COMPONENT) {
        _selectedCityModel = [self.cityArray objectAtIndex: row];
        //选中的区
        self.townArray =  _selectedCityModel.item;
        _selectedAraeModel = [self.townArray firstObject];
        
        [self.pickerView reloadComponent: DISTRICT_COMPONENT];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        });
        //    provinceStr = [provinceStr stringByReplacingOccurrencesOfString:@"　" withString:@""];
        
    }else{
        _selectedAraeModel = [self.townArray objectAtIndex: row];
    }
}

- (void) ensure {
    
    if (!self.provinceArray) {
        [iToast showCenter_ToastWithText:@"数据异常"];
        return;
    }else if (!_selectedProvinceModel|| !_selectedCityModel){
        [iToast showCenter_ToastWithText:@"修改失败，请重新选择"];
        return;
    }
    
    !self.showPickerViewRegionBlock ?:self.showPickerViewRegionBlock(_selectedProvinceModel,_selectedCityModel ,_selectedAraeModel);
    
    [self hide];
}

- (void) BezierPath:(UIButton *)sender {
    
    UIRectCorner rectCorner;
    
    
    if (sender.tag == 0)
    {
        rectCorner = UIRectCornerBottomLeft;
    }
    else
    {
        rectCorner = UIRectCornerBottomRight;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sender.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(5,0)];
    
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame   = sender.bounds;
    maskLayer.path    = maskPath.CGPath;
    sender.layer.mask = maskLayer;
}
- (void) show {
    
    [[UIViewController visibleViewController].view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerView.bottom = self.bottom;
        self.bgView.bottom = self.pickerView.top;
    }];
}

- (void) hide {
    @weakify(self)
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        self.bgView.top = KScreenHeight;
        self.pickerView.top = KScreenHeight;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void) dealloc {
    _bgView = nil;
    _pickerView = nil;
}
@end
