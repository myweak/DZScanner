//
//  GetCodeButton.h
//  Scanner
//
//  Created by edz on 2020/7/6.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,GetCodeButtonType){
    GetCodeButtonType_one  = 1,  //
    GetCodeButtonType_two ,
};

@interface GetCodeButton : UIButton
@property (nonatomic, assign) GetCodeButtonType abGetCodeButtonType;

@property (nonatomic, assign) BOOL isCounting;
@property (nonatomic, strong) void(^completionBlock)(void);
@property (nonatomic, strong) UIColor *buttonEnableColor;
@property (nonatomic, strong) UIColor *buttonDisableColor;
@property (nonatomic, strong) UIColor *enableTitleColor;
@property (nonatomic, strong) UIColor *disableTitleColor;
@property (nonatomic, copy) NSString *timeTipsStr;
@property (nonatomic, assign) NSInteger customType;

@property (nonatomic, assign) CGFloat countTime; //倒计时总时间。默认60s

- (void)counting;

- (void)reset;

- (void)stopCounting;

- (void)getSubmitCodeWithAction:(void(^)(void))block completeCounting:(void(^)(void))completion;

- (void)updateColors;
@end

NS_ASSUME_NONNULL_END
