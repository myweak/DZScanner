//
//  MineScanFieldCell.h
//  Scanner
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#define KMineScanFieldCell_ID  @"MineScanFieldCell_ID"
typedef void(^MineScanFieldCellBlock)(BOOL isEdite, BOOL isDelete) ;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineScanFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewss;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelss;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (nonatomic, copy)   MineScanFieldCellBlock mineScanFieldCellBlock;

@end

NS_ASSUME_NONNULL_END
