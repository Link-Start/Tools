//
//  LSRootCollectionView.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/2/1.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "LSRootCollectionView.h"

@interface LSRootCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *ls_collectionView;

@end

@implementation LSRootCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 刷新
- (void)headerRereshing {
    
}

- (void)footerRereshing {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UICollectionView *)ls_collectionView {
    if (!_ls_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置分区的EdgeInset 偏移量
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);
//        //设置headerView的尺寸大小
//        flowLayout.headerReferenceSize = CGSizeMake(self.alertView.width, 100);
        
        //通过一个布局策略layout来创建一个collectionView
        _ls_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kLS_ScreenWidth , kLS_ScreenHeight - kLS_TopHeight - kLS_TabBarHeight) collectionViewLayout:flowLayout];
        //设置代理
//        _ls_collectionView.delegate = self;
//        _ls_collectionView.dataSource = self;
        //设置Cell多选
        _ls_collectionView.allowsMultipleSelection = YES;
        //设置collection的背景色
        _ls_collectionView.backgroundColor = [UIColor whiteColor];
        _ls_collectionView.scrollsToTop = YES;
        
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _ls_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        if(kDevice_Is_iPhoneX && CGRectGetHeight(self.view.frame) == kLS_ScreenHeight - kLS_TopHeight){
            _ls_collectionView.contentInset = UIEdgeInsetsMake(0, 0, kLS_iPhoneX_Home_Indicator_Height, 0);
            _ls_collectionView.scrollIndicatorInsets = _ls_collectionView.contentInset;
        }
#endif
        
        //        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        //        header.automaticallyChangeAlpha = YES;
        //        header.lastUpdatedTimeLabel.hidden = YES;
        //        header.stateLabel.hidden = YES;
        //        _ls_collectionView.mj_header = header;
        
        //底部刷新
        //        _ls_collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

        [self.view addSubview:_ls_collectionView];
    }
    return _ls_collectionView;
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
