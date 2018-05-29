//
//  LSRootTableView.m
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/22.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

#import "LSRootTableView.h"
#import "UIImage+Extension.h"
@interface LSRootTableView ()

@property (nonatomic, strong) UITableView *ls_tableView;

@end

@implementation LSRootTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏下1px线的颜色 -- 测试可用
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageCreateImageWithColor:UIColorFromRGB(0xe8e8e8) size:CGSizeMake(kLS_ScreenWidth, 0.5)]];
    
    if (@available(iOS 11.0, *)) {
        self.ls_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

//    //判断当前控制器是否在显示 isViewLoaded 表示已经视图被加载过 view.window表示视图正在显示
//    if (self.isViewLoaded && self.view.window) {
//    }
}

#pragma mark - 刷新
- (void)headerRereshing {
    
}

- (void)footerRereshing {
    
}



- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UITableView *)ls_tableView {
    if (!_ls_tableView) {
        _ls_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLS_ScreenWidth, kLS_ScreenHeight - kLS_TopHeight - kLS_TabBarHeight-kLS_iPhoneX_Home_Indicator_Height) style:UITableViewStylePlain];
        
        [self setupTableViewSeparatorsLine];
        //iOS8引入Self-Sizing 之后，我们可以通过实现estimatedRowHeight相关的属性来展示动态的内容
        //Self-Sizing在iOS11下是默认开启的
        //iOS11下不想使用Self-Sizing的话，可以通过以下方式关闭
        _ls_tableView.estimatedRowHeight = 0;
        _ls_tableView.estimatedSectionHeaderHeight = 0;
        _ls_tableView.estimatedSectionFooterHeight = 0;
        _ls_tableView.rowHeight = UITableViewAutomaticDimension;//自动计算行高
        
        _ls_tableView.showsVerticalScrollIndicator = NO;
        _ls_tableView.showsHorizontalScrollIndicator = NO;
        _ls_tableView.backgroundColor = [UIColor colorFromHexString:@"#F0F1F5"];
        _ls_tableView.scrollsToTop = YES;
        _ls_tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLS_ScreenWidth, CGFLOAT_MIN)];
        _ls_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLS_ScreenWidth, CGFLOAT_MIN)];
        
//        _ls_tableView.dataSource = self;
//        _ls_tableView.delegate = self;
        
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            self.ls_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        if(kDevice_Is_iPhoneX && CGRectGetHeight(self.view.frame) == kLS_ScreenHeight - kLS_TopHeight){
            self.ls_tableView.contentInset = UIEdgeInsetsMake(0, 0, kLS_iPhoneX_Home_Indicator_Height, 0);
            self.ls_tableView.scrollIndicatorInsets = self.ls_tableView.contentInset;
        }
#endif
        
        //头部刷新
        //        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        //        header.automaticallyChangeAlpha = YES;
        //        header.lastUpdatedTimeLabel.hidden = YES;
        //        _ls_tableView = header;
        
        //底部刷新
        //        _ls_tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        //        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        
        [self.view addSubview:_ls_tableView];
    }
    return _ls_tableView;
}

///设置tableView的分割线
- (void)setupTableViewSeparatorsLine {
    _ls_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.ls_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.ls_tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
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
