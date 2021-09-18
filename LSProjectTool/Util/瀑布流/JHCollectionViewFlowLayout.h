//
// JHCollectionViewFlowLayout.h
// LSProjectTool
//
// reated by 刘晓龙 on 2021/9/13.
// Copyright © 2021 Link-Start. All rights reserved.
//
// UICollectionView 自定义横向排版 https://www.cnblogs.com/daxueshan/p/10069156.html


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCollectionViewFlowLayout : UICollectionViewFlowLayout

///一页展示行数
@property (nonatomic, assign) NSInteger row;
///一页展示列数
@property (nonatomic, assign) NSInteger column;
///行间距
@property (nonatomic, assign) CGFloat rowSpacing;
///列间距
@property (nonatomic, assign) CGFloat columnSpacing;
///item大小
@property (nonatomic, assign) CGSize size;
///一页的宽度 默认屏幕宽度
@property (nonatomic, assign) CGFloat pageWidth;

@end

NS_ASSUME_NONNULL_END
