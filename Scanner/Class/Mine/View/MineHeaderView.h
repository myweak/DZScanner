//
//  MineHeaderView.h
//  Scanner
//
//  Created by edz on 2020/7/13.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "TZXibNibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderView : TZXibNibView
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
