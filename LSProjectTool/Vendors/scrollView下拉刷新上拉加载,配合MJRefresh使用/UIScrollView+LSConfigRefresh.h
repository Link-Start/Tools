//
//  UIScrollView+LSConfigRefresh.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/10/11.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#define loadDataPageSize 10

/// 参数是返回的数据数量，如果返回的数据小于 loadDataPageSize , 就判定为没有更多数据了
typedef void(^loadComplete)(NSInteger itemsCount);

typedef void(^beignLoadData)(void);



NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (LSConfigRefresh)

/// 是否正在刷新
@property (nonatomic, assign) BOOL isRefreshing;
/// 当前页数
@property (nonatomic, assign) NSInteger currentPage;

/// 接口返回数据，用这个block 把返回的数据 count 带回来，内部判断是否能继续刷新
/// 带回数据时记得使用 if (self.completeBlock) {} 判断是否有这个block
@property (nonatomic, copy) loadComplete completeBlock;

/// 开始 调用接口，刷新/加载更多数据 的 block
@property (nonatomic, copy) beignLoadData beginLoadBlock;


/// 开始刷新
- (void)beginRefreshing;

/// 下拉刷新、上拉加载
- (void)configRefreshHeaderAndFooterWithBeginRefresh:(void(^)(void))beginRefreshBlock;
/// 下拉刷新
- (void)configRefreshHeaderRefresh:(void(^)(UIScrollView *scrollView))beginRefreshBlock;
/// 上拉加载
- (void)configRefreshFooterRefresh:(void(^)(UIScrollView *scrollView))loadMoreBlock;
/// 配置 上拉加载更多数据，默认底部控件100%出现时才会自动刷新，这里设置0.5，代表底部控件出现一半就会自动加载数据
- (void)configAutoRefreshFooterRefresh:(void(^)(UIScrollView *scrollView))loadMoreBlock;
/// 配置 上拉加载更多数据，
/// triggerAutomaticallyRefreshPercent：默认底部控件100%出现时才会自动刷新
- (void)configAutoRefreshFooterRefresh:(CGFloat)triggerAutomaticallyRefreshPercent loadMoreBlock:(void(^)(UIScrollView *scrollView))loadMoreBlock;

@end

NS_ASSUME_NONNULL_END
