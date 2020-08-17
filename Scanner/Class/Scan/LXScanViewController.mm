//
//  LXScanViewController.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "LXScanViewController.h"
#import "ViewController.h"

@interface LXScanViewController ()

@end

@implementation LXScanViewController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"3D扫描";
    //    ViewController *scanVc = [ViewController viewController];
    //    [self addChildViewController:scanVc];
    //    [self.view addSubview:scanVc.view];
    
}

- (void)pushScanViewController{
    //    [self.view addSubview:scanVc.view];
    @weakify(self)
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        self.hidenLeftTaBar = YES;
        ViewController *scanVc = [ViewController viewController];
        [self.navigationController pushViewController:scanVc animated:YES];
        
    });
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
