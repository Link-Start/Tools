//
//  递归获取子视图.h
//  LSProjectTool
//
//  Created by macbook v5 on 2018/5/25.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#ifndef ________h
#define ________h



// 递归获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        
        // 打印子视图类名
        NSLog(@"%@%d: %@", blank, level, subview.class);
        
        // 递归获取此视图的子视图
        [self getSub:subview andLevel:(level+1)];
        
    }
}


我们在想知道一个view的所有子view层级的时候只需要直接调用这个方法就可以了：

// 打印所有子视图
[self getSub:self.navigationController.navigationBar andLevel:1];
1
2
需要注意的是，我的level设置是从1开始的，这与方法中加空格时变量 i 起始的值是相呼应的，要改就要都改。

这里我只打印了子view的类型，其实还可以知道它们的frame等信息，只需要在打印时将 subview.class 改成直接打印 subview 就可以了，就能得到这个 subview 的所有信息。



#endif /* ________h */
