//
//  LXNavigationController.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "LXNavigationController.h"

@interface LXNavigationController ()

@end

@implementation LXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance]setTranslucent:NO];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    
    [self.navigationBar setTitleTextAttributes:

    @{NSFontAttributeName:[UIFont systemFontOfSize:iPH(22)],

    NSForegroundColorAttributeName:[UIColor c_mianblackColor]}];
    
    self.navigationBar.tintColor = [UIColor c_GreenColor];
    self.navigationBar.barTintColor = [UIColor c_GreenColor];

    
//    UINavigationBar *navigationBar = self.navigationBar;
//      [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//
//    [navigationBar setShadowImage:[UIImage new]];
//    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:nil];
}



 
 
@end


/**
 一、for循环里的异步任务完成再进行其他操作


 // 1.创建一个串行队列，保证for循环依次执行
 dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
  
 // 2.异步执行任务
 dispatch_async(serialQueue, ^{
     // 3.创建一个数目为1的信号量，用于“卡”for循环，等上次循环结束在执行下一次的for循环
     dispatch_semaphore_t sema = dispatch_semaphore_create(1);
  
     for (int i = 0; i<5; i++) {
         // 开始执行for循环，让信号量-1，这样下次操作须等信号量>=0才会继续,否则下次操作将永久停止
         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
         printf("信号量等待中\n");
         // 模拟一个异步任务
         NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://github.com"]];
         NSURLSession *session = [NSURLSession sharedSession];
         NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         // 本次for循环的异步任务执行完毕，这时候要发一个信号，若不发，下次操作将永远不会触发
             [tampArray addObject:@(i)];
             NSLog(@"本次耗时操作完成，信号量+1 %@\n",[NSThread currentThread]);
             dispatch_semaphore_signal(sema);
  
         }];
         [dataTask resume];
  
         NSLog(@"上传动态照片到阿里云成功：%@", fileInfo.filePath);
         NSString *imgUrl = fileInfo.object;
         [self.imageUrls addObject:imgUrl];
         if (self.imageUrls.count == self.imagePaths.count) {
             // 上传动态照片到阿里云 完成
         }
  
     }
  
     NSLog(@"其他操作");
     for (NSNumber *num in tampArray) {
         NSLog(@"所有操作完成后的操作--->   %@\n",num);
     }
  
 });
 
 二、 队列组处理for循环里的异步任务
 // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
 dispatch_group_t group = dispatch_group_create();
 //创建全局队列
 dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
  
 dispatch_group_async(group, queue, ^{
     // 循环上传数据
     for (int i = 0; i < self.goodsArray.count; i++) {
         //创建dispatch_semaphore_t对象
         dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
         [manager POST:urlStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
             // responseObject 返回的数据
  
             // 请求成功发送信号量(+1)
             dispatch_semaphore_signal(semaphore);
  
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
             // 失败也请求成功发送信号量(+1)
             dispatch_semaphore_signal(semaphore);
         }];
         //信号量减1，如果>0，则向下执行，否则等待
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
     }
 });
  
 // 当所有队列执行完成之后
 dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   // 执行下面的判断代码
     if (state == self.goodsArray.count) {
        // 返回主线程进行界面上的修改
         dispatch_async(dispatch_get_main_queue(), ^{
            …….
         });
     }else{
         dispatch_async(dispatch_get_main_queue(), ^{
             …..
         });
     }
 });
 
 */
