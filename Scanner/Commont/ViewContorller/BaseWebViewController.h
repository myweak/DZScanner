//
//  BaseWebViewController.h
//  Scanner
//
//  Created by edz on 2020/7/7.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "MainViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebViewController : MainViewController
@property (nonatomic,strong)WKWebView *webView;

@property(nonatomic,copy)NSString *url;

//@property (copy, nonatomic)void (^testSuccssBlock)(void);


@end

NS_ASSUME_NONNULL_END
