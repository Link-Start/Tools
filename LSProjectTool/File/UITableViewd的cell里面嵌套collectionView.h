//
//  UITableViewd的cell里面嵌套collectionView.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/3/13.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#ifndef UITableViewd_cell____collectionView_h
#define UITableViewd_cell____collectionView_h


/***************************************************************************************************************************************************************************************************/
// tableView的cell中嵌套collectionView实现的标签流，
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
/***************************************************************************************************************************************************************************************************/

iOS 自动布局下UITableViewCell嵌套CollectionView
https://www.jianshu.com/p/2e7db06c7fdf
https://www.jianshu.com/p/829b66790bf3
https://www.5axxw.com/questions/simple/cygi5z
https://www.jianshu.com/p/4cd8acb8150c

// 方案1: --------------------------------
使用collectionViewLayout.collectionViewContentSize来获取collectionView的高度
// tableViewCell赋值
- (void)setModel:(NSArray *)dataArr {
    self.dataArr=dataArr;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
    }];
}
这样是可以实现，但有以下几个问题:
1.如果在collectionView外层再加一层View就会出现部分机型计算的高度不准确
2.如果是cell嵌套的tableView呢，怎么获取tableView的高度，网上也有再reloadData后回到主线程获取tableView的高度，
  这个时候是可以获取真实高度，


// 方案2: --------------------------------
通过重写 - (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority 方法
cell是通过systemLayoutSizeFittingSize方法获取contentView高度，然后加上分割线高度得到cell的高度，因此重写此方法返回真实高度应该是最有效的
// -- systemLayoutSizeFittingSize方法在UITableView的heightForCell方法之后调用。
// 注意：systemLayoutSizeFittingSize这个方法是cell.contentView调动，返回的contentView的size，所以最后+1，分割线的高度。并且必须有实例对象调用


1.tableView的高度，设置成自动高度
2.在设置collectionView的约束的时候，需要设置准确，确定约束到了四周，尤其是距离底部的约束
3.在tableViewcell中重写systemLayoutSizeFitting方法

// 先使用super调用，获取cell的size，注意，这里的size高度是不包括collectionView的高度，
// 我们需要再调用collectionView的layoutIfNeeded，获取collectionView的高度，然后得出cell的正确高度，并返回。

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    
    //有些cell在tableView第一次reload之后无法显示正确的高度，需要再reload一次才会显示正确高度，
    //这时我们需要在systemLayoutSizeFittingSize方法中先调用self的layoutIfNeeded，再使用super调用，以获取cell正确的size。
    [self layoutIfNeeded];//
    
    // 先使用super调用，获取cell的size，注意，这里的size高度是不包括collectionView的高度
    CGSize size = [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
    
    // 需要再调用collectionView的layoutIfNeeded，获取collectionView的高度
    [self.collectionView layoutIfNeeded];
    CGFloat collectionH = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    // 得出cell的正确高度，并返回
    CGFloat height = size.height + collectionH;
    return CGSizeMake(size.width, height);
}



/*****************************************************************/

systemLayoutSizeFittingSize 高度自适应
https://www.jianshu.com/p/4cd8acb8150c
https://www.jianshu.com/p/fa0288a18ede?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation




/*****************************************************************/
iOS-systemLayoutSizeFittingSize获取布局后控件的的高度
https://www.jianshu.com/p/bf68cb8713f0

CGfloat height =  [self.evaluateTitleLbl systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
这里的height 就是获取布局后的 label 实际高度。



/*****************************************************************/



#endif /* UITableViewd_cell____collectionView_h */
