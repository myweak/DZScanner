//
//  UITableView+NATools.m
//  JingYuDaiJieKuan
//
//  Created by TianZe on 2019/10/29.
//  Copyright © 2019 Jincaishen. All rights reserved.
//

#import "UITableView+NATools.h"

@implementation UITableView (NATools)

- (void)registerNibString:(NSString *)nibString
          cellIndentifier:(NSString *)cellIndentifier {
    
    [self registerNib:[UINib nibWithNibName:nibString bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
}

@end
