//
//  MineScanFieldVC.m
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrScanFileSearchVC.h"
#import "MineScanFieldCell.h"
#import "FMBDManagerTool.h"
#import "ScanFileModel.h"
#import "JassonSTLVC.h" //文件预览
#import "RrPostOrderListDetailVC.h"
@interface RrScanFileSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate >

@property (nonatomic, strong) UITextField *textFiled ;
@end

@implementation RrScanFileSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNibString:NSStringFromClass([MineScanFieldCell class]) cellIndentifier:KMineScanFieldCell_ID];

}

#pragma  mark - UITableViewDelegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return iPH(122);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScanFileModel *model = self.listArr[indexPath.section];
    MineScanFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:KMineScanFieldCell_ID forIndexPath:indexPath];
    [cell.imageViewss sd_setImageWithURL:model.preview.url placeholderImage:KPlaceholderImage_product];
    cell.titleLabelss.text = model.name;
    cell.subLabel.text = [model.createTime dateStringFromTimeYMDHMS];
    
    @weakify(self)
    cell.mineScanFieldCellBlock = ^(BOOL isEdite, BOOL isDelete) {
        @strongify(self)
        if (self.searchTypes == RrScanFileSearchVCType_choose) {
                   [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                   return;
               }
        if (isEdite) {
            
            
            // 弹窗
            UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"重命名3D扫描文件名称"
                   message: nil
            preferredStyle:UIAlertControllerStyleAlert];
            // 占位符
            [saveAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                @strongify(self)
                self.textFiled = textField;
                textField.placeholder = @"请输入名称";
                [self.textFiled becomeFirstResponder];
                self.textFiled.placeholder = model.name;
                self.textFiled.delegate = self;
                self.textFiled.returnKeyType = UIReturnKeyDone;
            }];
            // 确定按钮
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self)
                [self changeScanSourceUrlWithModel:model];

            }];
            // 取消按钮
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [saveAlert addAction:saveAction];
            [saveAlert addAction:cancelAction];
            [self presentViewController:saveAlert animated:YES completion:nil];

        }else{
            [self AlertWithTitle:@"提示" message:@"是否需要删除文件？" andOthers:@[@"取消",@"确认"] animated:YES action:^(NSInteger index) {
                if (index == 1) {
                    [self deleteScanSourceRULWithModel:model];
                }
            }];
        }
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanFileModel *model = self.listArr[indexPath.section];
       if (self.searchTypes == RrScanFileSearchVCType_choose) {
           !self.tapBlock ?: self.tapBlock(model);
           for (UIViewController *vc in self.navigationController.viewControllers) {
               if ([vc isKindOfClass:[RrPostOrderListDetailVC class]]) {
                   [self.navigationController popToViewController:vc animated:NO];
               }
           }
           return;
       }else{
           JassonSTLVC *showVc =[JassonSTLVC new];
           showVc.title = model.name;
           showVc.curFileName = model.sourceUrl;
           [self.navigationController pushViewController:showVc animated:YES];
       }
    

    
}



#pragma mark textFiled.delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma  mark - 网络url
//搜索
- (void)postHistoryRecordDataWithUrlKeyWord:(NSString *)keyWord{
    @weakify(self)
    [super postHistoryRecordDataWithUrlKeyWord:keyWord];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@(20) forKey:@"pageSize"];
    [parameter setValue:@(self.pageNum) forKey:@"pageNum"];
    [parameter setValue:keyWord forKey:@"name"];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager]postScanSourceList:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        @strongify(self);
        if (!error) {
            
            if (self.isHeadRefreshing) {
                self.listArr = [NSMutableArray arrayWithArray:responseModel.list];
            }else{
                [self.listArr addObjectsFromArray:responseModel.list];
            }
            
            RrDataPageModel *pageModel =  responseModel.pageData;
            if ([pageModel.total integerValue] == self.listArr.count && self.listArr.count !=0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            if (responseModel.list.count >0) {
                self.pageNum ++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
//                [self.tableView reloadData];
                [self updateListData];
            });
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }, [ScanFileModel class])];
}

// 修改 名称
- (void)changeScanSourceUrlWithModel:(ScanFileModel *) model{
    if (checkStrEmty(self.textFiled.text)) {
        showMessage(@"您还没有输入需要修改的名称");
        return;
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.ID forKey:@"id"];
    [parameter setValue:self.textFiled.text forKey:@"name"];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[RRNetWorkingManager sharedSessionManager] changeScanSource:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        showMessage(responseModel.msg);
        if (!error) {
            model.name = self.textFiled.text;
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    }, nil)];
    
}

//删除
- (void)deleteScanSourceRULWithModel:(ScanFileModel *) model{
    
    [[RRNetWorkingManager sharedSessionManager] deleteScanSource:@{KKey_1:model.ID} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            [self.listArr removeObject:model];
            [self.tableView reloadData];
        }
        showMessage(responseModel.msg);
    }, nil)];
    
}




@end
