//
//  RrSuggestionVC.m
//  Scanner
//
//  Created by edz on 2020/8/12.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrSuggestionVC.h"
#import "RrSuggestionCell.h"
#import "AddPhotoView.h"
@interface RrSuggestionVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, copy)   NSString *phoneStr;
@property (nonatomic, copy)   NSString *contentDetailStr;
@property (nonatomic, copy)   NSString *imageURLStr;
@property (nonatomic, strong) AddPhotoView* photoView;

@end

@implementation RrSuggestionVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    @weakify(self)
    [self addBottomBtnWithTitle:@"提交" actionBlock:^(UIButton * _Nonnull btn) {
        @strongify(self)
        [self postSuggesion];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KScreenHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RrSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:KRrSuggestionCell_ID forIndexPath:indexPath];
    cell.textView.delegate = self;
    cell.phoneTextField.delegate = self;
   
    self.photoView = cell.addPhotoView;
    
    return cell;
    
}

- (UITableView *)tableView{
    
    if (!_tableView) {//UITableViewStyleGrouped
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, (KFrameHeight-64-50)) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 73;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor mian_BgColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNibString:NSStringFromClass([RrSuggestionCell class]) cellIndentifier:KRrSuggestionCell_ID];

    }
    return _tableView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
      if (text.length >11) {
          return NO;
      }
      return [text containsOnlyNumbers];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneStr = textField.text;
}

- (void)textViewDidChange:(UITextView *)textView{
    RrSuggestionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *text = textView.text;
    if (text.length>500) {
        textView.text = [text substringToIndex:500];
    }
    cell.numbTextLabel.text = [NSString stringWithFormat:@"%ld%@",textView.text.length,@"/500"];
    self.contentDetailStr = textView.text;
}

#pragma mark - Url
- (void)postSuggesion{
    if (checkStrEmty(self.contentDetailStr)) {
        showMessage(@"请输入您要反馈的内容！");
        return;
    }else if(self.contentDetailStr.length <5){
        showMessage(@"反馈内容至少要5个字符以上");
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    if ([self.photoView.manger.currentAssets count] >0) {
        NSMutableArray *mutArrUrl = [NSMutableArray arrayWithCapacity:5];
        [self.photoView.manger uploadCurrentAssetsWithCompletion:^(BOOL succeed, id imageDatas, id videoDatas) {
            if (succeed) {
                if (imageDatas) {
                    [imageDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *url =  [obj valueForKey:@"path"];
                        [mutArrUrl addObject:[url imageUrlStr]];
                        
                    }];
                    self.imageURLStr = [mutArrUrl componentsJoinedByString:@","];
                    [self postSuggesiontUrl];
                }
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }else{
        [self postSuggesiontUrl];
    }
}
- (void)postSuggesiontUrl{

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.contentDetailStr forKey:@"detail"];
    [parameter setValue:self.imageURLStr forKey:@"imgUrl"];
    [parameter setValue:self.phoneStr forKey:@"phone"];

    [[RRNetWorkingManager sharedSessionManager] postSuggesiont:parameter result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        showMessage(responseModel.msg);
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }, nil)];
}
@end
