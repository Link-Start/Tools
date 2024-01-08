//
//  UICollectionView+LSTools.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/4.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (LSTools)

#pragma mark - 注册
/// Xib注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerNibWithHeadViewName:(__kindof UICollectionReusableView *)headViewName;
/// Xib注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerNibWithHeadViewName:(__kindof UICollectionReusableView *)headViewName headerViewId:(NSString *)headerViewId;

/// Xib注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerNibWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName;
/// Xib注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerNibWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName footerViewId:(NSString *)footerViewId;

/// Xib 注册collectionViewCell
- (void)ls__collectionViewCell_registerNibWithCellName:(__kindof UICollectionViewCell *)cellName;
/// Xib 注册collectionViewCell
- (void)ls__collectionViewCell_registerNibWithCellName:(__kindof UICollectionViewCell *)cellName cellId:(NSString *)cellId;

/// 纯代码注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerClassWithHeadViewName:(__kindof UICollectionReusableView *)headViewName;
/// 纯代码注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerClassWithHeadViewName:(__kindof UICollectionReusableView *)headViewName headerViewId:(NSString *)headerViewId;

/// 纯代码注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerClassWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName;
/// 纯代码注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerClassWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName footerViewId:(NSString *)footerViewId;

/// 纯代码注册 collectionViewCell
- (void)ls_collectionViewCell_registerClassWithCellName:(__kindof UICollectionViewCell *)cellName;
/// 纯代码注册 collectionViewCell
- (void)ls_collectionViewCell_registerClassWithCellName:(__kindof UICollectionViewCell *)cellName cellId:(NSString *)cellId;

#pragma mark - 从缓存池获取
/// 从缓存池获取 collectionView的headerView
- (__kindof UICollectionReusableView *)ls_collectionViewHeaderView_getFromCachePoolWithHeaderViewName:(__kindof UICollectionReusableView *)headerViewName indexPath:(NSIndexPath *)indexPath;
/// 从缓存池获取 collectionView的headerView
- (__kindof UICollectionReusableView *)ls_collectionViewHeaderView_getFromCachePoolWithHeaderViewId:(NSString *)headerViewId indexPath:(NSIndexPath *)indexPath;

/// 从缓存池获取 collectionView的footerView
- (__kindof UICollectionReusableView *)ls_collectionViewFooterView_getFromCachePoolWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName indexPath:(NSIndexPath *)indexPath;
/// 从缓存池获取 collectionView的footerView
- (__kindof UICollectionReusableView *)ls_collectionViewFooterView_getFromCachePoolWithFooterViewId:(NSString *)footerViewId indexPath:(NSIndexPath *)indexPath;

/// 从缓存池获取 collectionViewCell
- (__kindof UICollectionViewCell *)ls_collectionViewCell_getFromCachePoolWithCellName:(__kindof UICollectionViewCell *)cellName indexPath:(NSIndexPath *)indexPath;
/// 从缓存池获取 collectionViewCell
- (__kindof UICollectionViewCell *)ls_collectionViewCell_getFromCachePoolWithCellId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
