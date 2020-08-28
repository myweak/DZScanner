//
//  AddPhotoView.m
//  Scanner
//
//  Created by edz on 2020/7/10.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "AddPhotoView.h"
#import "MZPostImageView.h"


@interface AddPhotoView ()
@property (nonatomic, strong) NSMutableArray *photoImageArray; // 总数据
@property (nonatomic, strong) NSMutableArray *imageUrlArr; // url 图片数据
@property (nonatomic, strong) NSMutableArray *imageAssetArr; // 相册 asset 图片数据
@property (nonatomic, strong) NSMutableArray *viewMutabArr;

@end

@implementation AddPhotoView
@synthesize photoW = _photoW, maxPhotoNum = _maxPhotoNum;
- (void)awakeFromNib{
//    _isCanEdite = NO;
    [super awakeFromNib];
//    self.manger = [MZAssetsManager shareManager];
    self.photoImageArray = [NSMutableArray array];
    [self createUI];
}

- (MZAssetsManager *)manger{
    if (!_manger) {
        _manger = [[MZAssetsManager alloc] init];
    }
    return _manger;
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _isCanEdite = NO;
//        _manger = [MZAssetsManager shareManager];
        _photoImageArray = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

- (NSMutableArray *)viewMutabArr{
    if (!_viewMutabArr) {
        _viewMutabArr = [NSMutableArray array];
    }
    return _viewMutabArr;
}
- (void)setMaxPhotoNum:(NSInteger)maxPhotoNum{
    self.manger.maxPhotoNum = maxPhotoNum;
    _maxPhotoNum = maxPhotoNum;
}
- (NSInteger)maxPhotoNum{
    if (_maxPhotoNum == 0) {
        _maxPhotoNum = 9;
    }
    return _maxPhotoNum;
}
- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    @weakify(self)
    // 相册完成的回调
    self.manger.didFinishPickAssetsBlock = ^{
        @strongify(self)
        self.imageAssetArr = [NSMutableArray array];
        for (PHAsset *asset in self.manger.currentAssets) { // 保存图片 image
            [self.manger getImageWithAsserts:asset size:CGSizeMake(self.photoW, self.photoW) completion:^(UIImage *image, NSData *imageData) {
                @strongify(self);
                [self.imageAssetArr addObject:image];
            }];
        }
        self.photoImageArray = [NSMutableArray arrayWithArray:self.imageUrlArr];
        [self.photoImageArray addObjectsFromArray:self.imageAssetArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self updateAddPhotoView];
        });
    };
    [self addSubview:self.addBtn];

}


#pragma mark - Set Get 方法

- (void)setImageUrl:(NSArray *)imageUrl{// 外部imageUrl
    _imageUrlArr = [NSMutableArray arrayWithArray:imageUrl];
    _photoImageArray = [NSMutableArray arrayWithArray:imageUrl];
//    self.manger.maxPhotoNum = self.maxPhotoNum - imageUrl.count;
//    [self updateAddPhotoView];
  
}
- (NSArray *)imageUrl{
    return _imageUrlArr;
}

- (void)setPhotoW:(CGFloat)photoW{
    if (photoW == _photoW) {
        return;
    }
    _photoW = photoW;
    self.addBtn.width  = photoW ;
    self.addBtn.height = photoW ;
    self.height = photoW+15;
    !self.complemntBlock ?:self.complemntBlock(self);
}
- (CGFloat)photoW{
    if (_photoW == 0) {
        return iPH(85);
    }
    return _photoW;
}
- (void)setIsCanEdite:(BOOL)isCanEdite{
    _isCanEdite = isCanEdite;
    
    self.addBtn.hidden = !isCanEdite;
    [self.viewMutabArr enumerateObjectsUsingBlock:^(MZPostImageView  * objView, NSUInteger idx, BOOL * _Nonnull stop) {
        objView.deleteButton.hidden = !isCanEdite;
    }];
    

}

#pragma mark - 更新。UI
// 初始化 imageUrl 数据
- (void)oneUpdateAddPhotoViewWithImageUrl:(NSArray *)imageUrl{
    static BOOL b;
    if (imageUrl.count == 0 || b) {
        return;
    }
    @weakify(self)
    b = YES;
    [self setImageUrl:imageUrl];
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self updateAddPhotoView];
    });


}
- (void)updateAddPhotoView{
  
    CGFloat photo_W = self.photoW +15; // 图片大小
    CGFloat space_y = 0; // 间隔y
    CGFloat space_x = 0; // 间隔x
    NSInteger max_W = self.width;
    NSInteger d = (photo_W+space_y);
    NSInteger count_x = (max_W / d);
    
    if (self.isCanEdite) {
        self.addBtn.hidden  = self.photoImageArray.count >= self.maxPhotoNum;
    }else{
        self.addBtn.hidden  = YES;
    }
    
    @weakify(self)
    // 缓存View
    [self.viewMutabArr enumerateObjectsUsingBlock:^(MZPostImageView  * objView, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if (idx <self.photoImageArray.count) {
             objView.hidden = NO;
        }else{
            objView.hidden = YES;
        }
    }];
    
    self.manger.maxPhotoNum = self.maxPhotoNum - self.imageUrlArr.count;

    for (int i = 0; i<self.photoImageArray.count; i++) {
        NSInteger row = i%count_x;
        MZPostImageView *imageView;
        if ( i >= self.viewMutabArr.count) {
            imageView = [[MZPostImageView alloc] initWithFrame:CGRectMake( (photo_W+space_x)*row, i/count_x *(photo_W+space_y), photo_W, photo_W)];
            [self.viewMutabArr addObject:imageView];
            [self addSubview:imageView];

        }else{
            imageView =  self.viewMutabArr[i];
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i;
//        [self addSubview:imageView];
//        [imageView addDeleteButton];
        imageView.deleteButton.hidden = !self.isCanEdite;
                
        id asset = self.photoImageArray[i];
        if ([asset isKindOfClass:[NSString class]]) { // 字符类型
            if ([asset hasPrefix:@"http"]) {// url 字符
                NSString *imgStr = [NSString stringWithFormat:@"%@",asset];
                [imageView.imageView sd_setImageWithURL:imgStr.url placeholderImage:KPlaceholderImage_product];
            }//
        } if([asset isKindOfClass:[UIImage class]]) { // 相册返回的 asset
            imageView.imageView.image = asset;
        }
        
        //删除资源
        id  imageAsset = [self.photoImageArray objectAtIndex:i];
        [imageView setDeleteButtonActionBlock:^(UIImageView *imageView) { // 图片右上角 删除按钮事件
            @strongify(self)
            if (self.deleteSourceBlock) {
                self.deleteSourceBlock(imageView);
                return;
            }
            if ([imageAsset isKindOfClass:[NSString class]]) { // 字符类型
                if ([asset hasPrefix:@"http"]) {// 图片资源是 url 字符
                    if (i<self.imageUrlArr.count) {
                        [self.imageUrlArr removeObjectAtIndex:i];
                    }
                }
            }else if([imageAsset isKindOfClass:[UIImage class]]) { //   相册返回的 asset
                if (i<self.imageAssetArr.count+self.imageUrlArr.count) {
                    NSInteger assetIndex = i-self.imageUrlArr.count;
                    if (assetIndex>=0) {
                        [self.imageAssetArr removeObjectAtIndex:assetIndex];
                        [self.manger.currentAssets removeObjectAtIndex:assetIndex];
                    }
                }
            }
            
            if (i< self.photoImageArray.count) {
                [self.photoImageArray removeObjectAtIndex:i];
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    [self updateAddPhotoView];
                });
            }else{
                assert(@"i");
            }
            
        }];
        
        // 图片点击
        [imageView handleTap:^(CGPoint loc, UIGestureRecognizer *tapGesture) {
            @strongify(self)
            
            if ([self.delegate respondsToSelector:@selector(addPhotoView:selectedImageViewIndex:)]) {
                [self.delegate addPhotoView:self selectedImageViewIndex:imageView.tag];
                return;
            }
            if (self.addPhotoViewSelectedBlock) {
                self.addPhotoViewSelectedBlock(imageView.tag);
                return;
            }
            [self selectedImageView:imageView Index:imageView.tag];
        }];
        
        

    }
    self.addBtn.width =  self.photoW;
    self.addBtn.height =  self.photoW;
    
    
    CGFloat height_Y = (self.photoImageArray.count)/count_x *(photo_W+space_y);
    self.addBtn.top =  height_Y+15;
    self.addBtn.left = (photo_W+space_y)*(self.photoImageArray.count%count_x);
    self.height = self.addBtn.hidden ?  height_Y + photo_W :self.addBtn.bottom;
    
    !self.complemntBlock ?:self.complemntBlock(self);
    if ([self.delegate respondsToSelector:@selector(addPhotoViewcomplemnt:)]) {
        [self.delegate addPhotoViewcomplemnt:self];
    }
}




// 添加相片框
- (UIButton *)addBtn{
    if (!_addBtn) {
        // 添加相片框
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame =CGRectMake(0, 15, iPH(85),iPH(85));
        [_addBtn setBackgroundImage:R_ImageName(@"add_image") forState:UIControlStateNormal];
        _addBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [_addBtn addTarget:self action:@selector(tapAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

#pragma mark -- UIButton action
// 添加相片框
- (void)tapAddButtonAction:(UIButton *) btn{
    if (self.onTapAddBtnBlock) {
        self.onTapAddBtnBlock(self);
        return;
    }
    @weakify(self)
    [[[MZActionSheetView alloc]initWithActionSheetWithTitle:nil ListArray:@[@"从相册中选择图片",@"使用照相机"] completeSelctBlock:^(NSInteger selectIndex) {
        @strongify(self)
        if (selectIndex == 0) {
            // 手机相册
            [self.manger pickAssetsFromAblum];
            
        }
        if (selectIndex == 1) {
            // 手机相机
            [self.manger pickImageFromCamera];
        }
    }] show] ;
}



#pragma mark - override

- (void)selectedImageView:(UIImageView *)imageView Index:(NSInteger)index {
    
    @weakify(self)
    NSMutableArray *datas = [NSMutableArray array];
    [self.photoImageArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if ([obj isKindOfClass:[UIImage class]]) {
            // 相册图片
            NSInteger assetIndex = idx-self.imageUrlArr.count;
            YBIBImageData *data = [YBIBImageData new];
            data.imagePHAsset = self.manger.currentAssets[assetIndex];
            data.projectiveView = imageView;
            [datas addObject:data];
            return;
        }
        if ([obj hasSuffix:@".mp4"] && [obj hasPrefix:@"http"]) {
            
            // 网络视频
            YBIBVideoData *data = [YBIBVideoData new];
            data.videoURL = [NSURL URLWithString:obj];
            data.projectiveView = imageView;
            [datas addObject:data];
         
        } else if ([obj hasSuffix:@".mp4"]) {
            
            // 本地视频
            NSString *path = [[NSBundle mainBundle] pathForResource:obj.stringByDeletingPathExtension ofType:obj.pathExtension];
            YBIBVideoData *data = [YBIBVideoData new];
            data.videoURL = [NSURL fileURLWithPath:path];
            data.projectiveView = imageView;
            [datas addObject:data];
            
        } else
            if ([obj hasPrefix:@"http"]) {
            
            // 网络图片
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj];
            data.projectiveView = imageView;
            [datas addObject:data];
            
        } else {
            
            // 本地图片
            YBIBImageData *data = [YBIBImageData new];
            data.imageName = obj;
            data.projectiveView = imageView;
            [datas addObject:data];
            
        }
    }];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}


@end



