//
//  创建tableViewHeaderView需注意.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/15.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

#ifndef __tableViewHeaderView____h
#define __tableViewHeaderView____h


tableView 的tableHeaderView 有两种创建方式一中是代码创建另外一种是用xib创建

用代码创建
UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
// 设置header
self.tableView.tableHeaderView = header;
因为 self.tableView.tableHeaderView的高度是没有办法设置的,所以必须设置自定义View的高度 来达到设置 self.tableView.tableHeaderView的高度


用xib创建
BBSTableHeaderView * cell = [BBSTableHeaderView tableHeaderView];
cell = 291;
self.tableView.tableHeaderView = header;
按理来说这样设置肯定是没有问题的 但是这时候你设置的高度是不准确的 而且是没有办法适配机型的
所以这样的设置方法不可行

- 解决方案

UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLS_ScreenWidth, kLS_relative_Height(195))];
headerView.backgroundColor = [UIColor whiteColor];
self.tabHeadView.backgroundColor = [UIColor clearColor];
[headerView addSubview:self.tabHeadView];
self.tableView.tableHeaderView = headerView;


原理 就是在xib View下面在加一层View (代码创建的) 这样才能保证你设置的高度是准确的 因为Xib高度 准确 必须再加一层代码创建的view才能保证你的View的高度是准确的 而且是适配各种机型的



#endif /* __tableViewHeaderView____h */
