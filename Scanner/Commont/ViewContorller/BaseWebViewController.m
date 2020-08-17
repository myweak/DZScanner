//
//  BaseWebViewController.m
//  Scanner
//
//  Created by edz on 2020/7/7.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "BaseWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import "AssetsNoDataView.h"

@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate>

//@property (nonatomic,strong)AssetsNoDataView *noDataView;

@property (nonatomic, strong) UIProgressView *progressView;//设置加载进度条

//完成的拼接后的url请求
@property (nonatomic, strong) NSURLRequest *URLRequest;
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.url = @"https://www.baidu.com";
    //设置网页的配置文件
    WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
    // 允许可以与网页交互，选择视图
    Configuration.selectionGranularity = YES;
    // web内容处理池
    Configuration.processPool = [[WKProcessPool alloc] init];
    //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
    WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
    
    // 是否支持记忆读取
    Configuration.suppressesIncrementalRendering = YES;
    // 允许用户更改网页的设置
    Configuration.userContentController = UserContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KFrameWidth, KScreenHeight-64) configuration:Configuration];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    NSString * urlStr = self.url;
    

    
    self.URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:self.URLRequest];
    [self.view addSubview:self.webView];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.view addSubview:self.progressView];
    self.progressView.hidden = NO;
    
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:0
                      context:nil];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"getToken"];
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"getBasicParams"];
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"pushNewWebPage"];
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"copy2Clipboard"];
//    //跳转到商户详情页面 (1.0.0)
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"pushMerchantDetailPage"];
//    //跳转到主界面其他Tab页 (1.0.0)
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"pushMainPageTargetTab"];
//    //跳转到精准推荐
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"pushAccurateRecommendationPage"];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    if ([self.webView isLoading])
    //    {
    //        [self.webView stopLoading];
    //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //    }
//    doOk()
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:KJSToAPP_POPVC];

//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getToken"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getBasicParams"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushNewWebPage"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"copy2Clipboard"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushMerchantDetailPage"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushMainPageTargetTab"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushAccurateRecommendationPage"];
    
}



//解决白屏的方法二: wkwebview白屏时有概率会调用这个方法
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"白屏啦");
    [SVProgressHUD dismiss];
    [self.webView loadRequest:self.URLRequest];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    self.webView.hidden = NO;
    self.progressView.hidden = NO;
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{

}

- (NSString *)noWhiteSpaceString {
    NSString *newString;
    //去除掉首尾的空白字符和换行字符
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    可以去掉空格，注意此时生成的strUrl是autorelease属性的，所以不必对strUrl进行release操作！
    return newString;
}

///页面的回调
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{

    
    NSURL *url = navigationAction.request.URL;
    //其它需要允许的scheme也可以放在此处
    if ([url.scheme isEqualToString:@"weixin"] || [url.scheme isEqualToString:@"alipay"]) {
        if ( [[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        
    }
    
    //如果是打开的plist(下载安装ipa)或者mobileprovision(企业信任描述文件)的url,那么需要调到Safari浏览器".plist"
    if ([url.absoluteString containsString:@".plist"]||[url.absoluteString containsString:@".mobileprovision"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    self.noDataView.hidden = YES;
    [SVProgressHUD dismiss];


    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    self.noDataView.hidden = NO;
    
}

//拦截执行网页中的JS方法    --   监听
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
//    kSelfWeak;
//    if ([message.name isEqualToString:KJSToAPP_POPVC]) {
//        NSLog(@"%@ -- %@", message.name, message.body);
//        [SVProgressHUD dismiss];
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
//    //网页内部跳转  //getBasicParams
//    if ([message.name isEqualToString:@"getToken"]) {
//        NSString *token = [NSString stringWithFormat:@"getToken('%@')",aUser.token];
//    }
    

    
    
}


//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:@"title"]){
        //监听web页面title的改变,来设置navitem的title
        if (!checkStringIsEmty(self.webView.title)){
            //如果不为空,跟着web的标题设置
            self.navigationItem.title = self.webView.title;
            
        }else{
            //如果是空直,那么就不赋值,原本是什么就是什么
        }
        return;
    }
    
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:animated];
        
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                                 //                                 [self.progressView setHidden:YES];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}


- (NSString *)noWhiteSpaceString:(NSString *)newString {
    //去除掉首尾的空白字符和换行字符
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    可以去掉空格，注意此时生成的strUrl是autorelease属性的，所以不必对strUrl进行release操作！
    return newString;
}


-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc]
                                           initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame             = CGRectMake(0, 0, KScreenWidth, 2);
        
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                         green:240.0/255
                                                          blue:240.0/255
                                                         alpha:1.0]];
        _progressView.progressTintColor = [UIColor c_GreenColor];
    }
    return _progressView;
}

#pragma mark - 网页弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark - 点击事件

-(void)dealloc{
    //    if (self.inviestmentDetail) {
    //
    //    }else{
    [self.webView removeObserver:self
                      forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:@"title"];
    //    }
    
    [self clearDataStore];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


/// 清除缓存
- (void)clearDataStore {
    WKWebsiteDataStore *dataStore = WKWebsiteDataStore.defaultDataStore;
    NSSet *set = [NSSet setWithObjects:WKWebsiteDataTypeDiskCache
                  ,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeCookies, nil];
    [dataStore fetchDataRecordsOfTypes:set completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
        for (WKWebsiteDataRecord *obj in records) {
            [dataStore removeDataOfTypes:obj.dataTypes forDataRecords:records completionHandler:^{
                NSLog(@"Cookies for %@ deleted successfully",obj.displayName);
            }];
        };
    }];
}

/// 检查是不是我们的网址
- (BOOL)isOurWebsiteW: (NSString *)urlStr{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^http[s]?://.*orangeloan.jywhi.com/.*"]evaluateWithObject:urlStr] ||
    [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^http[s]?://.*orangedai.com/.*"]evaluateWithObject:urlStr];
}


\


@end
