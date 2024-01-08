//
//  JYEqualCellSpaceFlowLayout.h
//  UICollectionViewDemo
//
//  Created by 飞迪1 on 2017/10/13.
//  Copyright © 2017年 CHC. All rights reserved.
//
// collectionView 自适应宽度
// 标签流布局

#import <UIKit/UIKit.h>

IB_DESIGNABLE // 动态刷新

typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,//左对齐
    AlignWithCenter,//居中对齐
    AlignWithRight //靠右对齐
};
@interface JYEqualCellSpaceFlowLayout : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign) IBInspectable CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign) IBInspectable AlignType cellType;

- (instancetype)initWthType:(AlignType)cellType;
//全能初始化方法 其他方式初始化最终都会走到这里
- (instancetype)initWithType:(AlignType) cellType betweenOfCell:(CGFloat)betweenOfCell;
- (instancetype)initWithType:(AlignType)cellType betweenOfCell:(CGFloat)betweenOfCell edgeInset:(UIEdgeInsets)edgeInset;
@end


/**
 
 
 // 获取collectionView的真实高度 -->>       ①
 // 1.[self.collectionView reloadData];
 // 2. [self.collectionView layoutIfNeeded];
    [self.collectionView layoutSubviews];
 // 3.[self getCollectionViewHeiht:YES];
 /// 获取collectionView的高度    是否返回高度
 - (void)getCollectionViewHeiht:(BOOL)returnUpdateHeight {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (self.getCollectionViewHeightBlcok && returnUpdateHeight) {
             CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
             self.getCollectionViewHeightBlcok(height);
         }
     });
 }
 
 
 // 获取collectionView的真实高度 -->>       ②
 // 1.[self.collectionView reloadData];
 // 2.[self.collectionView layoutIfNeeded];
    [self.collectionView layoutSubviews];
 // 3. 获取collectionView的高度
 CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;


 
 - (CGSize)sizeThatFits:(CGSize)size{
     //获取总共有多少行
     int row = 0;
     CGFloat collectionWidth = size.width;
     CGFloat width = 0;
     if (self.datas.count > 0) {
         row = 1;
     }
     for (KKOfficialLabelsModel *cellModel in self.datas) {
         CGFloat space = self.flowLayout.maximumInteritemSpacing;
         KKOfficialLabelsCollecitonViewCell *cell = [KKOfficialLabelsCollecitonViewCell sharedInstance];
         cell.bounds = self.collectionView.bounds;
         cell.titleLabel.text = cellModel.label;
         CGSize size = [cell.titleLabel sizeThatFits:CGSizeZero];
         size.width += AdaptedWidth(30.f);
         size.height = AdaptedWidth(30.f);
         width += size.width + space;
         if ((width - space) >= collectionWidth) {
             row += 1;
             width = size.width + space;
         }
     }
     CGFloat space = self.flowLayout.minimumLineSpacing;
     CGFloat height = row * AdaptedWidth(30.f) + (row - 1) * space;
     size.height = height;
     return size;
 }
 
*/
