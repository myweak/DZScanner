//
//  JassonSTLView.h
//  Scanner
//
//  Created by zyq on 2018/10/24.
//  Copyright © 2018年 rrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JassonSTLView : SCNView
- (instancetype)initWithSTLPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
