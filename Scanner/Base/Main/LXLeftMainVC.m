//
//  LXLeftMainVC.m
//  Scanner
//
//  Created by rrdkf on 2020/6/24.
//  Copyright © 2020 rrdkf. All rights reserved.
//

#import "LXLeftMainVC.h"

@interface LXLeftMainVC ()
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttons;
@end

@implementation LXLeftMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBtns];
}

- (void)setupBtns{
    //062616
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *btns = @[@"我的",@"下单",@"3D扫描"];
    self.buttons = [[NSMutableArray alloc] initWithCapacity:btns.count];
    @weakify(self)
    [btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, KScreenHeight -100 - idx * (60 + 20), 60, 60)];
        [self.view addSubview:btn];
        [self.buttons addObject:btn];
        btn.tag = idx;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        btn.layer.borderColor = [UIColor redColor].CGColor;
//        btn.layer.borderWidth = 1.f;
        [btn addTarget:self action:@selector(onclickbutton:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    __block UIButton *selBtn = nil;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == idx) {
            selBtn = obj;
            * stop = YES;
        }
    }];
    
    if (selBtn == nil) return;
    
    [self onclickbutton:selBtn];
}

- (void)onclickbutton:(UIButton *)sender {
    if (self.selectedButton == sender) return;
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectedButton = sender;
    
    if ([self.vcDelegate respondsToSelector:@selector(didSelectIndex:)]) {
        [self.vcDelegate didSelectIndex:sender.tag];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
