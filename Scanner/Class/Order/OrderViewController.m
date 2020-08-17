//
//  OrderViewController.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderCollectionViewCell.h"
#import "OrderVCModel.h"
#import "RrOrderMainItemsVC.h" // 商品树VC
#import "RrAgreementView.h"
#import "RrProductSearchVC.h"
@interface OrderViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation OrderViewController

- (void)dealloc {
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidenLeftTaBar = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制下单";
    [self.view addSubview:self.collectionView];
    [self getGoodsCategoryListWithIsRefreshing:NO];
    
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    
    @weakify(self)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self getGoodsCategoryListWithIsRefreshing:YES];
    }];
    
    [self addNavigationButtonImageRight:@"navi_search_icon" RightActionBlock:^{
        @strongify(self);
        RrProductSearchVC *searVc =[RrProductSearchVC new];
        searVc.type = RrSearchVCType_product;
        [self.navigationController pushViewController:searVc animated:YES];
    }];
}
- (void)addBackButton{
}
#pragma mark - UICollectViewDatasource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderCollectionViewCell_ID forIndexPath:indexPath];
    NSInteger imageIndex = indexPath.row % 6; //六张背景图循环
    NSString *imageStr = [NSString stringWithFormat:@"%@%ld",@"order_mian_",(long)imageIndex];
    cell.imageView.image = R_ImageName(imageStr);
    OrderVCModel *model = self.dataArr[indexPath.row];
    cell.titleLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderVCModel *model = self.dataArr[indexPath.row];
    if (model.items.count == 0) {
        showMessage(@"该类型暂无商品");
        return;
    }
    RrOrderMainItemsVC *orderVc = [RrOrderMainItemsVC new];
    orderVc.model = model;
    orderVc.title = model.name;
    [self.navigationController pushViewController:orderVc animated:YES];
}



#pragma mark - <DZNEmptyDataSetSource>

// MARK: 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"placeholder_no_network"];
}

// MARK: 空白页添加按钮，设置按钮文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    // 设置按钮标题
    NSString *buttonTitle = @"网络不给力，请点击重试哦~";

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
    // 设置所有字体大小为 #15
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:15.0]
                             range:NSMakeRange(0, buttonTitle.length)];
    // 设置所有字体颜色为浅灰色
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor lightGrayColor]
                             range:NSMakeRange(0, buttonTitle.length)];
    // 设置指定4个字体为蓝色
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[@"#007EE5" getColor]
                             range:NSMakeRange(7, 4)];
    return attributedString;
    
}

// MARK: 空白页背景颜色
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [@"#f0f3f5" getColor];
}

// MARK: 设置空白页内容的垂直便宜量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70.0f;
}

#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // 处理空白页面按钮点击事件
    NSLog(@"处理空白页面按钮点击事件");
    [self getGoodsCategoryListWithIsRefreshing:nil];
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.collectionView.contentOffset = CGPointZero;
}



#pragma mark - Setter && Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self collcectViewLayout]];
        _collectionView.frame = CGRectMake(0, 0, KFrameWidth, KScreenHeight);
        _collectionView.backgroundColor = [UIColor mian_BgColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:OrderCollectionViewCell_ID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collcectViewLayout {
    UICollectionViewFlowLayout *collcectViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collcectViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //图片有17的边阴影
    CGFloat L_width = iPW(73-17);
    CGFloat R_width = iPW(84+17);
    CGFloat T_height = iPH(97-17);
    CGFloat space_xy = iPW(35-17);
    collcectViewLayout.minimumLineSpacing = space_xy; // 上下间距
//    collcectViewLayout.minimumInteritemSpacing = space_xy;//左右间距
    CGFloat width = (KFrameWidth - R_width-L_width - space_xy*2)/3.0f;
    CGFloat height =  width*126.5/138;
    collcectViewLayout.itemSize = CGSizeMake(width, height);
    collcectViewLayout.sectionInset = UIEdgeInsetsMake(T_height,L_width, T_height, R_width);
    return collcectViewLayout;
}



#pragma mark - 网路 Url
- (void)getGoodsCategoryListWithIsRefreshing:(BOOL) isRefreshing{
    if(!isRefreshing){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    }
    [[RRNetWorkingManager sharedSessionManager] getGoodsCategory:@{KisAddEGOCache_Key:KisAddEGOCache_value} result:ResultBlockMake(^(NSDictionary * _Nonnull dict, RrResponseModel * _Nonnull responseModel, NSError * _Nonnull error) {
        if (!error) {
            self.dataArr = responseModel.list;
            [self.collectionView reloadData];
        }
        [ self.collectionView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    }, [OrderVCModel class])];
}



@end
