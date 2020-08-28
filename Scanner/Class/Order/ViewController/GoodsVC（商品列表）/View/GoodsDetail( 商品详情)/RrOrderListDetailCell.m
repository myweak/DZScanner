//
//  RrOrderListDetailCell.m
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "RrOrderListDetailCell.h"

@implementation RrOrderListDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.detailView addSubview:self.webView];
    self.detailView_H.constant = self.webView.height;

}
- (WKWebView *)webView{
    if (!_webView) {
        //设置网页的配置文件
          WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
          // 允许可以与网页交互，选择视图
          Configuration.selectionGranularity = NO;
          // web内容处理池
          Configuration.processPool = [[WKProcessPool alloc] init];
          //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
          WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
          
          // 是否支持记忆读取
          Configuration.suppressesIncrementalRendering = YES;
          // 允许用户更改网页的设置
          Configuration.userContentController = UserContentController;
          
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(47, 0, KFrameWidth-(47+35), 20) configuration:Configuration];
         
         _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
 
    }
    return _webView;
}
+ (CGFloat)getDetailLabelHightWithStr:(NSString *) descriptionStr{
   CGSize size = [descriptionStr dd_stringCalculateSize:CGSizeMake(KFrameWidth-82, MAXFLOAT) font:[UIFont systemFontOfSize:19]];
    
    return MAX(73,  size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
