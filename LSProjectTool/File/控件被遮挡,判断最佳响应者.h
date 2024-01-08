//
//  控件被遮挡,判断最佳响应者.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/12/12.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#ifndef ______________h
#define ______________h

//*********************************************************************************************************
// 获取最终的最佳响应者。 hitTest:withEvent:的代码实现大致如下：
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //3种状态无法响应事件
    if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) {
        return nil;
    }
    //触摸点若不在当前视图上则无法响应事件
    if ([self pointInside:point withEvent:event] == NO) {
        return nil;
    }
    //从后往前遍历子视图数组
    int count = (int)self.subviews.count;
    
    for (int i = count - 1; i >= 0; i--) {
        
        // 获取子视图
        UIView *childView = self.subviews[i];
        // 坐标系的转换,把触摸点在当前视图上坐标转换为在子视图上的坐标
        CGPoint childP = [self convertPoint:point toView:childView];
        //询问子视图层级中的最佳响应视图
        UIView *fitView = [childView hitTest:childP withEvent:event];
        
        if (fitView) {
            //如果子视图中有更合适的就返回
            return fitView;
        }
    }
    //没有在子视图中找到更合适的响应视图，那么自身就是最合适的
    return self;
}



//*********************************************************************************************************
1.扩大有效 点击区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {

    CGRectbounds = self.bounds;
    //扩大原热区直径至26，可以暴露个接口，用来设置需要扩大的半径。
    CGFloatwidthDelta = 600;
    CGFloatheightDelta = 600;
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect rectRange = CGRectInset(self.bounds, -30.0, -30.0);
    if (CGRectContainsPoint(rectRange, point)) {
        return self;
    } else {
        return nil;
    }
    return self;
}

有效触摸 区域
- (BOOL)pointInside:(CGPoint)pointwithEvent:(UIEvent*)event {

    CGFloat minx = self.startTouchView.frame.origin.x;
    CGFloat maxx = CGRectGetMaxX(self.endTouchView.frame);
    if(!self.isSelect) {
        minx = CGRectGetMaxX(self.startTouchView.frame);
        maxx = self.endTouchView.frame.origin.x;
    }
    return CGRectContainsPoint([self HitTestingBounds:self.bounds minx:minx maxx:maxx], point);
}

- (CGRect)HitTestingBounds:(CGRect)bounds minx:(CGFloat)minx maxx:(CGFloat)maxx {
    
    CGRect hitTestingBounds = bounds;
    hitTestingBounds.origin.x = minx;
    hitTestingBounds.size.width = maxx - minx;
    
    returnhitTestingBounds;
}




//*********************************************************************************************************

//UITableView  点击事件被拦截处理
//UITableView 拥有属于自己的点击事件，在将一个UITableView 的控件放在其它视图上， 并且其它视图需要添加手势进行操作的情况下，我们会发现我们点击UITableView的cell的时候， 并没有出发方法：
//-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
//是直接进入到了手势的方法中。 这是由于手势的冲突引起的，解决方法是调用UIGestureRecognizer的大力方法：
//-(BOOL)gestureRecognizer:

//手势单击事件
- (void)addTapGestureRecognizer:(void(^)(UITapGestureRecognizer *gesture))block {
    self.tapGestureEvent = block;
    UITapGestureRecognizer *noticeRecognizer;
    noticeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(apGestureClick:)];
    noticeRecognizer.numberOfTapsRequired = 1; // 单击
    [noticeRecognizer setDelegate:self];
    [self addGestureRecognizer:noticeRecognizer];
    [self setUserInteractionEnabled:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
//链接：https://www.jianshu.com/p/babde1af9093
//来源：简书


//*********************************************************************************************************




//*********************************************************************************************************





//*********************************************************************************************************





//*********************************************************************************************************



//*********************************************************************************************************




//*********************************************************************************************************




//*********************************************************************************************************





//*********************************************************************************************************

//*********************************************************************************************************



//*********************************************************************************************************




//*********************************************************************************************************




//*********************************************************************************************************





//*********************************************************************************************************

//*********************************************************************************************************



//*********************************************************************************************************




//*********************************************************************************************************




//*********************************************************************************************************





//*********************************************************************************************************





【手势隔层透传】iOS viewA被viewB遮挡，如何让viewA依然响应添加的 手势
https://blog.csdn.net/allanGold/article/details/107815010

iOS点击事件穿透以及扩大视图的响应区域：https://www.jianshu.com/p/40d12c1efe52






系统响应阶段

1.手指触碰屏幕，屏幕感受到触摸后，将事件交由IOKit来处理。
2.IOKIT将触摸事件封装成IOHIDEvent对象，并通过mach port传递给SpringBoard进程。
mach port是进程端口，各进程间通过它来通信。Springboard是一个系统进程，可以理解为桌面系统，可以统一管理和分发系统接收到的触摸事件。
3.SpringBoard由于接收到触摸事件，因此触发了系统进程的主线程的runloop的source回调。

发生触摸事件的时候，你有可能正在桌面上翻页，也有可能正在头条上看新闻，如果是前者，则触发SpringBoard主线程的runloop的source0回调，将桌面系统交由系统进程去消耗。而如果是后者，则将触摸事件通过IPC传递给前台APP进程，后面的事便是APP内部对于触摸事件的响应了。

APP响应触摸事件

1.APP进程的mach port接收来自SpringBoard的触摸事件，主线程的runloop被唤醒，触发source1回调。
2.source1回调又触发了一个source0回调，将接收到的IOHIDEvent对象封装成UIEvent对象，此时APP将正式开始对于触摸事件的响应。
3.source0回调将触摸事件添加到UIApplication的事件队列，当触摸事件出队后UIApplication为触摸事件寻找最佳响应者。
4.寻找到最佳响应者之后，接下来的事情便是事件在响应链中传递和响应。
触摸 事件 响应者

触摸

触摸对象即UITouch对象。

一个手指触摸屏幕，就会生成一个UITouch对象，如果多个手指同时触摸，就会生成多个UITouch对象。

多个手指先后触摸，如果系统判断多个手指触摸的是同一个地方，那么不会生成多个UITouch对象，而是更新这个UITouch对象，改变其tap count。如果多个手指触摸的不是同一个地方，那就会生成多个UITouch对象。

触摸事件

触摸事件即UIEvent。

UIEvent即对UITouch的一次封装。由于一次触摸事件并不止有一个触摸对象，可能是多指同时触摸。触摸对象集合可以通过allTouches属性来获取。

响应者

响应者即UIResponser

下列实例都是UIResponser：

UIView
UIViewController
UIApplication
Appdelegate
响应者响应触摸事件是通过下列四个方法来实现的：
//手指触碰屏幕，触摸开始

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
//手指在屏幕上移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
//手指离开屏幕，触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
//触摸结束前，某个系统事件中断了触摸，例如电话呼入
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
1
2
3
4
5
6
7
8
9
寻找最佳响应者(Hit-Testing)

当APP通过mach port得到这个触摸事件时，APP中有那么多UIView或者UIViewController，到底应该给谁去响应呢？寻找最佳响应者就是找出这个优先级最高的响应对象。

寻找最佳响应者的具体流程如下：
1.UIApplication首先将
事件传递给窗口对象(UIWindow)，如果有多个UIWindow对象，则先选择最后加上的UIWindow对象。
2.若UIWindow对象能响应这个触摸事件，则继续向其子视图传递，向子视图传递时也是先传递给最后加上的子视图。
3.若子视图无法响应该事件，则返回父视图，再传递给倒数第二个加入该父视图的子视图。
[图片上传失败…(image-95c4b4-1523776714398)]
例如上面这张图，C在B的后面加入，E在F的后面加入。那么寻找最佳响应者的顺序就是：
1.UIWindow对象将事件传递给视图A,A判断自己能否响应触摸事件，如果能响应，则继续传递给其子视图。
2.如果A能响应触摸事件，由于A有两个子视图B,C，而C又在B的后面加入的，所以A视图再把触摸事件传递给C，C再判断自己能否响应触摸事件，若能则继续传递给其子视图，若不能，则A视图再将触摸事件传递给B视图。
3.如果C能响应触摸事件，C视图也有两个子视图，分别是E和F，但是由于E是在F之后加到C上面的，所以先传递到，由于E可以响应触摸事件，所以最终的最佳响应者就是E。
视图如何判断自己能否响应触摸事件？

下列情况下，视图不能响应触摸事件：

1.触摸点不在试图范围内。
2.不允许交互：视图的userInteractionEnabled = NO。
3.隐藏：hidden = YES，如果视图隐藏了，则不能响应事件。
4.透明度：当视图的透明度小于等于0.01时，不能响应事件。
寻找最佳响应者的原理

**
**

hitTest:withEvent:

每个UIView都有一个hitTest:withEvent:方法。这个方法是寻找最佳响应者的核心方法，同时又是传递事件的桥梁。它的作用是询问事件在当前视图中的响应者。hitTest:withEvent:返回一个UIView对象，作为当前视图层次中的响应者。其默认实现是：

若当前视图无法响应事件，则返回nil。
若当前视图能响应事件，但无子视图可响应事件，则返回当前视图。
若当前视图能响应事件，同时有子视图能响应，则返回子视图层次中的事件响应者。
开始时UIApplication调用UIWindow的hitTest:withEvent:方法将触摸事件传递给UIWindow，如果UIWindow能够响应触摸事件，则调用hitTest:withEvent:将事件传递给其子视图并询问子视图上的最佳响应者，这样一级一级传递下去，获取最终的最佳响应者。
hitTest:withEvent:的代码实现大致如下：
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //3种状态无法响应事件
     if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
    //触摸点若不在当前视图上则无法响应事件
    if ([self pointInside:point withEvent:event] == NO) return nil;
    //从后往前遍历子视图数组
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--)
    {
        // 获取子视图
        UIView *childView = self.subviews[i];
        // 坐标系的转换,把触摸点在当前视图上坐标转换为在子视图上的坐标
        CGPoint childP = [self convertPoint:point toView:childView];
        //询问子视图层级中的最佳响应视图
        UIView *fitView = [childView hitTest:childP withEvent:event];
        if (fitView)
        {
            //如果子视图中有更合适的就返回
            return fitView;
        }
    }
    //没有在子视图中找到更合适的响应视图，那么自身就是最合适的
    return self;
}

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
注意这里的方法pointInside:withEvent:，这个方法是判断触摸点是否在视图范围内。默认的实现是如果触摸点在视图范围内则返回YES，否则返回NO。

下面我们在上图中的每个视图层次中添加三个方法来验证之前的分析：

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    return [super hitTest:point withEvent:event];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    return [super pointInside:point withEvent:event];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
}

1
2
3
4
5
6
7
8
9
10
11
12
点击视图，打印出来的结果是：

-[AView hitTest:withEvent:]
-[AView pointInside:withEvent:]
-[CView hitTest:withEvent:]
-[CView pointInside:withEvent:]
-[EView hitTest:withEvent:]
-[EView pointInside:withEvent:]
-[EView touchesBegan:withEvent:]

1
2
3
4
5
6
7
8
这和我们的分析是一致的。

自定义hitTest:withEvent:



自定义hitTest:withEvent:.png

大家看一下上面的图，其中A和B都是根视图控制器的View的子视图，C是加在B上的子视图。当我们触摸C中在A的那部分的视图的时候，我们打印看看：

2018-04-13 19:37:19.985968+0800 UITouchDemo[9174:387327] -[BView hitTest:withEvent:]
2018-04-13 19:37:19.987782+0800 UITouchDemo[9174:387327] -[BView pointInside:withEvent:]
2018-04-13 19:37:19.988017+0800 UITouchDemo[9174:387327] -[AView hitTest:withEvent:]
2018-04-13 19:37:19.988294+0800 UITouchDemo[9174:387327] -[AView pointInside:withEvent:]
2018-04-13 19:37:19.990704+0800 UITouchDemo[9174:387327] -[AView touchesBegan:withEvent:]

1
2
3
4
5
6
通过打印结果我们发现，触摸事件压根就没有传递到C视图这里，这是为什么呢？

原来，触摸事件最早传递到B视图，然后调用B视图的hitTest:withEvent:方法，在这个方法中会调用pointInside:withEvent:来判断触摸点是否在视图范围内，这里由于触摸的点是在A视图的那部分，所以不在B视图的那部分，因此返回NO。这样触摸事件就传递到了A视图，由于A可以响应触摸事件，而A又没有子视图，所以最终的最佳响应者就是A视图。

那么这显然不是我们希望看到的，我们希望的是当触摸C时，不管触摸的是C的哪里，C都能成为最佳响应者响应触摸事件。

要解决这个问题也很容易，我们只需要在B视图中重写pointInside:withEvent:方法。

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{

    NSLog(@"%s", __func__);
    CGPoint tmpPoint = [self convertPoint:point toView:_cView];

    if([_cView pointInside:tmpPoint withEvent:event]){

        return YES;
    }

    return [super pointInside:point withEvent:event];
}

1
2
3
4
5
6
7
8
9
10
11
12
13
我们判断触摸点位置是否在视图C范围内，如果在视图C的范围内，则直接返回YES。

触摸事件的响应

通过hitTest:withEvent:我们已经找到了最佳响应者，下面要做的事就是让这个最佳响应者响应触摸事件。这个最佳响应者对于触摸事件拥有决定权，它可以决定是自己一个响应这个事件，也可以自己响应之后还把它传递给其他响应者。这个由响应者构成的就是响应链。

响应者对于事件的响应和传递都是在*touchesBegan:withEvent:这个方法中完成的。该方法默认的实现是将该方法沿着响应链往下传递*

***响应者对于接收到的事件有三种操作：

1.默认的操作。不拦截，事件会沿着默认的响应链自动往下传递。
2.拦截，不再往下分发事件，重写touchesBegan:withEvent:方法，不调用父类的touchesBegan:withEvent:方法。
3.不拦截，继续往下分发事件，重新touchesBegan:withEvent:方法，并调用父类的touchesBegan:withEvent:方法。
我们一般在编写代码时，如果某个视图响应事件，会在该视图类中重写touchesBegan:withEvent:方法，但是并不会调用父类的

touchesBegan:withEvent:方法，这样我们就把这个事件拦截下来了，不再沿着响应链往下传递。那么我们为什么想要沿着响应链传递事件就要重写父类的touchesBegan:withEvent:方法呢？因为父类的touchesBegan:withEvent:方法默认是向下传递的。我们重写touchesBegan:withEvent:并调用父类的方法就是既对触摸事件实现了响应，又将事件沿着响应链传递了。

**
**

响应链中的事件传递规则

每一个响应者对象都有一个nextResponder方法，用来获取响应链中当前响应者对象的下一个响应者。因此，如果事件的最佳响应者确定了，那么整个响应链也就确定了。

对于响应者对象，默认的nextResponde对象如下：

UIView
若视图是UIViewController的View。则其nextResponder是UIViewController，若其只是单独的视图，则其nextResponder是其父视图。

UIViewController
若该视图是window的根视图，则其nextResponder为窗口对象，若其是由其他视图控制器present的，则其nextResponder是presenting View Controller。

UIWindow
nextResponder为UIApplication对象。



事件响应链.png

上图是官网对于响应链的示例展示，如果最佳响应者对象是UITextField，则响应链为：

UITextField->UIView->UIView->UIViewController->UIWindow->UIApplication->UIApplicationDelegate.
现在我们可以猜想，在父类的touchesBegan:withEvent:方法中，可能调用了[self.nextResponder touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event]这样来将事件沿着响应链传递。

UIResponder、UIGestureRecognizer、UIControl的优先级

不光UIResponder能响应触摸事件，UIGestureRecognizer和UIControl也能处理触摸事件。

UIGestureRecognizer

我们首先来看一个场景



UIGestureRecognizer.png

我们给上图中的黄色视图A添加tap事件：

UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
 [tap addTarget:self action:@selector(tapGesture)];
 [self addGestureRecognizer:tap];
添加点击事件：

- (void)tapGesture{

    NSLog(@"taped");
}
1
2
3
4
5
6
7
8
9
运行程序，点击黄色视图A，看打印结果：

2018-04-15 16:36:25.378952+0800 UITouchDemo[14824:351042] -[AView touchesBegan:withEvent:]
2018-04-15 16:36:25.388247+0800 UITouchDemo[14824:351042] taped
2018-04-15 16:36:25.391769+0800 UITouchDemo[14824:351042] -[AView touchesCancelled:withEvent:]

1
2
3
4
首先响应者A响应了tap。然后执行了手势识别器的函数，最后touchesCancelled:withEvent:函数确被调用，正确的应该是最后touchesEnded:withEvent:函数被调用，这是怎么回事呢？Apple的解释是：

window在将事件传递给最佳响应者之前会把事件先传给手势识别器，然后再传给最佳响应者，当手势识别器已经识别了手势时，最佳响应者对象会调用touchesCancelled:withEvent:方法终止对事件的响应。
如果按照这个理论，上面的结果也应该是先打印taped后打印-[AView touchesBegan:withEvent:]呀，为什么不是这样呢？问题出在，打印taped并不代表是这个时候事件传递到了手势识别器这里，而是手势识别器这个时候正式识别了手势。正式识别了这个手势和事件被传递到了手势识别器这里的时间是不一样的。

那么我们怎样才能知道事件是先传递给了最佳响应者还是寿司识别器呢？只需要找到手势识别器的响应函数然后打印它们即可。手势识别器的响应函数和UIResponder的响应函数非常相似：

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

1
2
3
4
5
我们重写一个单击手势类，继承自UITapGestureRecognizer即可。在这个类里导入头文件<UIKit/UIGestureRecognizerSubclass.h>:

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesCancelled:touches withEvent:event];
}


1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
这样我们就可以打印手势识别器接收事件的时间。我们打印结果：

2018-04-16 14:53:20.444618+0800 UITouchDemo[24410:731610] AView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 14:53:20.451872+0800 UITouchDemo[24410:731610] -[AView touchesBegan:withEvent:]
2018-04-16 14:53:20.452245+0800 UITouchDemo[24410:731610] AView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 14:53:20.455192+0800 UITouchDemo[24410:731610] AView taped
2018-04-16 14:53:20.455448+0800 UITouchDemo[24410:731610] -[AView touchesCancelled:withEvent:]

1
2
3
4
5
6
通过打印结果我们能够很清楚的看到，事件最先传递给了手势识别器，然后传递给了最佳响应者，在手势识别器识别成功手势后，调用最佳响应者的touchesCancelled:方法终止最佳响应者对于事件的响应。

下面再看一个情景：



多个手势识别器.png

在上图中，视图A,B,C上都添加了手势识别器，那么当我们单击C视图的时候，事件是一个怎么样的响应过程呢？我们打印结果看一下：

2018-04-16 15:03:21.809456+0800 UITouchDemo[24654:740042] AView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:03:21.811451+0800 UITouchDemo[24654:740042] UIView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:03:21.813232+0800 UITouchDemo[24654:740042] CView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:03:21.815768+0800 UITouchDemo[24654:740042] BView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:03:21.818022+0800 UITouchDemo[24654:740042] -[CView touchesBegan:withEvent:]
2018-04-16 15:03:21.818708+0800 UITouchDemo[24654:740042] AView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:03:21.818899+0800 UITouchDemo[24654:740042] UIView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:03:21.819147+0800 UITouchDemo[24654:740042] CView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:03:21.819552+0800 UITouchDemo[24654:740042] BView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:03:21.820637+0800 UITouchDemo[24654:740042] CView taped
2018-04-16 15:03:21.820967+0800 UITouchDemo[24654:740042] -[CView touchesCancelled:withEvent:]

1
2
3
4
5
6
7
8
9
10
11
12
我们可以看到，事件首先传递给了A,UIView,B,C这几个视图上面的手势识别器，然后才传递给了最佳响应者C视图，A,UIView,B,C这几个视图的手势识别器都识别了手势之后，调用最佳响应者的touchesCancelled:withEvent:方法来取消最佳响应者对于事件的响应。

再来运行一下程序，打印执行结果：

2018-04-16 15:09:53.877158+0800 UITouchDemo[24765:744167] UIView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:09:53.877720+0800 UITouchDemo[24765:744167] AView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:09:53.878351+0800 UITouchDemo[24765:744167] CView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:09:53.878720+0800 UITouchDemo[24765:744167] BView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:09:53.880317+0800 UITouchDemo[24765:744167] -[CView touchesBegan:withEvent:]
2018-04-16 15:09:53.886045+0800 UITouchDemo[24765:744167] UIView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:09:53.887088+0800 UITouchDemo[24765:744167] AView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:09:53.887661+0800 UITouchDemo[24765:744167] CView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:09:53.888026+0800 UITouchDemo[24765:744167] BView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:09:53.888661+0800 UITouchDemo[24765:744167] CView taped
2018-04-16 15:09:53.889124+0800 UITouchDemo[24765:744167] -[CView touchesCancelled:withEvent:]

1
2
3
4
5
6
7
8
9
10
11
12
我们看到，UIView,A.B,C这四个视图上的手势识别器接收事件的顺序发生了变化，但是最佳响应者CView一定是最后接收事件的，并且最后响应的函数一定是CView上绑定的手势识别器的函数。由此我们得出结论：

当响应链上有手势识别器时，事件在传递过程中一定会先传递给响应链上的手势识别器，然后才传递给最佳响应者，当响应链上的手势识别了手势后就会取消最佳响应者对于事件的响应。事件传递给响应链上的手势识别器时是乱序的，并不是按照响应链从顶至底传递，但是最后响应的函数还是响应链最顶端的手势识别器函数。

**
**

手势识别器的三个属性

@property(nonatomic) BOOL cancelsTouchesInView;
@property(nonatomic) BOOL delaysTouchesBegan;
@property(nonatomic) BOOL delaysTouchesEnded;

1
2
3
4
先总结一下手势识别器和UIResponder对于事件响应的联系：

Window先将事件传递给响应链上的手势识别器，再传递给UIResponder。
手势识别器识别手势期间，若果触摸对象的状态发生变化，都是先发送给手势识别器，再发送给UIResponder。
若手势识别器已经成功识别了手势，则停止UIResponder对于事件的响应，并停止向UIResponder发送事件。
若手势识别器未能识别手势，而此时触摸并未结束，则停止向手势识别器发送手势，仅向UIResponder发送事件。
若手势识别器未能识别手势，而此时触摸已经结束，则向UIResponder发送end状态的touch事件以停止对事件的响应。
1.cancelsTouchesInView
默认为yes。表示当手势识别成功后，取消最佳响应者对象对于事件的响应，并不再向最佳响应者发送事件。若设置为No，则表示在手势识别器识别成功后仍然向最佳响应者发送事件，最佳响应者仍响应事件。
2.delaysTouchesBegan
默认为No，即在手势识别器识别手势期间，触摸对象状态发生变化时，都会发送给最佳响应者，若设置成yes，则在识别手势期间，触摸状态发生变化时不会发送给最佳响应者。
3.delaysTouchesEnded
默认为NO。默认情况下当手势识别器未能识别手势时，若此时触摸已经结束，则会立即通知Application发送状态为end的touch事件给最佳响应者以调用 touchesEnded:withEvent: 结束事件响应；若设置为YES，则会在手势识别失败时，延迟一小段时间（0.15s）再调用响应者的 touchesEnded:withEvent:。
UIControl

UIControl是系统提供的能够以target-action模式处理触摸事件的控件，iOS中UIButton、UISegmentedControl、UISwitch等控件都是UIControl的子类。当UIControl跟踪到触摸事件时，会向其上添加的target发送事件以执行action。值得注意的是，UIConotrol是UIView的子类，因此本身也具备UIResponder应有的身份。

看下面一种情景



UIButton.png

图中视图A,B,C上都添加有单击手势，C上面的黑色按钮添加有action。

当我们点击C上面的黑色按钮时，看打印结果：

2018-04-16 15:57:10.552464+0800 UITouchDemo[25592:774264] BView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:57:10.552719+0800 UITouchDemo[25592:774264] AView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:57:10.553084+0800 UITouchDemo[25592:774264] CView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 15:57:10.556521+0800 UITouchDemo[25592:774264] BView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:57:10.557096+0800 UITouchDemo[25592:774264] AView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:57:10.557447+0800 UITouchDemo[25592:774264] CView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 15:57:10.558708+0800 UITouchDemo[25592:774264] button Clicked

1
2
3
4
5
6
7
8
我们看到，虽然事件都传递给了响应链上的手势识别器，但是这些手势识别器绑定的函数最后都没有响应，而是响应的黑色按钮绑定的action。我们再在黑色按钮上面加一个单击手势，然后单击黑色按钮，看打印结果：

2018-04-16 16:05:35.555304+0800 UITouchDemo[25754:780177] CView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 16:05:35.555745+0800 UITouchDemo[25754:780177] BView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 16:05:35.556011+0800 UITouchDemo[25754:780177] AView,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 16:05:35.556573+0800 UITouchDemo[25754:780177] UIButton,-[PDTapGestureRecognizer touchesBegan:withEvent:]
2018-04-16 16:05:35.559354+0800 UITouchDemo[25754:780177] CView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 16:05:35.559600+0800 UITouchDemo[25754:780177] BView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 16:05:35.560494+0800 UITouchDemo[25754:780177] AView,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 16:05:35.561018+0800 UITouchDemo[25754:780177] UIButton,-[PDTapGestureRecognizer touchesEnded:withEvent:]
2018-04-16 16:05:35.562089+0800 UITouchDemo[25754:780177] Button taped

1
2
3
4
5
6
7
8
9
10
可以看到，当UIControl上面添加了手势后，UIControl不会响应自己的action。
因此得出结论：

UIControl会阻止父视图上的手势识别器的行为，也就是UIControl的执行优先级比父视图上面的UIGestureRecognizer要高，但是比UIControl自身的UIGestureRecognizer优先级要低。
————————————————
版权声明：本文为CSDN博主「allanGold」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/allanGold/article/details/107815010









点击事件穿透：

有这样的需求：一个控件的某个部分被另外一个控件遮挡住，当点击这个重叠部分时，需要响应被遮盖控件的点击事件，就如下图所示：

image.png

点击事件穿透指的是点击当前视图，但是实际上被选中的是其他视图。举个例子，上图效果图中有两个按钮，当点击不重合的地方，显示的是点击当前视图，当点击重合地方时，点击的是下方的视图。

如此效果，需要用到点击穿透事件：重写系统- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event方法。

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint bluePoint = [self convertPoint:point toView:self.blueButton];
    if ([self.blueButton pointInside:bluePoint withEvent:event]) {
        return self.blueButton;
    }else {
        return [super hitTest:point withEvent:event];
    }
}
此时再点击重合的区域，响应的是A按钮的事件。

扩大视图的响应区域


image.png
扩大视图的响应区域指的是点击当前视图区域外的位置，仍然显示的是点击当前视图。举个例子，下方效果图中黄色部分是按钮，红色部分是按钮外的区域，但是点击红色部分，仍能显示点击黄色按钮。

扩大视图响应区域的本质是判断所点击的点是否在于你想要扩大的区域上。在这里，我所设置的扩大区域是边线外增加30。实现如下：

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat min_x = -30.0;
    CGFloat min_y = -30.0;
    CGFloat max_x = self.frame.size.width + 30;
    CGFloat max_y = self.frame.size.height + 30;
    
    if (point.x <= max_x && point.x >= min_x && point.y <= max_y && point.y >= min_y) {
        point = CGPointMake(0, 0);
        return [super hitTest:point withEvent:event];
    }else {
        return [super hitTest:point withEvent:event];
    }
    
}

作者：二猪哥
链接：https://www.jianshu.com/p/40d12c1efe52
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。


#endif /* ______________h */
