//
//  UITableView+LSTools.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/4.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (LSTools)

#pragma mark - 注册
/// Xib 注册tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerNibWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName;
/// Xib 注册tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerNibWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName headerFooterViewNameId:(NSString *)headerFooterViewNameId;

/// 纯代码 注册tableViewCellSectionHeaderView、tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerClassWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName;
/// 纯代码 注册tableViewCellSectionHeaderView、tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerClassWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName headerFooterViewNameId:(NSString *)headerFooterViewNameId;

/// Xib 注册tableViewCell
- (void)ls_tableViewCell_registerNibWithCellName:(__kindof UITableViewCell *)cellName;
/// Xib 注册tableViewCell
- (void)ls_tableViewCell_registerNibWithCellName:(__kindof UITableViewCell *)cellName cellId:(NSString *)cellId;

///纯代码注册 tableViewCell
- (void)ls_tableViewCell_registerClassWithCellName:(__kindof UITableViewCell *)cellName;
///纯代码注册 tableViewCell
- (void)ls_tableViewCell_registerClassWithCellName:(__kindof UITableViewCell *)cellName cellId:(NSString *)cellId;

#pragma mark - 从缓存池中获取
///从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (nullable __kindof UITableViewHeaderFooterView *)ls_tableViewCellSectionHeaderFooterView_getFromCachePoolWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)HeaderFooterViewName;
///从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (nullable __kindof UITableViewHeaderFooterView *)ls_tableViewCellSectionHeaderFooterView_getFromCachePoolWithHeaderFooterViewNameId:(NSString *)headerFooterViewNameId;

///从缓存池获取 tableViewCell
- (__kindof UITableViewCell *)ls_tableViewCell_getFromCachePoolWithCellName:(__kindof UITableViewCell *)cellName indexPath:(NSIndexPath *)indexPath;
///从缓存池获取 tableViewCell
- (__kindof UITableViewCell *)ls_tableViewCell_getFromCachePoolWithCellId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
