//
//  fix_UIKeyboardTaskQueue.m
//  fix_UIKeyboardTaskQueue
//
//  Created by Alipay on 2023/9/4.
//
#ifdef __arm64__

#import <UIKit/UIKit.h>
#include <objc/runtime.h>

@interface fix_UIKeyboardTaskQueue : NSObject
@end

@implementation fix_UIKeyboardTaskQueue
+ (void)load {
    extern BOOL fix_UIKeyboardTaskQueue_tryLockWhenReadyForMainThread(id self, SEL selector);
    if (@available(iOS 16.0, *)) {
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        NSArray *verInfos = [systemVersion componentsSeparatedByString:@"."];
        NSUInteger count = [verInfos count];
        if (count >= 2) {
            if ([verInfos[0] isEqualToString:@"16"]) {
                class_replaceMethod(objc_getClass("UIKeyboardTaskQueue"), sel_getUid("tryLockWhenReadyForMainThread"), (IMP)fix_UIKeyboardTaskQueue_tryLockWhenReadyForMainThread, "B16@0:8");
            }
        }
    }
}
@end

#endif

/**
 https://juejin.cn/post/7276260308515045416#heading-19
 
 通过上述分析推演，iOS 16 键盘 Crash 根因已查明，即-[UIKeyboardTaskQueue continueExecutionOnMainThread]方法内执行-[UIKeyboardTaskQueue tryLockWhenReadyForMainThread]尝试加锁失败后，不return继续向下执行读写不安全内存以及解锁，导致存在锁失效的情况，使得UIKeyboardTaskQueue成员变量_deferredTasks数组在多线程下出现并发添加UIKeyboardTaskEntry实例而引起野指针，导致最终 Crash。

 注：该根因除了导致数组读写异常而 Crash，也可能导致其他变量的状态不一致性，只是不一定表现为 Crash 而已，建议用本文方案修复。
 
 解决方案（App 内置补丁源码）
 明确根因后，解决方案就比较明确了，写一个 App 内置补丁代码使得-[UIKeyboardTaskQueue continueExecutionOnMainThread]方法内执行-[UIKeyboardTaskQueue tryLockWhenReadyForMainThread]尝试加锁失败后，正常return即可。
 补丁方案有两个：

 重写-[UIKeyboardTaskQueue continueExecutionOnMainThread]方法。在原汇编基础上新增一条指令，即在bl _objc_msgSend$tryLockWhenReadyForMainThread后添加一条汇编指令cbz w0, return_label（return_label对应源码return对应的汇编指令地址），如失败则return。但该方案涉及的原汇编指令较多，有 95 条汇编指令（见下文附件中 iOS 系统汇编），容易踩坑。
 重写-[UIKeyboardTaskQueue tryLockWhenReadyForMainThread]方法。在该方法内如加锁失败则模拟两次return，回到-[UIKeyboardTaskQueue continueExecutionOnMainThread]的上一个函数栈，改造的汇编指令较少，安全性较好，也确认了除-[UIKeyboardTaskQueue continueExecutionOnMainThread]调用外，无其他方法调用-[UIKeyboardTaskQueue tryLockWhenReadyForMainThread]。

 最终，支付宝 App 基于稳定性的考虑，采用第 2 种补丁方案修复键盘 Crash。

 补丁实现
 有两部分组成：

 1.重写方法：对应 fix_UIKeyboardTaskQueue.S 文件；
 2.Hook 入口：对应 fix_UIKeyboardTaskQueue.m 文件；
 
 
 
 
 
 
 作者：支付宝体验科技
 链接：https://juejin.cn/post/7276260308515045416
 来源：稀土掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
