//
//  RrMineAddressCell.h
//  Scanner
//
//  Created by edz on 2020/7/15.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RrMineAddressMdoel.h"
NS_ASSUME_NONNULL_BEGIN

#define KRrMineAddressCell_ID   @"RrMineAddressCell_ID"

typedef void (^TapediteBtnAction)(void);

@interface RrMineAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *namePhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *definBtn;//默认  是隐藏
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabel_x;

@property (weak, nonatomic) IBOutlet UIButton *editeBtn;

@property (nonatomic, copy)   TapediteBtnAction tapediteBtnAction;
@property (nonatomic, strong) RrMineAddressMdoel *model;
@end

NS_ASSUME_NONNULL_END
