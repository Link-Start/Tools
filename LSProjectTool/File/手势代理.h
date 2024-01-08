//
//  手势代理.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/9/18.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//  https://www.jianshu.com/p/adc8d45f0fef
#ifndef _____h
#define _____h


// 1.
//手势识别器是否能够开始识别手势.
//当手势识别器识别到手势,准备从UIGestureRecognizerStatePossible状态开始转换时.调用此代理,如果返回YES,那么就继续识别,如果返回NO,那么手势识别器将会将状态置为UIGestureRecognizerStateFailed.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;


// 2.
//gestureRecognizer : 此对象发送的代理消息.
//返回YES允许gestureRecognizer与otherGestureRecognizer同时识别.
//如果返回NO,分两种情况.1.两个手势都返回NO,那么不会同时识别.如果一个NO,一个YES.可能会同时识别.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;


// 3.
//一般用来重写该方法.来定义什么时候手势识别失败.如果直接返回YES,那么gestureRecognizer与otherGestureRecognizer互斥的话gestureRecognizer识别失败. 可以用tap手势和longPress手势试试.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);


// 4.
//和3差不多,注意这个Be,所以是相反的,如果互斥,otherGestureRecognizer识别失败.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);


// 5.
// 返回手势识别器是否允许检查手势对象.
// UIKit将会在touchesBegan:withEvent:方法之前调用这个代理.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;


// 6
// 返回手势识别器是否允许检查按压(UIPress对象).
// UIKit将会在touchesBegan:withEvent:方法之前调用这个代理.
// 我们可以通过配置手势的属性来改变它的表现，下面介绍三个常用的属性：
// cancelsTouchesInView：该属性默认是 true。顾名思义，如果设置成 false，当手势识别成功时，将不会发送 touchesCancelled 给目标视图，从而也不会打断视图本身方法的触发，最后的结果是手势和本身方法同时触发。有的时候我们不希望手势覆盖掉视图本身的方法，就可以更改这个属性来达到效果。
// delaysTouchesBegan：该属性默认是 false。在上个例子中我们得知，在手指触摸屏幕之后，手势处于 .possible 状态时，视图的 touches 方法已经开始触发了，当手势识别成功之后，才会取消视图的 touches 方法。当该属性时 true 时，视图的 touches 方法会被延迟到手势识别成功或者失败之后才开始。也就是说，假如设置该属性为 true ，在整个过程中识别手势又是成功的话，视图的 touches 系列方法将不会被触发。
// delaysTouchesEnded：该属性默认是 true。与上个属性类似，该属性为 true 时，视图的 touchesEnded 将会延迟大约 0.15s 触发。该属性常用于连击，比如我们需要触发一个双击手势，当我们手指离开屏幕时应当触发 touchesEnded，如果这时该属性为 false，那就不会延迟视图的 touchesEnded 方法，将会立马触发 ，那我们的双击就会被识别为两次单击。当该属性是 true 时，会延迟 touchesEnded 的触发，将两次单击连在一起，来正常识别这种双击手势。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;





#pragma mark - iOS 常见的手势冲突解决方案
iOS 常见的手势冲突解决方案
https://www.jianshu.com/p/adc8d45f0fef

第一种场景 系统控件和手势的冲突


我们点击UIButton，发现只响应了button的点击事件

如何使得UIButton的点击事件和view的手势事件同时响应呢

可以设置tap的cancelsTouchesInView为NO，这样Button的点击事件和View的手势事件都会响应

// default is YES. causes touchesCancelled:withEvent: or pressesCancelled:withEvent: to be sent to the view for all touches or presses recognized as part of this gesture immediately before the action method is called.

第二种场景 UICollectionView和点击手势的冲突


点击UICollectionView的cell，发现cell没有被响应，响应的是tap手势事件

如果想要点击响应的是cell的点击事件，而不是view的tap手势，该如何实现呢

    tap.delegate = self;
实现gestureRecognizer:shouldReceiveTouch:代理

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch

{

     // 若为UICollectionViewCell（即点击了collectionViewCell），

    if ([touch.view isKindOfClass:[UICollectionViewCell class]]) {

    // cell 不需要响应 父视图的手势，保证didselect 可以正常

        return NO;

    }

    //默认都需要响应

    return  YES;

}
第三种场景 两个手势间的冲突


两个view上都加了点击手势，如果想两个手势都响应

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizershouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;

}

第四种场景 两个scrollView的滑动冲突
项目中常遇到一种场景，UIScrollView上增加了一个UIScrollView的子视图,当某些条件下需要父视图滑动，某些情况下需要子视图滑动

例如一个UICollectionView嵌套了一个UICollectionView，希望嵌套的UICollectionView在父视图达到一定高度时，父视图不再滚动，而是子视图滚动


CustomCell内也有一个collectionView(CustomCollectionView 类)

CustomCollectionView设置一个属性customScrollEnable，用来控制当与其他手势冲突时的优先级，CustomCollectionView类实现gestureRecognizer代理

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    if (self.customScrollEnable) {

        returngestureRecognizer !=self.panGestureRecognizer;

    }

    returngestureRecognizer ==self.panGestureRecognizer;

}
在父视图的scrollViewDidScroll


子视图的scrollViewDidScroll里


这样就可以通过两个很简单的判断设置customScrollEnable属性控制滑动手势的优先级

补充手势代理

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

手势识别器是否能够开始识别手势.

当手势识别器识别到手势,准备从UIGestureRecognizerStatePossible状态开始转换时.调用此代理,如果返回YES,那么就继续识别,如果返回NO,那么手势识别器将会将状态置为UIGestureRecognizerStateFailed.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

gestureRecognizer : 此对象发送的代理消息.

返回YES允许gestureRecognizer与otherGestureRecognizer同时识别.

如果返回NO,分两种情况.1.两个手势都返回NO,那么不会同时识别.如果一个NO,一个YES.可能会同时识别.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);

一般用来重写该方法.来定义什么时候手势识别失败.如果直接返回YES,那么gestureRecognizer与otherGestureRecognizer互斥的话gestureRecognizer识别失败. 可以用tap手势和longPress手势试试.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);

和3差不多,注意这个Be,所以是相反的,如果互斥,otherGestureRecognizer识别失败.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

返回手势识别器是否允许检查手势对象.

UIKit将会在touchesBegan:withEvent:方法之前调用这个代理.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;

返回手势识别器是否允许检查按压(UIPress对象).

UIKit将会在touchesBegan:withEvent:方法之前调用这个代理.

我们可以通过配置手势的属性来改变它的表现，下面介绍三个常用的属性：

// cancelsTouchesInView：该属性默认是 true。顾名思义，如果设置成 false，当手势识别成功时，将不会发送 touchesCancelled 给目标视图，从而也不会打断视图本身方法的触发，最后的结果是手势和本身方法同时触发。有的时候我们不希望手势覆盖掉视图本身的方法，就可以更改这个属性来达到效果。

delaysTouchesBegan：该属性默认是 false。在上个例子中我们得知，在手指触摸屏幕之后，手势处于 .possible 状态时，视图的 touches 方法已经开始触发了，当手势识别成功之后，才会取消视图的 touches 方法。当该属性时 true 时，视图的 touches 方法会被延迟到手势识别成功或者失败之后才开始。也就是说，假如设置该属性为 true ，在整个过程中识别手势又是成功的话，视图的 touches 系列方法将不会被触发。

delaysTouchesEnded：该属性默认是 true。与上个属性类似，该属性为 true 时，视图的 touchesEnded 将会延迟大约 0.15s 触发。该属性常用于连击，比如我们需要触发一个双击手势，当我们手指离开屏幕时应当触发 touchesEnded，如果这时该属性为 false，那就不会延迟视图的 touchesEnded 方法，将会立马触发 ，那我们的双击就会被识别为两次单击。当该属性是 true 时，会延迟 touchesEnded 的触发，将两次单击连在一起，来正常识别这种双击手势。



链接：https://www.jianshu.com/p/adc8d45f0fef







#pragma mark - 多手势之间的冲突和解决方案
https://www.jianshu.com/p/cfeb38e4bc94

// 在iOS中，如果一个手势A的识别部分是另一个手势B的子部分时，默认情况下A就会先识别，B就无法识别了。要解决这个冲突可以利用
// - (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer;
// 方法来完成。这个方法可以指定某个手势执行的前提是另一个手势失败才会识别执行。

// [a requireGestureRecognizerToFail:b]; --> 在 b手势 识别失败的时候才识别 a手势


//解决在图片上滑动时拖动手势和轻扫手势的冲突
[panGesture requireGestureRecognizerToFail:swipeGestureToRight];
[panGesture requireGestureRecognizerToFail:swipeGestureToLeft];
//解决拖动和长按手势之间的冲突
[longPressGesture requireGestureRecognizerToFail:panGesture];

通过下边的方法可以实现同一视图多个手势操作,

遵循UIGestureRecognizerDelegate,
重写相应的方法,
指定手势代理者
利用代理的方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
��(这个代理方法默认返回NO，会阻断继续向下识别手势，如果返回YES则可以继续向下传播识别。)





#pragma - mark - cancelsTouchesInView
/****************************************************************************************************************************************************************************************/

// https://www.jianshu.com/p/adc8d45f0fef
// https://www.jianshu.com/p/617577ff4be1
// https://juejin.cn/post/6894518925514997767
// cancelsTouchesInView
// 我们点击UIButton，发现只响应了button的点击事件，如何使得UIButton的点击事件和view的手势事件同时响应呢
// 可以设置tap的cancelsTouchesInView为NO，这样Button的点击事件和View的手势事件都会响应

// cancelsTouchesInView：该属性默认是 true。顾名思义，如果设置成 false，当手势识别成功时，将不会发送 touchesCancelled 给目标视图，从而也不会打断视图本身方法的触发，最后的结果是手势和本身方法同时触发。有的时候我们不希望手势覆盖掉视图本身的方法，就可以更改这个属性来达到效果。
// delaysTouchesBegan：该属性默认是 false。在上个例子中我们得知，在手指触摸屏幕之后，手势处于 .possible 状态时，视图的 touches 方法已经开始触发了，当手势识别成功之后，才会取消视图的 touches 方法。当该属性时 true 时，视图的 touches 方法会被延迟到手势识别成功或者失败之后才开始。也就是说，假如设置该属性为 true ，在整个过程中识别手势又是成功的话，视图的 touches 系列方法将不会被触发。
// delaysTouchesEnded：该属性默认是 true。与上个属性类似，该属性为 true 时，视图的 touchesEnded 将会延迟大约 0.15s 触发。该属性常用于连击，比如我们需要触发一个双击手势，当我们手指离开屏幕时应当触发 touchesEnded，如果这时该属性为 false，那就不会延迟视图的 touchesEnded 方法，将会立马触发 ，那我们的双击就会被识别为两次单击。当该属性是 true 时，会延迟 touchesEnded 的触发，将两次单击连在一起，来正常识别这种双击手势。



/****************************************************************************************************************************************************************************************/



#endif /* _____h */
