//
//  RrSettingVC.m
//  Scanner
//
//  Created by edz on 2020/7/16.
//  Copyright © 2020 rrdkf. All rights reserved.
//


#define SPushMessage_title          @"推送消息设置"
#define SAbout_title                @"关于我们"
#define SCahced_title               @"清除缓存"
#define SChangeWord_title           @"修改密码"
#define SSuggestion_title           @"问题反馈"
#define SOutLogin_title             @"退出登录"


#import "RrSettingVC.h"
#import "RrCodeValidationVC.h"  //  获取验证码VC --> 忘记密码 VC
#import "RrSettingJPushVC.h"
#import "RrSettingAboutVC.h"
#import "RrSuggestionVC.h"


@interface RrSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataTitleArr;

@end

@implementation RrSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataTitleArr = [NSMutableArray arrayWithArray:@[
            KCell_Space,
            SPushMessage_title,
            SAbout_title,
            KCell_Space,
            SCahced_title,
            SChangeWord_title,
            SSuggestion_title,
            KCell_Space,
            SOutLogin_title,
        ]];
    
    #ifdef DEBUG
    [self.dataTitleArr addObject:KCell_Space];
    [self.dataTitleArr addObject:SRrDBaseUrl];
#else
    #endif
    
    
    [self.tableView registerNibString:NSStringFromClass([RrCommonRowCell class]) cellIndentifier:RrCommonRowCell_ID];
    [self.view addSubview:self.tableView];
    
    
}



#pragma  mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataTitleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataTitleArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return iPH(17);
    }
    return KCell_H;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = self.dataTitleArr[indexPath.row];
    if ([title isEqualToString:KCell_Space]) {
        return [MZCommonCell blankSpaceCell];
    }
    
    RrCommonRowCell *cell = [tableView dequeueReusableCellWithIdentifier:RrCommonRowCell_ID forIndexPath:indexPath];
    cell.mainTitleLabel.text = title;
    cell.pushImageView.hidden = NO;
    cell.mainTitleLabel.hidden = NO;
    
    cell.mainTitleLabel.text = title;
    if ([title isEqualToString:SPushMessage_title]) {
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:7.0f];
        cell.bottonLineView.hidden = NO;
    }else if ([title isEqualToString:SAbout_title]) {
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadius:7.0f];
        
    }else if ([title isEqualToString:SCahced_title]) {
        cell.bottonLineView.hidden = NO;
        cell.pushImageView.hidden = YES;
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:7.0f];
        cell.rightLabel.text = [NSString stringWithFormat:@"%.2fM",[LXObjectTools getAppCacheAllSize]];
    }else if ([title isEqualToString:SChangeWord_title]) {
        cell.bottonLineView.hidden = NO;
    }else if ([title isEqualToString:SSuggestion_title]) {
           [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadius:7.0f];
    }else if ([title isEqualToString:SOutLogin_title]) {
        cell.pushImageView.hidden = YES;
        cell.mainTitleLabel.hidden = YES;
        cell.centerLabel.hidden = NO;
        cell.centerLabel.text = title;
        cell.centerLabel.textColor = [UIColor c_redColor];
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerAllCorners cornerRadius:7.0f];
    }else if ([title isEqualToString:SRrDBaseUrl]) {
        NSString *url = [RrUserDefaults getStrValueInUDWithKey:SRrDBaseUrl];
        cell.rightLabel.text = checkStrEmty(url) ? RrDBaseUrl:url;
        cell.contenViewBg.backgroundColor = [UIColor yellowColor];
        [cell.contenViewBg addCornerRadius:7.0f];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataTitleArr[indexPath.row];
    @weakify(self)
    if ([title isEqualToString:SPushMessage_title]) {
        RrSettingJPushVC *pushVc =[RrSettingJPushVC new];
        pushVc.title = SPushMessage_title;
        [self.navigationController pushViewController:pushVc animated:YES];
    }else if ([title isEqualToString:SAbout_title]) {
        RrSettingAboutVC *about = [RrSettingAboutVC new];
        about.title = SAbout_title;
        [self.navigationController pushViewController:about animated:YES];
    }else if ([title isEqualToString:SCahced_title]) {
        [self AlertWithTitle:@"提示" message:@"是否清除所有缓存" andOthers:@[@"取消",@"确认"] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                [LXObjectTools clearAppAllCache];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    }else if ([title isEqualToString:SChangeWord_title]) {
        RrCodeValidationVC *codeVc =[RrCodeValidationVC new];
        codeVc.phoneNum = aUser.phone;
        codeVc.title = SChangeWord_title;
        codeVc.type = RrCodeValidationVC_forget;
        [self.navigationController pushViewController:codeVc animated:YES];
    }else if ([title isEqualToString:SOutLogin_title]) {
        [self outLoginUrlWithBlock:nil];
        [[UserDataManager sharedManager] psuhLoginVC];
        
    }else if ([title isEqualToString:SSuggestion_title]) {
        RrSuggestionVC *sugVc = [RrSuggestionVC new];
        sugVc.title = SSuggestion_title;
        [self.navigationController pushViewController:sugVc animated:YES];
    }else if ([title isEqualToString:SRrDBaseUrl]){
            
            #ifdef DEBUG
           NSArray *arr = [LXObjectTools getRrDBaseUrlArr];
              [self ActionSheetWithTitle:@"更换域名" message:@"debug状态" destructive:@"取消" destructiveAction:^(NSInteger index) {
                  
              } andOthers:arr animated:YES action:^(NSInteger index) {
                  if (index != 0) {
                      [RrUserDefaults saveStrValueInUD:arr[index] forKey:SRrDBaseUrl];
                      exit(0);
                  }
              }];
#else
            #endif
  
    }
}

#pragma mark UI
- (UITableView *)tableView{
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 120;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor mian_BgColor];
        
        //        [_tableView registerNibString:NSStringFromClass([TZMineRowCell class]) cellIndentifier:TZMineRowCellID];
        
        //        _tableView.separatorInset = UIEdgeInsetsMake(0, iPW(53), 0, iPW(72));
    }
    return _tableView;
}


#pragma mark -PUSH VC
-(void)pushToLonginVC{
    LoginVC *login = [LoginVC new];
    login.hidenLeftTaBar = YES;
    [login addPsuhVCAnimationFromTop];
    [self.navigationController pushViewController:login animated:NO];
}


#pragma mark - 网络url
//通知服务器 退出。不用关心它能付成功
- (void)outLoginUrlWithBlock:(void(^)(BOOL succes)) block{
    [[RRNetWorkingManager sharedSessionManager] outLogin:nil result:NULL];
}


@end
