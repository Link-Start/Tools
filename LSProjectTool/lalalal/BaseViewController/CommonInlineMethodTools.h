//
//  CommonInlineMethodTools.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/5.
//  Copyright © 2024 Link-Start. All rights reserved.
//
//  常用的内联方法工具

#ifndef CommonInlineMethodTools_h
#define CommonInlineMethodTools_h

#import <UIKit/UIKit.h>



#pragma mark - tableView 注册cell

/// 纯代码 注册 tableViewCellSectionHeaderView、tableViewCellSectionFooterView
static inline void ls_register_tableView_headerFooterView_class_(__kindof UITableView *tableView, __kindof UITableViewHeaderFooterView *headerFooterViewName) {
    [tableView registerClass:[headerFooterViewName class] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerFooterViewName class])]];
}
/// 纯代码  注册 tableViewCellSectionHeaderView、tableViewCellSectionFooterView
static inline void ls_register_tableView_headerFooterView_class(__kindof UITableView *tableView, __kindof UITableViewHeaderFooterView *headerFooterViewName, NSString *headerFooterViewNameId) {
    [tableView registerClass:[headerFooterViewName class] forHeaderFooterViewReuseIdentifier:headerFooterViewNameId];
}
/// Xib 注册 tableViewCellSectionHeaderView、tableViewCellSectionFooterView
static inline void ls_register_tableView_headerFooterView_xib_(__kindof UITableView *tableView, __kindof UITableViewHeaderFooterView *headerFooterViewName) {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([headerFooterViewName class]) bundle:nil] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerFooterViewName class])]];
}
/// Xib 注册 tableViewCellSectionHeaderView、tableViewCellSectionFooterView
static inline void ls_register_tableView_headerFooterView_xib(__kindof UITableView *tableView, __kindof UITableViewHeaderFooterView *headerFooterViewName, NSString *headerFooterViewNameId) {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([headerFooterViewName class]) bundle:nil] forHeaderFooterViewReuseIdentifier:headerFooterViewNameId];
}

/// 纯代码  注册 cell
static inline void ls_register_tableView_cell_class_(__kindof UITableView *tableView, __kindof UITableViewCell *cell) {
    [tableView registerClass:[cell class] forCellReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cell class])]];
}
/// 纯代码  注册 cell
static inline void ls_register_tableView_cell_class(__kindof UITableView *tableView, __kindof UITableViewCell *cell, NSString *cellId) {
    [tableView registerClass:[cell class] forCellReuseIdentifier:cellId];
}
/// Xib 注册 cell
static inline void ls_register_tableView_cell_xib_(__kindof UITableView *tableView, __kindof UITableViewCell *cell) {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([cell class]) bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cell class])]];
}
/// Xib 注册 cell
static inline void ls_register_tableView_cell_xib(__kindof UITableView *tableView, __kindof UITableViewCell *cell, NSString *cellId) {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([cell class]) bundle:nil] forCellReuseIdentifier:cellId];
}
#pragma mark - tableView 从缓存池中取出 headerView，footerView，cell
/// 从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
static inline __kindof UITableViewHeaderFooterView * ls_dequeueReusable_tableView_headerFooterView_(__kindof UITableView *tableView, UITableViewHeaderFooterView *headerFooterViewName) {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerFooterViewName class])]];
}
/// 从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
static inline __kindof UITableViewHeaderFooterView * ls_dequeueReusable_tableView_headerFooterView(__kindof UITableView *tableView, NSString *headerFooterViewNameId) {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewNameId];
}

/// 从缓存池获取 tableViewCell
static inline __kindof UITableViewCell * ls_dequeueReusable_tableView_cell_(__kindof UITableView *tableView, __kindof UITableViewCell *cell, NSIndexPath *indexPath) {
    return [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"k%@Id", cell] forIndexPath:indexPath];
}
/// 从缓存池获取 tableViewCell
static inline __kindof UITableViewCell * ls_dequeueReusable_tableView_cell(__kindof UITableView *tableView, __kindof UITableViewCell *cell, NSString *cellId, NSIndexPath *indexPath) {
    return [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
}


#pragma mark - collectionView 注册cell

/// Xib注册 collectionView 的headerView
static inline void ls_register_collectionView_headerView_xib_(__kindof UICollectionView *collectionView, __kindof UICollectionReusableView *headerViewName) {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([headerViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerViewName class])]];
}
/// Xib注册 collectionView 的headerView
static inline void ls_register_collectionView_headerView_xib(__kindof UICollectionView *collectionView, __kindof UICollectionReusableView *headerViewName, NSString *headerViewId) {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([headerViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
}
/// 纯代码注册 collectionView 的headerView
static inline void ls_register_collectionView_headerView_class_(__kindof UICollectionView *collectionView, __kindof __kindof UICollectionReusableView *headViewName) {
    [collectionView registerClass:[headViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headViewName class])]];
}
/// 纯代码注册 collectionView 的headerView
static inline void ls_register_collectionView_headerView_class(__kindof UICollectionView *collectionView, __kindof __kindof UICollectionReusableView *headViewName, NSString *headerViewId) {
    [collectionView registerClass:[headViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
}

/// Xib注册 collectionView 的footerView
static inline void ls_register_collectionView_footerView_xib_(__kindof UICollectionView *collectionView, __kindof UICollectionReusableView *footerViewName) {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([footerViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([footerViewName class])]];
}
/// Xib注册 collectionView 的footerView
static inline void ls_register_collectionView_footerView_xib(__kindof UICollectionView *collectionView, __kindof UICollectionReusableView *footerViewName, NSString *footerViewId) {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([footerViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewId];
}

/// 纯代码注册 collectionView 的footerView
static inline void ls_register_collectionView_footerView_class_(__kindof UICollectionView *collectionView, __kindof __kindof UICollectionReusableView *footerViewName) {
    [collectionView registerClass:[footerViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([footerViewName class])]];
}
/// 纯代码注册 collectionView 的footerView
static inline void ls_register_collectionView_footerView_class(__kindof UICollectionView *collectionView, __kindof __kindof UICollectionReusableView *footerViewName, NSString *footerViewId) {
    [collectionView registerClass:[footerViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:footerViewId];
}


/// Xib 注册 cell
static inline void ls_register_collectionView_cell_xib_(__kindof UICollectionView *collectionView, __kindof UICollectionViewCell *cellName) {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])]];
}
/// Xib 注册 cell
static inline void ls_register_collectionView_cell_xib(__kindof UICollectionView *collectionView, __kindof UICollectionViewCell *cellName, NSString *cellId) {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellWithReuseIdentifier:cellId];
}

/// 纯代码注册 collectionViewCell
static inline void ls_register_collectionView_cell_class_(__kindof UICollectionView *collectionView, __kindof UICollectionViewCell *cellName) {
    [collectionView registerClass:[cellName class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])]];
}
/// 纯代码注册 collectionViewCell
static inline void ls_register_collectionView_cell_class(__kindof UICollectionView *collectionView, __kindof UICollectionViewCell *cellName, NSString *cellId) {
    [collectionView registerClass:[cellName class] forCellWithReuseIdentifier:cellId];
}


#pragma mark - collectionView 从缓存池中取出 headerView，footerView，cell

/// 从缓存池获取 collectionView的headerView
static inline __kindof UICollectionReusableView * ls_dequeueReusable_collectionView_headerView_(__kindof UICollectionView *collectionView, __kindof UICollectionReusableView *headerViewName, NSIndexPath *indexPath) {
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerViewName class])] forIndexPath:indexPath];
}
/// 从缓存池获取 collectionView的headerView
static inline __kindof UICollectionReusableView * ls_dequeueReusable_collectionView_headerView(__kindof UICollectionView *collectionView, NSString *headerViewId, NSIndexPath *indexPath) {
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId forIndexPath:indexPath];
}

/// 从缓存池获取 collectionView的footerView
static inline __kindof UICollectionReusableView * ls_dequeueReusable_collectionView_footerView_(__kindof UICollectionView *collectionView, __kindof UICollectionReusableView *footerViewName, NSIndexPath *indexPath) {
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([footerViewName class])] forIndexPath:indexPath];
}
/// 从缓存池获取 collectionView的footerView
static inline __kindof UICollectionReusableView * ls_dequeueReusable_collectionView_footerView(__kindof UICollectionView *collectionView, NSString *footerViewId, NSIndexPath *indexPath) {
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewId forIndexPath:indexPath];
}


/// 从缓存池获取 tableViewCell
static inline __kindof UICollectionViewCell * ls_dequeueReusable_collectionView_cell_(__kindof UICollectionView *collectionView, __kindof UICollectionViewCell *cellName, NSIndexPath *indexPath) {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])] forIndexPath:indexPath];
}
/// 从缓存池获取 tableViewCell
static inline __kindof UICollectionViewCell * ls_dequeueReusable_collectionView_cell(__kindof UICollectionView *collectionView, NSString *cellId, NSIndexPath *indexPath) {
    return [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
}




#endif /* CommonInlineMethodTools_h */
