//
//  RrSettingAboutVC.m
//  Scanner
//
//  Created by edz on 2020/8/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define KVersion_name @"版本"
#define KPrivacy_name @"隐私政策"
#define KAgreement_name @"用户协议"

#import "RrSettingAboutVC.h"
#import "BaseWebViewController.h"
@interface RrSettingAboutVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy)   NSString *app_Name ;
@property (nonatomic, copy)   NSString *app_Version ;

@end

@implementation RrSettingAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    
    self.app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    
    // app版本
    
    self.app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.dataArr = @[
        KVersion_name,
        KCell_Space,
        KPrivacy_name,
        KAgreement_name,
    ];
    self.tableView.tableHeaderView = [self addHeadView];
    [self.view addSubview:self.tableView];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return 17;
    }
    return KCell_H;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RrCommonRowCell *cell = [tableView dequeueReusableCellWithIdentifier:RrCommonRowCell_ID];
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:KVersion_name]) {
        cell.mainTitleLabel.text = KVersion_name;
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text =  [NSString stringWithFormat:@"v%@",self.app_Version];
        cell.bottonLineView.hidden = NO;
        [cell.contenViewBg addCornerRadius:7.0];
    }else if ([title isEqualToString:KPrivacy_name]){
        cell.mainTitleLabel.text = KPrivacy_name;
        cell.pushImageView.hidden = NO;
        cell.bottonLineView.hidden = NO;
        [cell.contenViewBg bezierPathWithRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadius:7.0];
    }else if ([title isEqualToString:KAgreement_name]){
        [cell.contenViewBg bezierPathWithRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadius:7.0];
        cell.mainTitleLabel.text = KAgreement_name;
        cell.pushImageView.hidden = NO;
    }else{
        return [MZCommonCell blankClearCell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseWebViewController *webView = [BaseWebViewController new];
    NSString *title = self.dataArr[indexPath.row];

    if (([title isEqualToString:KPrivacy_name])) {
        webView.title = @"隐私政策";
        webView.url = Kprivacy;
    }else if([title isEqualToString:KAgreement_name]){
        webView.title = @"用户协议";
        webView.url = Kagreement;
    }
    [self.navigationController pushViewController:webView animated:YES];
}

- (UITableView *)tableView{
    
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, (KFrameHeight-64)) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 73;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor mian_BgColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNibString:NSStringFromClass([RrCommonRowCell class]) cellIndentifier:RrCommonRowCell_ID];
        
    }
    return _tableView;
}

- (UIView *)addHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, 220)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, iPW(85), iPW(85))];
    imageView.image = R_ImageName([self getAppIconName]);
    imageView.centerX = view.width/2.0f;
    [imageView addCornerRadius:7.0f];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, 300, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = KFont18;
    titleLabel.text = self.app_Name;
    titleLabel.centerX = view.width/2.0f;
    
    [view addSubview:titleLabel];
    [view addSubview:imageView];
    
    
    return view;
}


/** 获取app的icon图标名称 */
- (NSString *)getAppIconName{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    NSString *iconLastName = [iconsArr lastObject];
    
    //打印icon名字
    NSLog(@"iconsArr: %@", iconsArr);
    NSLog(@"iconLastName: %@", iconLastName);
    /*
     打印日志：
     iconsArr: (
     AppIcon29x29,
     AppIcon40x40,
     AppIcon60x60
     )
     iconLastName: AppIcon60x60
     */
    return iconLastName;
}




@end
