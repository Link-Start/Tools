//
//  LSSegmentedView.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/29.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "LSSegmentedView.h"
#import "LSSegmentedViewCell.h" //cell


#define idefidenter @"LSSegmentedViewCellId"

@interface LSSegmentedView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *ls_segmented_collectionView;

@end

@implementation LSSegmentedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ls_addCollectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSMutableArray *)titleArray {
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleArray = titleArray;
        _ls_maxShowNum = 4;//默认是显示4个
        
        [self ls_addCollectionView];
    }
    return self;
}

- (void)ls_addCollectionView {
    [self addSubview:_ls_segmented_collectionView];
    [_ls_segmented_collectionView registerClass:[LSSegmentedViewCell class] forCellWithReuseIdentifier:idefidenter];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / _ls_maxShowNum, self.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSSegmentedViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idefidenter forIndexPath:indexPath];
    
    cell.titleStr = self.titleArray[indexPath.item];
    
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 懒加载
- (UICollectionView *)ls_segmented_collectionView {
    if (!_ls_segmented_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _ls_segmented_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //横
    }

    return _ls_segmented_collectionView;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

#pragma mark - setter方法
- (void)setLs_maxShowNum:(NSInteger)ls_maxShowNum {
    _ls_maxShowNum = ls_maxShowNum;
}

/*
 
 
 //变形属性是以中心点为基准的
 //变形属性:transform
 //大小变形：CGAffineTransformMakeScale  width*sx   heigth*sy
 viewTransform.transform = CGAffineTransformMakeScale(10, 0.5);
 //角度变形：CGAffineTransformMakeRotation
 viewTransform.transform = CGAffineTransformMakeRotation(0);//角度实现,大小变形                                                  就不会被实现了后面覆盖前面的
 //NSStringFromCGPoint  将CGPoint类型转成字符串类型
 NSLog(@"%@",NSStringFromCGPoint(viewTransform.center));
 //圆角设置:layer
 //圆角大小:cornerRadius   正方形边长的一半为圆
 viewLayer.layer.cornerRadius = 30;
 //边框设置:borderWidth
 viewLayer.layer.borderWidth = 5;
 //设置边框颜色:borderColor  默认黑色  [UIColor greenColor].CGColor
 viewLayer.layer.borderColor = [UIColor greenColor].CGColor;
 viewLayer.layer.borderColor = [[UIColor greenColor] CGColor];
 //是否切割子视图超出圆角的部分  :  YES:切割掉   默认NO:不切割
 //如果masksToBounds＝YES  阴影效果出不来
 viewLayer.layer.masksToBounds = NO;
 //阴影
 //阴影的透明度：shadowOpacity  默认0.0
 viewLayer.layer.shadowOpacity = 1.0;
 //阴影的偏移量:shadowOffset
 viewLayer.layer.shadowOffset = CGSizeMake(50, 50);
 //阴影的颜色:shadowColor
 viewLayer.layer.shadowColor = [UIColor blueColor].CGColor;
 //阴影角度：shadowRadius   带有虚化的效果
 viewLayer.layer.shadowRadius = 30;
 
 作者：SadMine
 链接：https://www.jianshu.com/p/9980bcce514b
 來源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
