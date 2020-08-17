//
//  LXLeftMainVC.h
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MainVCDelegate;
@interface LXLeftMainVC : MainViewController
@property (nonatomic, weak) id <MainVCDelegate> vcDelegate;

@property (nonatomic, assign) NSInteger index;
@end


@protocol MainVCDelegate <NSObject>
- (void)didSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
