//
//  UICollectionView+LSTools.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/4.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import "UICollectionView+LSTools.h"

@implementation UICollectionView (LSTools)

#pragma mark - 注册
/// Xib注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerNibWithHeadViewName:(__kindof UICollectionReusableView *)headViewName {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([headViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headViewName class])]];
}
/// Xib注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerNibWithHeadViewName:(__kindof UICollectionReusableView *)headViewName headerViewId:(NSString *)headerViewId {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([headViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
}

/// Xib注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerNibWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([footerViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([footerViewName class])]];
}
/// Xib注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerNibWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName footerViewId:(NSString *)footerViewId {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([footerViewName class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewId];
}

/// Xib 注册collectionViewCell
- (void)ls__collectionViewCell_registerNibWithCellName:(__kindof UICollectionViewCell *)cellName {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])]];
}
/// Xib 注册collectionViewCell
- (void)ls__collectionViewCell_registerNibWithCellName:(__kindof UICollectionViewCell *)cellName cellId:(NSString *)cellId {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellWithReuseIdentifier:cellId];
}

/// 纯代码注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerClassWithHeadViewName:(__kindof UICollectionReusableView *)headViewName {
    [self registerClass:[headViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headViewName class])]];
}
/// 纯代码注册 collectionView 的headerView
- (void)ls_collectionViewHeader_registerClassWithHeadViewName:(__kindof UICollectionReusableView *)headViewName headerViewId:(NSString *)headerViewId {
    [self registerClass:[headViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
}

/// 纯代码注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerClassWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName {
    [self registerClass:[footerViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([footerViewName class])]];
}
/// 纯代码注册 collectionView 的footerView
- (void)ls_collectionViewFooter_registerClassWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName footerViewId:(NSString *)footerViewId {
    [self registerClass:[footerViewName class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewId];
}

/// 纯代码注册 collectionViewCell
- (void)ls_collectionViewCell_registerClassWithCellName:(__kindof UICollectionViewCell *)cellName {
    [self registerClass:[cellName class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])]];
}
/// 纯代码注册 collectionViewCell
- (void)ls_collectionViewCell_registerClassWithCellName:(__kindof UICollectionViewCell *)cellName cellId:(NSString *)cellId {
    [self registerClass:[cellName class] forCellWithReuseIdentifier:cellId];
}

#pragma mark - 从缓存池获取
/// 从缓存池获取 collectionView的headerView
- (__kindof UICollectionReusableView *)ls_collectionViewHeaderView_getFromCachePoolWithHeaderViewName:(__kindof UICollectionReusableView *)headerViewName indexPath:(NSIndexPath *)indexPath {
  return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([headerViewName class])] forIndexPath:indexPath];
}
/// 从缓存池获取 collectionView的headerView
- (__kindof UICollectionReusableView *)ls_collectionViewHeaderView_getFromCachePoolWithHeaderViewId:(NSString *)headerViewId indexPath:(NSIndexPath *)indexPath {
  return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId forIndexPath:indexPath];
}

/// 从缓存池获取 collectionView的footerView
- (__kindof UICollectionReusableView *)ls_collectionViewFooterView_getFromCachePoolWithFooterViewName:(__kindof UICollectionReusableView *)footerViewName indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([footerViewName class])] forIndexPath:indexPath];
}
/// 从缓存池获取 collectionView的footerView
- (__kindof UICollectionReusableView *)ls_collectionViewFooterView_getFromCachePoolWithFooterViewId:(NSString *)footerViewId indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewId forIndexPath:indexPath];
}

/// 从缓存池获取 collectionViewCell
- (__kindof UICollectionViewCell *)ls_collectionViewCell_getFromCachePoolWithCellName:(__kindof UICollectionViewCell *)cellName indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"k%@Id", NSStringFromClass([cellName class])] forIndexPath:indexPath];
}
/// 从缓存池获取 collectionViewCell
- (__kindof UICollectionViewCell *)ls_collectionViewCell_getFromCachePoolWithCellId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
}


@end
