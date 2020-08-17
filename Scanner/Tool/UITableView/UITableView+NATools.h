//
//  UITableView+NATools.h
//  JingYuDaiJieKuan
//
//  Created by TianZe on 2019/10/29.
//  Copyright © 2019 Jincaishen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (NATools)
- (void)registerNibString:(NSString *)nibString
          cellIndentifier:(NSString *)cellIndentifier;
@end

NS_ASSUME_NONNULL_END
