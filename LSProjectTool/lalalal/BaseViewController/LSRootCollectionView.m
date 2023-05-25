//
//  LSRootCollectionView.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/2/1.
//  Copyright © 2018年 Link-Start. All rights reserved.
//
//
// zIndex这个属性调整collectionview中的层级关系，cell是0，要想装饰视图在cell底部，就要把装饰视图的zindex调整到小于0
// zIndex 这个属性可以在自定义卡片的时候 让中间的cell处于视图的最前面

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

#pragma mark - 通过遵守UICollectionViewDelegateFlowLayout实现代理方法来布局（非固定情况则需要通过数据源方法）
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;


#pragma mark - 数据源方法
////设置分区数（必须实现）
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
////设置每个分区的item个数
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 5;
//}
////设置返回每个item的属性必须实现）
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
////    // 去掉 刷新collection的时候的隐式动画
////    [UIView animateWithDuration:0 animations:^{
////        [UIView performWithoutAnimation:^{
////            [self.collectionView reloadData];
////        }];
////    } completion:^(BOOL finished) {
////
////    }];
////    // 去掉 刷新collection的 row 的时候的隐式动画
////    [UIView animateWithDuration:0 animations:^{
////        [collectionView performBatchUpdates:^{
////            [self.cardCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:0]]];
////        } completion:^(BOOL finished) {
////        }];
////    }];
//
//
//}
////对头视图或者尾视图进行设置
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//MemberInfoDetailsBottomConsumerDetailsHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMemberInfoDetailsBottomConsumerDetailsHeadViewId forIndexPath:indexPath];
//}
//是否允许移动Item
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0){
    return YES;
}
//移动Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0); {
}
//是否允许某个Item的高亮，返回NO，则不能进入高亮状态
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}
//当item高亮时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//结束高亮状态时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//是否可以选中某个Item，返回NO，则不能选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}
//是否可以取消选中某个Item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}
//已经选中某个item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//取消选中某个Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//将要加载某个Item时调用的方法
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0); {
}
//将要加载头尾视图时调用的方法
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0); {
}
//已经展示某个Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath; {
}
//已经展示某个头尾视图时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath; {
}
//这个方法设置是否展示长按菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}

//这个方法用于设置要展示的菜单选项
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender; {
    return YES;
}

//这个方法用于实现点击菜单按钮后的触发方法,通过测试，只有copy，cut和paste三个方法可以使用
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender; {
    //通过下面的方式可以将点击按钮的方法名打印出来：
    NSLog(@"%@",NSStringFromSelector(action));
}

//collectionView进行重新布局时调用的方法
//- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout; {
//
//}

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

        
//        // 1.设置列间距
//        layout.minimumInteritemSpacing = 1;
//        // 2.设置行间距
//        layout.minimumLineSpacing = 1;
//        // 3.设置每个item的大小
//        layout.itemSize = CGSizeMake(50, 50);
//        // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
//        layout.estimatedItemSize = CGSizeMake(320, 60);
//        // 5.设置布局方向
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        // 6.设置头视图尺寸大小
//        layout.headerReferenceSize = CGSizeMake(50, 50);
//        // 7.设置尾视图尺寸大小
//        layout.footerReferenceSize = CGSizeMake(50, 50);
//        // 8.设置分区(组)的EdgeInset（四边距）
//        layout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);
//        // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
//        layout.sectionFootersPinToVisibleBounds = YES;
//        layout.sectionHeadersPinToVisibleBounds = YES;

        
        
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
