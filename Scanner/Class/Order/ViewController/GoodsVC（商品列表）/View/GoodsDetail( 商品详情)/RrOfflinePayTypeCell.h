//
//  RrOfflinePayTypeCell.h
//  Scanner
//
//  Created by edz on 2020/7/23.
//  Copyright © 2020 rrdkf. All rights reserved.
//
#define KRrOfflinePayTypeCell_ID @"RrOfflinePayTypeCell_ID"

#import <UIKit/UIKit.h>
#import "AddPhotoView.h"
#import "RrDidProductDeTailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RrOfflinePayTypeCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contenViewBg;
//@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextView *priceTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addPhotoView_H;
@property (weak, nonatomic) IBOutlet AddPhotoView *addPhotoView;

@property (nonatomic, strong) RrDidProductDeTailModel *postModel; //提交数据模型

@end

NS_ASSUME_NONNULL_END
