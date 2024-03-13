//
//  获取TableView和CollectionView活跃的cell.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/26.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#ifndef __TableView_CollectionView___cell_h
#define __TableView_CollectionView___cell_h

// iOS UITableView/UICollectionView获取特定位置的cell
// https://www.jianshu.com/p/70cdcdcb6764/



UITableView/UICollectionView获取特定位置的cell 主要依赖于各自对象提供的的api方法，应用示例如下：

// returns nil if point is outside of any row in the table
//tableView
- (nullable NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point;
//collectionView
- (nullable NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;

一、tableView双级联动
以上两种效果比较类似，实现的关键在于都是需要获得在滑动过程中滑动到tableView顶部的cell的indexPath。

方案一(不推荐原因会在后面提到)：获得当前可见的所有cell，然后取可见cell数组中的第一个cell就是目标cell，再根据cell获得indexPath。代码如下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
  if (scrollView == _rightTableView && _isSelected == NO) {
      //返回tableView可见的cell数组
        NSArray * array = [_rightTableView visibleCells];
       //返回cell的IndexPath
        NSIndexPath * indexPath = [_rightTableView indexPathForCell:array.firstObject];
        NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [_leftTableView reloadData];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
}


方案二(推荐使用)：利用偏移量！偏移量的值实际上可以代表当时处于tableView顶部的cell在tableView上的相对位置， 那么我们就可以根据偏移量获得处于顶部的cell的indexPath。代码如下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   if (scrollView == _rightTableView && _isSelected == NO) {
       //系统方法返回处于tableView某坐标处的cell的indexPath
        NSIndexPath * indexPath = [_rightTableView indexPathForRowAtPoint:scrollView.contentOffset];
        NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [_leftTableView reloadData];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
}


二、 获取处于UITableView中心的cell





获取UITableView中心线cell.gif


获取处于tableView中间cell的效果，用上述方案一比较麻烦：要考虑可见cell 的奇、偶个数问题，还有cell是否等高的情况；方案二用起来就快捷方便多了，取的cell的位置的纵坐标相当于在偏移量的基础上又增加了tableView高度的一半。代码如下：

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //获取处于UITableView中心的cell
    //系统方法返回处于tableView某坐标处的cell的indexPath
    NSIndexPath * middleIndexPath = [_rightTableView  indexPathForRowAtPoint:CGPointMake(0, scrollView.contentOffset.y + _rightTableView.frame.size.height/2)];
    NSLog(@"中间的cell：第 %ld 组 %ld个",middleIndexPath.section, middleIndexPath.row);
}


需要示例Demo的话请移驾我的Github→UITableViewLinkage

俺目前能想到的也就这了，各位同僚有什么好的想法欢迎在此留言交流😀😁😀👏👏👏


UICollectionView获取特定位置的item与UITableView相似，仅仅是获取的方法名不同，如下：
 NSIndexPath * indexPath = [_collectionView  indexPathForItemAtPoint:scrollView.contentOffset];
 NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
// ##############################################################################################################
////   好像不太行：如果collectionView的cell，一行有多个，怎么获取？获取到的时哪一个？
// ##############################################################################################################
#pragma mark - 如果collectionView的cell，一行有多个，怎么获取？获取到的时哪一个？

获取某个cell在当前tableView/collectionView上的坐标位置

 //获取某个cell在当前tableView上的坐标位置
    CGRect rectInTableView = [_rightTableView rectForRowAtIndexPath:middleIndexPath];
    //获取cell在当前屏幕的位置
    CGRect rectInSuperview = [_rightTableView convertRect:rectInTableView toView:[_rightTableView superview]];
    NSLog(@"中间的cell处于tableView上的位置: %@ /n 中间cell在当前屏幕的位置：%@", NSStringFromCGRect(rectInTableView), NSStringFromCGRect(rectInSuperview));
    
     //获取cell在当前collection的位置
     CGRect cellInCollection = [_collectionView convertRect:item.frame toView:_collectionView];
     UICollectionViewCell * item = [_collectionView cellForItemAtIndexPath:indexPath]];
     //获取cell在当前屏幕的位置
     CGRect cellInSuperview = [_collectionView convertRect:item.frame toView:[_collectionView superview]];
     NSLog(@"获取cell在当前collection的位置: %@ /n 获取cell在当前屏幕的位置：%@", NSStringFromCGRect(cellInCollection), NSStringFromCGRect(cellInSuperview));
    */


获取手指在UIScrollView上的滑动速率、方向以及移动距离

 // velocityInView： 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一体的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动。

    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView];

    //translationInView : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。X和Y的数值都是距离手指起始位置的距离
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];

作者：且行且珍惜_iOS
链接：https://www.jianshu.com/p/70cdcdcb6764/
来源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。




#endif /* __TableView_CollectionView___cell_h */
