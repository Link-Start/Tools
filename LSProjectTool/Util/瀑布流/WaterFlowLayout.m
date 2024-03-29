//
//  ShopWaterLayout.m
//  集合视图之瀑布流
//
//  Created by ma c on 15/11/21.
//  Copyright (c) 2015年  . All rights reserved.
//

#import "WaterFlowLayout.h"

//每一列item之间的间距
//static const CGFloat columnMargin = 10;
//每一行item之间的间距
//static const CGFloat rowMargin = 10;

@interface WaterFlowLayout()
/** 这个字典用来存储每一列item的高度 */
@property (strong,nonatomic)NSMutableDictionary *maxYDic;
/** 存放每一个item的布局属性 */
// 准备一个用来保存每个计算好的item的属性的数组
// 数组里面保存的是 一个个的 UIcollectionViewLayoutAttributes类的对象
@property (strong,nonatomic)NSMutableArray *attrsArray;
@end

@implementation WaterFlowLayout

/** 懒加载 */
-(NSMutableDictionary *)maxYDic
{
    if (!_maxYDic)
    {
        _maxYDic = [NSMutableDictionary dictionary];
    }
    return _maxYDic;
}

/** 懒加载 */
-(NSMutableArray *)attrsArray
{
    if (!_attrsArray)
    {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

//初始化
-(instancetype)init
{
    if (self = [super init]){
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnCount = 3;
    }
    return self;
}

//每一次布局前的准备工作
-(void)prepareLayout
{
    [super prepareLayout];
    
    //清空最大的y值
    for (int i =0; i < self.columnCount; i++)
    {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        self.maxYDic[column] = @(self.sectionInset.top);
    }

    //计算所有item的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<count; i++)
    {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [self.attrsArray addObject:attrs];
    }
}

//设置collectionView滚动区域
-(CGSize)collectionViewContentSize
{
    //假设最长的那一列为第0列
    __block NSString *maxColumn = @"0";
    
    //遍历字典,找出最长的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        
        if ([maxY floatValue] > [self.maxYDic[maxColumn] floatValue])
        {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDic[maxColumn]floatValue]+self.sectionInset.bottom);
}

//允许每一次重新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//布局每一个属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //假设最短的那一列为第0列
    __block NSString *minColumn = @"0";
    
    //遍历字典,找出最短的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        
        if ([maxY floatValue] < [self.maxYDic[minColumn] floatValue])
        {
            minColumn = column;
        }
    }];
    
    //计算每一个item的宽度和高度
    CGFloat width = (self.collectionView.frame.size.width - self.columnMargin*(self.columnCount - 1) - self.sectionInset.left - self.sectionInset.right) / self.columnCount;
    
    CGFloat height = [self.delegate waterFlowLayout:self heightForWidth:width andIndexPath:indexPath] ;
    
    
    //计算每一个item的位置
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColumn floatValue];
    CGFloat y = [self.maxYDic[minColumn] floatValue] + self.rowMargin;
    
    
    //更新这一列的y值
    self.maxYDic[minColumn] = @(y + height);
    
    
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //设置item的frame
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

//布局所有item的属性,包括header、footer
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.attrsArray copy];
}


// https://www.jianshu.com/p/c97d23150b72
// https://www.jianshu.com/p/1ea2edbed601
// https://www.jianshu.com/p/4db0be2f4803
// https://www.cnblogs.com/leo-92/p/4311379.html
// UICollectionView等分有1px缝隙
- (CGFloat)fixSlitWith:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space {
    CGFloat totalSpace = (colCount - 1) * space;//总共留出的距离
    CGFloat itemWidth = (rect.size.width - totalSpace) / colCount;// 按照真实屏幕算出的cell宽度 （iPhone6 375*667）93.75
    CGFloat fixValue = 1 / [UIScreen mainScreen].scale; //(1px=0.5pt,6Plus为3px=1pt)
    CGFloat realItemWidth = floor(itemWidth) + fixValue;//取整加fixValue  floor:如果参数是小数，则求最大的整数但不大于本身.
    if (realItemWidth < itemWidth) {// 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += fixValue;
    }
    CGFloat realWidth = colCount * realItemWidth + totalSpace;//算出屏幕等分后满足1px=([UIScreen mainScreen].scale)pt实际的宽度,可能会超出屏幕,需要调整一下frame
    CGFloat pointX = (realWidth - rect.size.width) / 2; //偏移距离
    rect.origin.x = -pointX;//向左偏移
    rect.size.width = realWidth;
//    _rect = rect;
    return realItemWidth; //每个cell的真实宽度
}


@end
