//
//  OrderCollectionViewCell.h
//  Scanner
//
//  Created by rrdkf on 2020/6/28.
//  Copyright © 2020 rrdkf. All rights reserved.
//


#define OrderCollectionViewCell_ID  @"OrderCollectionViewCellid"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
