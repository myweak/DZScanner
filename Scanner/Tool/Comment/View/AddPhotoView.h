//
//  AddPhotoView.h
//  Scanner
//
//  Created by edz on 2020/7/10.
//  Copyright © 2020 rrdkf. All rights reserved.
//
//

@class AddPhotoView;
typedef void (^ComplemntBlock)(id  photoView);

typedef void (^AddPhotoViewSelectedBlock)(NSInteger  index);

#import <UIKit/UIKit.h>

@protocol AddPhotoViewDelegate <NSObject>

- (void)addPhotoViewcomplemnt:(AddPhotoView * )addPhotoView;
- (void)addPhotoView:(AddPhotoView *)addView selectedImageViewIndex:(NSInteger)index;

@end
@interface AddPhotoView : UIView
@property (nonatomic, strong) MZAssetsManager *manger;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSArray *imageUrl; //URL 图片地址
@property (nonatomic, assign) CGFloat photoW;
@property (nonatomic, assign) BOOL isCanEdite; // 默认是可以添加图片的
@property (nonatomic, copy)   ComplemntBlock complemntBlock;
@property (nonatomic, copy)   ComplemntBlock onTapAddBtnBlock;
@property (nonatomic, copy)   ComplemntBlock deleteSourceBlock;
@property (nonatomic, copy)   AddPhotoViewSelectedBlock addPhotoViewSelectedBlock;

@property (nonatomic, assign) id <AddPhotoViewDelegate> delegate;

//更新UI
- (void)updateAddPhotoView;

@end


//--------------------------------------------------------------------------------------
