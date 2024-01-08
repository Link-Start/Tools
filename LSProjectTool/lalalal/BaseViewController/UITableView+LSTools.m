//
//  UITableView+LSTools.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/4.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import "UITableView+LSTools.h"

@implementation UITableView (LSTools)

#pragma mark - 注册
/// Xib 注册tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerNibWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([headerFooterViewName class]) bundle:nil] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerFooterViewName class])]];
}
/// Xib 注册tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerNibWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName headerFooterViewNameId:(NSString *)headerFooterViewNameId {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([headerFooterViewName class]) bundle:nil] forHeaderFooterViewReuseIdentifier:headerFooterViewNameId];
}

/// 纯代码 注册tableViewCellSectionHeaderView、tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerClassWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName {
    [self registerClass:[headerFooterViewName class] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerFooterViewName class])]];
}
/// 纯代码 注册tableViewCellSectionHeaderView、tableViewCellSectionFooterView
- (void)ls_tableViewCellSectionHeaderFooterView_registerClassWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)headerFooterViewName headerFooterViewNameId:(NSString *)headerFooterViewNameId {
    [self registerClass:[headerFooterViewName class] forHeaderFooterViewReuseIdentifier:headerFooterViewNameId];
}

/// Xib 注册tableViewCell
- (void)ls_tableViewCell_registerNibWithCellName:(__kindof UITableViewCell *)cellName {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])]];
}
/// Xib 注册tableViewCell
- (void)ls_tableViewCell_registerNibWithCellName:(__kindof UITableViewCell *)cellName cellId:(NSString *)cellId {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellReuseIdentifier:cellId];
}

///纯代码注册 tableViewCell
- (void)ls_tableViewCell_registerClassWithCellName:(__kindof UITableViewCell *)cellName {
    [self registerClass:[cellName class] forCellReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])]];
}
///纯代码注册 tableViewCell
- (void)ls_tableViewCell_registerClassWithCellName:(__kindof UITableViewCell *)cellName cellId:(NSString *)cellId {
    [self registerClass:[cellName class] forCellReuseIdentifier:cellId];
}

#pragma mark - 从缓存池中获取
///从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (nullable __kindof UITableViewHeaderFooterView *)ls_tableViewCellSectionHeaderFooterView_getFromCachePoolWithHeaderFooterViewName:(__kindof UITableViewHeaderFooterView *)HeaderFooterViewName {
   return [self dequeueReusableHeaderFooterViewWithIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([HeaderFooterViewName class])]];
}
///从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
- (nullable __kindof UITableViewHeaderFooterView *)ls_tableViewCellSectionHeaderFooterView_getFromCachePoolWithHeaderFooterViewNameId:(NSString *)headerFooterViewNameId {
   return [self dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewNameId];
}

///从缓存池获取 tableViewCell
- (__kindof UITableViewCell *)ls_tableViewCell_getFromCachePoolWithCellName:(__kindof UITableViewCell *)cellName indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])] forIndexPath:indexPath];
}
///从缓存池获取 tableViewCell
- (__kindof UITableViewCell *)ls_tableViewCell_getFromCachePoolWithCellId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
}



@end
