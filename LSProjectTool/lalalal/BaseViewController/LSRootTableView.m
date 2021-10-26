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
    
    
    //判断某一个分区的cell是否已经显示
//    CGRect cellRect = [self.tableView rectForSection:4];
//    BOOL completelyVisible = CGRectContainsRect(self.tableView.bounds, cellRect);
    
    
    
//    ///获取某个cell中的字控件 在tableView中的位置
//    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
//    /// 获取当前cell 相对于self.view 当前的坐标
//    rect.origin.y          = rect.origin.y - [tableView contentOffset].y;
//    CGRect imageViewRect   = imageView.frame;
//    imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y + imageView.frame.size.height/2;
}

#pragma mark - 刷新
- (void)headerRereshing {
    
}

- (void)footerRereshing {
    
}


#pragma mark - 数据
#pragma mark - 上拉加载、下拉刷新
//上拉加载 下拉刷新
///开始刷新
//- (void)setupRefresh {
//
//    __weak __typeof(self)weakSelf = self;
//    //下拉刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        strongSelf.currentPage = 1;
//
//    }];
//    //开始刷新
//    //    [self.c_tableView.mj_header  beginRefreshing];
//
//    //    //上拉加载
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        strongSelf.currentPage++;
//
//    }];
//    self.tableView.mj_footer.hidden = YES;
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
//    self.tableView.mj_footer.automaticallyHidden = YES;
//}
//
//- (void)endRefreshing {
//    if (self.tableView.mj_header.isRefreshing) {
//        [self.tableView.mj_header endRefreshing];
//    }
//    if (self.tableView.mj_footer.isRefreshing) {
//        [self.tableView.mj_footer endRefreshing];
//    }
//}

#pragma mark - 代理方法
#pragma mark - group 类型下 head和foot 会有空白
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc] init];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [[UIView alloc] init];
//}


#pragma mark - cell左滑删除
//
////1.首先设置cell可以编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
////2.设置编辑的样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
////3.修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"取消收藏";
//}
////4.设置进入编辑状态的时候，cell不会缩进
//- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
////5.点击删除的实现。特别提醒：必须要先删除了数据，才能再执行删除的动画或者其他操作，不然会引起崩溃。
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    __weak __typeof(self)weakSelf = self;
//    UIAlertController *alerCon = [UIAlertController alertControllerWithTitle:@"确定取消此收藏？" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alerCon addAction:cancelAction];
//    [alerCon addAction:sureAction];
//    [self presentViewController:alerCon animated:YES completion:nil];
//}

#pragma mark - tableview整个Section切圆角 方法一
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 圆角角度
//    CGFloat radius = 4.f;
//    // 设置cell 背景色为透明
//    cell.backgroundColor = UIColor.clearColor;
//    cell.contentView.backgroundColor = UIColor.clearColor;
//    // 创建两个layer
//    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
//    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
//    // 获取显示区域大小
//    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
//    // cell的backgroundView
//    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
//    // 获取每组行数
//    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
//    // 贝塞尔曲线
//    UIBezierPath *bezierPath = nil;
//
//    if (rowNum == 1) {
//        // 一组只有一行（四个角全部为圆角）
//        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
//        normalBgView.clipsToBounds = NO;
//    }else {
//        normalBgView.clipsToBounds = YES;
//        if (indexPath.row == 0) {
//            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(-5, 0, 0, 0));
//            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(5, 0, 0, 0));
//            // 每组第一行（添加左上和右上的圆角）
//            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
//        }else if (indexPath.row == rowNum - 1) {
//            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, -5, 0));
//            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
//            // 每组最后一行（添加左下和右下的圆角）
//            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
//        }else {
//            // 每组不是首位的行不设置圆角
//            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
//        }
//    }
//
//    // 阴影
//    normalLayer.shadowColor = [UIColor blackColor].CGColor;
//    normalLayer.shadowOpacity = 0.2;
//    normalLayer.shadowOffset = CGSizeMake(0, 0);
//    normalLayer.path = bezierPath.CGPath;
//    normalLayer.shadowPath = bezierPath.CGPath;
//
//    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
//    normalLayer.path = bezierPath.CGPath;
//    selectLayer.path = bezierPath.CGPath;
//
//    // 设置填充颜色
//    normalLayer.fillColor = [UIColor whiteColor].CGColor;
//    // 添加图层到nomarBgView中
//    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
//    normalBgView.backgroundColor = UIColor.clearColor;
//    cell.backgroundView = normalBgView;
//
//    // 替换cell点击效果
//    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
//    selectLayer.fillColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
//    [selectBgView.layer insertSublayer:selectLayer atIndex:0];
//    selectBgView.backgroundColor = UIColor.clearColor;
//    cell.selectedBackgroundView = selectBgView;
//}

#pragma mark - tableview整个Section切圆角 方法二
//UITableView分区且包含区头，设置圆角
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat cornerRadius =10.0;
//    CGRect bounds = cell.bounds;
//
//    // 每区行数
//    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
//    // 区头
//    UIView *view = [self tableView:tableView viewForHeaderInSection:indexPath.section];
//
//    //绘制曲线
//    UIBezierPath *bezierPath = nil;
//
//    if (indexPath.row == 0 && numberOfRows == 1) {
//        // 一个区只有一行cell
//        if (view != nil) {
//            // 有区头：左下，右下为圆角
//            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//        }else{
//            //四个角都为圆角
//            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//        }
//    } else if (indexPath.row == 0) {
//        // 某个区的第一行
//        if (view != nil) {
//            // 有区头：为矩形
//            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
//        }else{
//            //左上、右上角为圆角
//            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//        }
//    } else if (indexPath.row == numberOfRows - 1) {
//        //某个区的最后一行：左下、右下角为圆角
//        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    } else {
//        //某个区的中间行：为矩形
//        bezierPath = [UIBezierPath bezierPathWithRect:bounds];
//    }
//
//   cell.backgroundColor = [UIColor clearColor];
//
//    //新建一个layer层,设置填充色和边框颜色
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = bezierPath.CGPath;
//    layer.fillColor = [UIColor whiteColor].CGColor;
//    layer.strokeColor = [UIColor whiteColor].CGColor;
//
//    //将layer层添加到cell.layer中,并插到最底层
//    [cell.layer insertSublayer:layer atIndex:0];
//}


#pragma mark - tableview整个Section切圆角 方法二
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self shearTableViewSection:cell tableView:tableView IndexPath:indexPath cornerRadius:4 width:0];
//}
//#pragma mark TableView Section 切圆角
//- (void)shearTableViewSection:(UITableViewCell *)cell tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)radius width:(CGFloat)width
//{
//    // 圆角弧度半径
//    CGFloat cornerRadius = 0.f;
//    if (radius == 0) {
//        cornerRadius = 10.f;
//    }else{
//        cornerRadius = radius;
//    }
//
//    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
//    cell.backgroundColor = UIColor.clearColor;
//    cell.contentView.backgroundColor = UIColor.clearColor;
//
//    // 创建一个shapeLayer
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
//    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    // 获取cell的size
//    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
//    CGRect bounds;
//    bounds = CGRectInset(cell.bounds, width, 0);
//
//    // CGRectGetMinY：返回对象顶点坐标
//    // CGRectGetMaxY：返回对象底点坐标
//    // CGRectGetMinX：返回对象左边缘坐标
//    // CGRectGetMaxX：返回对象右边缘坐标
//    // CGRectGetMidX: 返回对象中心点的X坐标
//    // CGRectGetMidY: 返回对象中心点的Y坐标
//
//    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
//
//    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//
//    if ([tableView numberOfRowsInSection:indexPath.section]-1 == 0) {
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//
//
//    }else if (indexPath.row == 0) {
//        // 初始起点为cell的左下角坐标
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//
//    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//
//        // 初始起点为cell的左上角坐标
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//    } else {
//
//        // 添加cell的rectangle信息到path中（不包括圆角）
//        CGPathAddRect(pathRef, nil, bounds);
//    }
//    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
//    layer.path = pathRef;
//    backgroundLayer.path = pathRef;
//    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
//    CFRelease(pathRef);
//    // 按照shape layer的path填充颜色，类似于渲染render
//    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
//    layer.fillColor = [UIColor whiteColor].CGColor;
//
//
//    // view大小与cell一致
//    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
//    // 添加自定义圆角后的图层到roundView中
//    [roundView.layer insertSublayer:layer atIndex:0];
//    roundView.backgroundColor = UIColor.clearColor;
//    // cell的背景view
//    cell.backgroundView = roundView;
//}


#pragma mark - 按钮


#pragma mark - 添加子控件

#pragma mark - 懒加载


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
        if (@available(iOS 11.0, *)) {
            _ls_tableView.estimatedRowHeight = 0;
            _ls_tableView.estimatedSectionHeaderHeight = 0;
            _ls_tableView.estimatedSectionFooterHeight = 0;
            _ls_tableView.rowHeight = UITableViewAutomaticDimension;//自动计算行高
        }
        
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
//从 iOS 15 开始，TableView 增加sectionHeaderTopPadding属性，
//默认情况sectionHeaderTopPadding会有22个像素的高度，及默认情况，TableView section header增加22像素的高度
//        if (@available(iOS 15.0, *)) {
//            self.ls_tableView.sectionHeaderTopPadding = 0
//        }
        
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
    //UITableViewCellSeparatorStyleNone:不显示细线
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
