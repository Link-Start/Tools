//
//  更新约束.h
//  LSProjectTool
//
//  Created by Xcode on 16/10/26.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef _____h
#define _____h


layoutIfNeeded
使用此方法强制立即进行layout,从当前view开始，此方法会遍历整个view层次(包括superviews)请求layout。因此，调用此方法会强制整个view层次布局。



setNeedsUpdateConstraints
当一个自定义view的某个属性发生改变，并且可能影响到constraint时，需要调用此方法去标记constraints需要在未来的某个点更新，系统然后调用updateConstraints.



setNeedsLayout：告知页面需要更新，但是不会立刻开始更新。执行后会立刻调用layoutSubviews。
layoutIfNeeded：告知页面布局立刻更新。所以一般都会和setNeedsLayout一起使用。如果希望立刻生成新的frame需要调用此方法，利用这点一般布局动画可以在更新布局后直接使用这个方法让动画生效。
layoutSubviews：系统重写布局
setNeedsUpdateConstraints：告知需要更新约束，但是不会立刻开始
updateConstraintsIfNeeded：告知立刻更新约束
updateConstraints：系统更新约束

- (void)updateViewConstraints ViewController的View在更新视图布局时，会先调用ViewController的updateViewConstraints 方法。我们可以通过重写这个方法去更新当前View的内部布局，而不用再继承这个View去重写-updateConstraints方法。我们在重写这个方法时，务必要调用 super 或者 调用当前View的 -updateConstraints 方法。


添加约束一般要遵循下面的规则：
1.对于两个同层级view之间的约束关系，添加到他们的父view上：
2.对于两个不同层级view之间的约束关系，添加到他们最近的共同父view上：
3.对于有层次关系的两个view之间的约束关系，添加到层次较高的父view上：






//mas 动画
-(void)beginAnimate{
    //告知需要更改约束
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:3 animations:^{
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view.mas_right).offset(-100);
        }];
        //告知父类控件绘制，不添加注释的这两行的代码无法生效
        [btn.superview layoutIfNeeded];
    }];
}

#endif /* _____h */
