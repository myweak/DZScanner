//
//  MineViewController.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define SOder_title          @"订单"
#define SFileManager_title   @"文件库 "
#define SMessage_title       @"消息"
#define SAddre_title         @"收货地址"
#define SSetting_title       @"设置"



#import "MineViewController.h"
#import "OrderViewController.h"
#import "LoginVC.h"
#import "MineHeaderView.h"
#import "RrMineAddressVC.h" // 收货地址
#import "LXObjectTools.h"
#import "AreaPickerView.h"
#import "CheckUserInfoVC.h" // 个人资料
#import "RrSettingVC.h"    //设置
#import "MineScanFieldVC.h" // 文件库
#import "RrMineOrderMianListVC.h" //订单
#import "RrMineMessageVC.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataTitleArr;
@property (nonatomic, strong) NSArray *dataImageArr;

@property (nonatomic, strong) MineHeaderView *headView;


@end

@implementation MineViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headView.headImageView sd_setImageWithURL:aUser.headimg.url placeholderImage:R_ImageName(@"user_icon_placeholder")];
    self.headView.nameLabel.text = aUser.name;
}

- (void)viewDidAppear:(BOOL)animated{
    self.hidenLeftTaBar = NO;
    [super viewDidAppear:animated];
    
 
}
- (void)addBackButton{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    //更新个人信息
    [RrUserDataModel updateUserInfo];
    
    self.dataTitleArr = @[
        KCell_Space,
        SOder_title,
        KCell_Space,
        SFileManager_title,
        SMessage_title,
        SAddre_title,
        KCell_Space,
        SSetting_title,
    ];
    self.dataImageArr = @[
        KCell_Space,
        @"mine_order",
        KCell_Space,
        @"mine_wenjianjia",
        @"system_message",
        @"mine_addre",
        KCell_Space,
        @"mine_set",
    ];

    
    @weakify(self)
     [self.view addSubview:self.tableView];
     self.tableView.tableHeaderView = self.headView;
     [self.tableView registerNibString:NSStringFromClass([RrCommonRowCell class]) cellIndentifier:RrCommonRowCell_ID];
     
     
     [self.headView.imageViewBg handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
         @strongify(self)
         CheckUserInfoVC *infoVC =[CheckUserInfoVC new];
         infoVC.type = CheckUserInfoVCType_mine;
         infoVC.title = @"个人资料";
         [self.navigationController pushViewController:infoVC animated:YES];
         
     }];
     [self.headView.headImageView handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
         @strongify(self)
         [[LXObjectTools sharedManager] tapAddPhotoImageBlock:^(NSString * imageUrl, UIImage * image) {
             [self patchHeadImageWitImageUrl:imageUrl Block:^{
                 @strongify(self)
                 [self.headView.headImageView setImage:image];
             }];
         }];
     }];

     
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
    cell.isHidden_mianImageView = NO;
    cell.mainTitleLabel.text = title;
    cell.pushImageView.hidden = NO;
    cell.mainTitleLabel.hidden = NO;
    cell.mianImageView.image = R_ImageName(self.dataImageArr[indexPath.row]);
    if ([title isEqualToString:SOder_title]) {
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerAllCorners cornerRadius:7.0f];
        
    }else if ([title isEqualToString:SFileManager_title]) {
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:7.0f];
        cell.bottonLineView.hidden = NO;
        
    }else if ([title isEqualToString:SMessage_title]) {
        cell.bottonLineView.hidden = NO;
    }else if ([title isEqualToString:SAddre_title]) {
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadius:7.0f];
    }else if ([title isEqualToString:SSetting_title]) {
        [cell.contenViewBg bezierPathWithRoundingCorners:UIRectCornerAllCorners cornerRadius:7.0f];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = self.dataTitleArr[indexPath.row];
    if ([title isEqualToString:SOder_title]) {
        RrMineOrderMianListVC *orderVc =[RrMineOrderMianListVC new];
        [self.navigationController pushViewController:orderVc animated:YES];
        
        
    }else if ([title isEqualToString:SFileManager_title]) {
        MineScanFieldVC *file = [MineScanFieldVC new];
        file.title = SMessage_title;
        [self.navigationController pushViewController:file animated:YES];
        
    }else if ([title isEqualToString:SMessage_title]) {
        RrMineMessageVC *messageVc = [RrMineMessageVC new];
        messageVc.title = @"消息中心";
        [self.navigationController pushViewController:messageVc animated:YES];
        
    }else if ([title isEqualToString:SAddre_title]) {
        RrMineAddressVC *addrVc = [RrMineAddressVC new];
        addrVc.title = @"收货地址";
        [self.navigationController pushViewController:addrVc animated:YES];
    }else if ([title isEqualToString:SSetting_title]) {
        RrSettingVC *setVc = [RrSettingVC new];
        setVc.title = @"设置";
        [self.navigationController pushViewController:setVc animated:YES];
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


- (MineHeaderView *)headView{
    if (!_headView) {
        _headView = [[MineHeaderView alloc] init];
        _headView.width = KFrameWidth;
    }
    return _headView;
}






#pragma mark - 网路 URL
// 更改用户信息-->头像
- (void)patchHeadImageWitImageUrl:(NSString *)imageUrl Block:(void (^)(void))block{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:aUser.ID forKey:@"id"];
    [parameter setValue:imageUrl forKey:@"headimg"];
    [[RRNetWorkingManager sharedSessionManager] patchChangeUserInfo:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            //更新个人信息
            [RrUserDataModel updateUserInfo];
            !block?:block();
        }else{
            showMessage(responseModel.msg);
        }
    }, nil)];
}

@end
