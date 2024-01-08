//
//  UIScrollView+ConfigRefresh.m
//  
//
//  Created by LKCZ on 2019/5/13.
//

#import "UIScrollView+ConfigRefresh.h"
#import "YYKit.h"

static NSArray *_animations;

@implementation UIScrollView (ConfigRefresh)


+ (void)initialize {
    if (!_animations) {
        NSMutableArray *animations = [NSMutableArray array];
//        for (int i = 0; i<12; i++) {
//            [animations addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_head_animation%02d",i]]];
//        }
        _animations = animations;
    }
}


/// 开始刷新
- (void)beginRefreshing {
     [self.mj_header beginRefreshing];
}

/// 配置 下拉刷新、上拉加载更多
- (void)configRefreshHeaderAndFooterWithBeginRefresh:(void(^)(void))beginRefreshBlock {
    self.beginLoadBlock = beginRefreshBlock;
    self.currentPage = 1;
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    [gifHeader setImages:_animations forState:MJRefreshStateRefreshing];
    [gifHeader setImages:_animations forState:MJRefreshStatePulling];
    [gifHeader setImages:_animations forState:MJRefreshStateIdle];
    [gifHeader setImages:_animations forState:MJRefreshStateWillRefresh];
    [gifFooter setImages:_animations forState:MJRefreshStateRefreshing];
//    gifHeader.stateLabel.textColor = ThemeColor;
    [gifFooter setImages:_animations forState:MJRefreshStatePulling];
    [gifFooter setImages:_animations forState:MJRefreshStateIdle];
    [gifFooter setImages:_animations forState:MJRefreshStateWillRefresh];
    self.mj_header = gifHeader;
    self.mj_footer = gifFooter;
    [self configCompleteBlock];
}

/// 配置 下拉刷新数据
- (void)configRefreshHeaderRefresh:(void(^)(UIScrollView *scrollView))beginRefreshBlock {
    @weakify(self);
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.isRefreshing) {
            return;
        }
        self.currentPage = 1;
        self.isRefreshing = YES;
        if (beginRefreshBlock) {
            beginRefreshBlock(self);
        }
    }];
    self.currentPage = 1;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    [gifHeader setImages:_animations forState:MJRefreshStateRefreshing];
    [gifHeader setImages:_animations forState:MJRefreshStatePulling];
    [gifHeader setImages:_animations forState:MJRefreshStateIdle];
    [gifHeader setImages:_animations forState:MJRefreshStateWillRefresh];
//    gifHeader.stateLabel.textColor = ThemeColor;
    self.mj_header = gifHeader;
    [self configCompleteBlock];
}

/// 配置 上拉加载更多数据
- (void)configRefreshFooterRefresh:(void(^)(UIScrollView *scrollView))loadMoreBlock {
    @weakify(self);
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
         @strongify(self);
           if (self.isRefreshing) {
             return;
           }
           self.currentPage++;
           self.isRefreshing = YES;
           if (loadMoreBlock) {
               loadMoreBlock(self);
           }
    }];
    self.currentPage = 1;
    [gifFooter setImages:_animations forState:MJRefreshStateRefreshing];
    [gifFooter setImages:_animations forState:MJRefreshStatePulling];
    [gifFooter setImages:_animations forState:MJRefreshStateIdle];
    [gifFooter setImages:_animations forState:MJRefreshStateWillRefresh];
    self.mj_footer = gifFooter;
    [self configCompleteBlock];
}

/// 配置 上拉加载更多数据，
/// 默认底部控件100%出现时才会自动刷新，
/// 这里设置0.5，代表底部控件出现一半就会自动加载数据
- (void)configAutoRefreshFooterRefresh:(void(^)(UIScrollView *scrollView))loadMoreBlock {
    [self configAutoRefreshFooterRefresh:0.5 loadMoreBlock:loadMoreBlock];
}
/// 配置 上拉加载更多数据，
/// triggerAutomaticallyRefreshPercent：默认底部控件100%出现时才会自动刷新
- (void)configAutoRefreshFooterRefresh:(CGFloat)triggerAutomaticallyRefreshPercent loadMoreBlock:(void(^)(UIScrollView *scrollView))loadMoreBlock {
    @weakify(self);
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
         @strongify(self);
           if (self.isRefreshing) {
             return;
           }
           self.currentPage++;
           self.isRefreshing = YES;
           if (loadMoreBlock) {
               loadMoreBlock(self);
           }
    }];
    self.currentPage = 1;
    [gifFooter setImages:_animations forState:MJRefreshStateRefreshing];
    [gifFooter setImages:_animations forState:MJRefreshStatePulling];
    [gifFooter setImages:_animations forState:MJRefreshStateIdle];
    [gifFooter setImages:_animations forState:MJRefreshStateWillRefresh];
    gifFooter.triggerAutomaticallyRefreshPercent = triggerAutomaticallyRefreshPercent;// 默认底部控件100%出现时才会自动刷新
    self.mj_footer = gifFooter;
    [self configCompleteBlock];
}


// 下拉刷新，加载数据
- (void)loadData {
    if (self.isRefreshing) {
        return;
    }
    self.currentPage = 1;
    self.isRefreshing = YES;
    if (self.beginLoadBlock) {
        self.beginLoadBlock();
    }
}

/// 上拉加载更多数据
- (void)loadMoreData {
    if (self.isRefreshing) {
        return;
    }
    self.currentPage++;
    self.isRefreshing = YES;
    if (self.beginLoadBlock) {
        self.beginLoadBlock();
    }
}

/// 根据block 带回的，每一次请求回来的数据的 count 判断是否可以继续进行上拉加载更多数据
- (void)configCompleteBlock {
    @weakify(self);
    self.completeBlock = ^(NSInteger itemsCount) {
        @strongify(self);
        self.isRefreshing = NO;
        if (self.currentPage == 1) {
            [self.mj_header endRefreshing];
            [self.mj_footer resetNoMoreData];
            if (itemsCount < loadDataPageSize) {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            self.mj_footer.hidden = !itemsCount;
            return;
        }
        [self.mj_footer endRefreshing];
        if (itemsCount < loadDataPageSize) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    };
}









#pragma mark - setter/getter 方法
#pragma mark - 添加属性
- (void)setIsRefreshing:(BOOL)isRefreshing {
     objc_setAssociatedObject(self, @selector(isRefreshing), @(isRefreshing), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isRefreshing {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCurrentPage:(NSInteger)currentPage {
     objc_setAssociatedObject(self, @selector(currentPage), @(currentPage),OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)currentPage {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setCompleteBlock:(loadComplete)completeBlock{
     objc_setAssociatedObject(self, @selector(completeBlock), completeBlock,OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (loadComplete)completeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBeginLoadBlock:(beignLoadData)beginLoadBlock{
     objc_setAssociatedObject(self, @selector(beginLoadBlock), beginLoadBlock,OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (beignLoadData)beginLoadBlock{
     return objc_getAssociatedObject(self, _cmd);
}


@end
