//
//  RrOrderListDetailCell.h
//  Scanner
//
//  Created by edz on 2020/7/20.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrOrderListDetailCell_ID  @"RrOrderListDetailCell_id"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RrOrderListDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabels;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailView_H;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel; // 描述
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic, strong) WKWebView *webView;

+ (CGFloat)getDetailLabelHightWithStr:(NSString *) descriptionStr;
@end

NS_ASSUME_NONNULL_END
