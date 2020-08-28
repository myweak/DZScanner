//
//  JassonSTLVC.m
//  Scanner
//
//  Created by zyq on 2018/10/24.
//  Copyright © 2018年 rrd. All rights reserved.
//

#import "JassonSTLVC.h"
#import "JassonSTLView.h"
#import <AFNetworking/AFNetworking.h>
#import <SSZipArchive.h>

static BOOL isDisMiss;

@interface JassonSTLVC ()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) BOOL isReStartZip;//重新解压 机制
@end

@implementation JassonSTLVC

- (void)viewDidAppear:(BOOL)animated{ //不执行super 防止 重复调用统计
    [MobClick beginLogPageView:@"3D模型预览"];

}
- (void)viewWillDisappear:(BOOL)animated{
    isDisMiss = YES;
    [super viewWillDisappear:animated];

}
- (void)viewDidDisappear:(BOOL)animated{
    isDisMiss = NO;
    [MobClick endLogPageView:@"3D模型预览"];
}

- (void)dealloc{
//    [self.downloadTask suspend];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReStartZip = YES;
    if (self.title == nil || self.title.length == 0) {
        self.title = @"3D模型预览";
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([self.curFileName hasPrefix:@"http"]) {
        [self downloadUrl];
        return;
    }else{
        if (![self.curFileName containsString:@"Documents"]) {
            NSString * path = [NSString BundlePath];
            self.curFileName =[path stringByAppendingPathComponent:self.curFileName];
        }
    }
    
    
    
    
    JassonSTLView *stlView = [[JassonSTLView alloc] initWithSTLPath:self.curFileName]; //设置场景的大小
    stlView.frame = self.view.bounds;
    [self.view addSubview:stlView];
}


- (void)downloadUrl{
    @weakify(self)
    
    /* 创建网络下载对象 */
    AFURLSessionManager *manager_url = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    /* 下载地址 */
     NSURL *url = [NSURL URLWithString:self.curFileName];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *pathDocument = [[NSString BundlePath] stringByAppendingPathComponent:LaoxiaoScan];
    
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
      BOOL existed = [fileManager fileExistsAtPath:pathDocument isDirectory:nil];
      if ( !existed ) {//如果文件夹不存在
          [fileManager createDirectoryAtPath:pathDocument withIntermediateDirectories:YES attributes:nil error:nil];
      }
    
    NSString *filePath = [pathDocument stringByAppendingPathComponent:url.lastPathComponent];

    // 1。//检查 沙盒是否有下载过当前文件
    BOOL resultZip = [fileManager fileExistsAtPath:filePath];
    BOOL resultStl = [fileManager fileExistsAtPath:[self zipFieldFormatToStl]];
    if (resultZip || resultStl) {
        if (!resultStl) {
            BOOL succes = [SSZipArchive unzipFileAtPath:filePath toDestination:pathDocument];
            if (!succes) {
                if (self.isReStartZip) {
                    self.isReStartZip = NO;
                    [self downloadUrl];
                    return;
                }
                showMessage(@"文件解压失败,请重新解压");
                [SVProgressHUD dismiss];
                return;
            }
        }
        
        [self showJassonSTLViewWithFilePath:[self zipFieldFormatToStl]];
        return;
    }
    
    
    /* 开始请求下载 */
    self.downloadTask = [manager_url downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!isDisMiss){
                [SVProgressHUD showProgress:downloadProgress.fractionCompleted  status:@"加载中……" maskType:SVProgressHUDMaskTypeNone];
            }
        });
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果需要进行UI操作，需要获取主线程进行操作
            // 解压
           BOOL succes = [SSZipArchive unzipFileAtPath:filePath toDestination:pathDocument];
            @strongify(self)
            if (succes) {
                [self showJassonSTLViewWithFilePath:[self zipFieldFormatToStl]];
            }else{
                if (self.isReStartZip) {
                    self.isReStartZip = NO;
                    [self downloadUrl];
                    return;
                }
                showMessage(@"文件解压失败,请重新解压！");
                [SVProgressHUD dismiss];
            }
        });
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            showMessage(@"加载失败");
        }
       
    }];
    [self.downloadTask resume];
    
    
}

//filePath :沙盒文件路径
- (void)showJassonSTLViewWithFilePath:(NSString *)filePath{
    JassonSTLView *stlView = [[JassonSTLView alloc] initWithSTLPath:filePath]; //设置场景的大小
    stlView.frame = self.view.bounds;
    [self.view addSubview:stlView];
}

// 将路径文件 zip 转化 stl
 - (NSString *)zipFieldFormatToStl{
     NSURL *url = [NSURL URLWithString:self.curFileName];
    NSString *pathDocument = [[NSString BundlePath] stringByAppendingPathComponent:LaoxiaoScan];

    NSArray *arr = [url.lastPathComponent componentsSeparatedByString:@"."];
     if (arr) {
        NSString *nameStr = [arr firstObject];
         return [pathDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.stl",nameStr]];
     }
    return @"";
}



@end
