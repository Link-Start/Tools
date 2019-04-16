//
//  UIScrollVIew代理方法.h
//  LSProjectTool
//
//  Created by macbook v5 on 2018/6/26.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#ifndef UIScrollVIew_____h
#define UIScrollVIew_____h

// any offset changes 只要scrollView的content 这个方法在任何方式触发 contentOffset
// 变化的时候都会被调用（包括用户拖动，减速过程，直接通过代码设置等），可以用于监控 contentOffset
// 的变化，并根据当前的 contentOffset 对其他 view 做出随动调整。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;


// called on start of dragging (may require some time and or distance to move)
// 用户开始拖动 scroll view 的时候被调用，可能需要一些时间和距离移动之后才会触发。
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;


// 在 didEndDragging 前被调用，当 willEndDragging 方法中 velocity 为 CGPointZero
//（结束拖动时两个方向都没有速度）时，didEndDragging 中的 decelerate 为 NO，即没有减速过程，
//willBeginDecelerating 和 didEndDecelerating 也就不会被调用。反之，
// 当 velocity 不为 CGPointZero 时，scroll view 会以 velocity 为初速度，
// 减速直到 targetContentOffset。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);

// 在用户结束拖动后被调用，decelerate 为 YES 时，
// 结束拖动后会有减速过程。注，在 didEndDragging 之后，如果有减速过程，
// scroll view 的 dragging 并不会立即置为 NO，而是要等到减速结束之后，
// 所以这个 dragging 属性的实际语义更接近 scrolling。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;


// 减速动画开始前被调用。
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

// 减速动画结束时被调用，这里有一种特殊情况：当一次减速动画尚未结束的时候再次 drag scroll view，
// didEndDecelerating 不会被调用，并且这时 scroll view 的 dragging 和 decelerating 属性都是 YES。
// 新的 dragging 如果有加速度，那么 willBeginDecelerating 会再一次被调用，然后才是 didEndDecelerating；
// 如果没有加速度，虽然 willBeginDecelerating 不会被调用，但前一次留下的 didEndDecelerating 会被调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

// any zoom scale changes view缩放改变的时候调用。
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2);



//告诉代理要缩放那个控件。
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
// return a view that will be scaled. if delegate returns nil, nothing happens


// called before the scroll view begins zooming its content缩放开始的时候调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2);


// scale between minimum and maximum. called after any 'bounce' animations缩放完毕的时候调用。
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale;


// return a yes if you want to scroll to the top. if not defined, assumes YES- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
// called when scrolling animation finished. may be called immediately if already at top滚动动画完成时调用。
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;





#endif /* UIScrollVIew_____h */
