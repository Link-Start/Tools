////
////  UITableView+JYEmptyView.m
////  ShowEmptyView
////
////  Created by Davis on 16/9/22.
////  Copyright © 2016年 Davis. All rights reserved.
////
//
///*
// （1）使用class_replaceMethod/class_addMethod函数在运行时对函数进行动态替换或增加新函数
// （2）重载forwardingTargetForSelector，将无法处理的selector转发给其他对象
// （3）重载resolveInstanceMethod，从而在无法处理某个selector时，动态添加一个selector
// （4）使用class_copyPropertyList及property_getName获取类的属性列表及每个属性的名称
// (5) 使用class_copyMethodList获取类的所有方法列表
// 
// //class_getInstanceMethod     得到类的实例方法
// //class_getClassMethod        得到类的类方法
// */
//
//#import "UITableView+JYEmptyView.h"
//#import <objc/runtime.h>
//#import "JYEmpty.h"
////#import <Reachability.h>
//
//static JYEmptyView *view;
//
//@implementation UITableView (JYEmptyView)
///**
// *  交换方法
// *
// *  @param c    类
// *  @param orig system @selector
// *  @param new  new    @selector
// */
//void swizzle(Class c, SEL orig, SEL new) {
//    
//    // 使用class_getInstanceMethod  来获取类的实例方法
//    Method origMethod = class_getInstanceMethod(c, orig);
//    Method newMethod = class_getInstanceMethod(c, new);
//    
//    //利用 method_setImplementation 来直接设置某个方法的IMP
//    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
//        //在运行时对函数进行动态替换: class_replaceMethod
//        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
//    } else {
//        //利用 method_exchangeImplementations 来交换2个方法中的IMP
//        method_exchangeImplementations(origMethod, newMethod);
//    }
//}
//
////通过在Category的+ (void)load方法中添加Method Swizzling的代码,在类初始加载时自动被调用,
////load方法按照父类到子类,类自身到Category的顺序被调用.
//+ (void)load {
//    
//    //在dispatch_once中执行Method Swizzling是一种防护措施,以保证代码块只会被执行一次并且线程安全,
//    //不过此处并不需要,因为当前Category中的load方法并不会被多次调用.
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 交换方法
//        [self swizzleMethod];
//    });
//}
//
//+ (void)swizzleMethod {
//    Class c = [UITableView class];
//    swizzle(c, @selector(layoutSubviews), @selector(JY_layoutSubviews));
//}
//
//- (void)listenNetwork {
////    static Reachability *reach = nil;
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
////        [reach startNotifier];
////    });
////    
////    UIView *noNetworkView = self.noNetworkView;
////    noNetworkView.frame = [UIScreen mainScreen].bounds;
////    reach.reachableBlock = ^(Reachability *reach) {
////        dispatch_async(dispatch_get_main_queue(), ^{
////            NSLog(@"REACHABLE!");
////            
////            if (noNetworkView.superview) {
////                [noNetworkView removeFromSuperview];
////            }
////        });
////    };
////    
////    reach.unreachableBlock = ^(Reachability *reach){
////        dispatch_async(dispatch_get_main_queue(), ^{
////            NSLog(@"UNREACHABLE!");
////
////            if (!noNetworkView.superview) {
////                [kWindow addSubview:noNetworkView];
////            }
////        });
////    };
//}
//
//#pragma mark - 根据数据情况确定空白视图显示与否
//- (BOOL)isShowEmptyView {
//    NSUInteger numberOfRows = 0;
//    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++) {
//        numberOfRows += [self numberOfRowsInSection:sectionIndex];
//    }
//    return (numberOfRows > 0);
//}
//
//#pragma mark - 设置空白视图
//- (void)setEmptyView {
//    
//    UIView *emptyView = self.emptyView;
//    if (emptyView.superview) {
//        [emptyView removeFromSuperview];
//    }
//    
//    [kWindow addSubview:emptyView];
//    emptyView.backgroundColor = [UIColor whiteColor];
//    emptyView.frame = [UIScreen mainScreen].bounds;
//
//    BOOL emptyViewShouldBeShow = ([self isShowEmptyView] == NO);
//    
//    emptyView.hidden = !emptyViewShouldBeShow;
//    if (emptyView.hidden) {
//        [emptyView removeFromSuperview];
//        emptyView = nil;
//    }
//}
//
//#pragma mark - swizzle method
//- (void)JY_layoutSubviews {
//    [self JY_layoutSubviews];
//
//    [self setEmptyView];
//}
//
//#pragma mark - AssociatedObject
//- (void)setEmptyView:(UIView *)emptyView {
//    objc_setAssociatedObject(self, @selector(setEmptyView:), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (UIView *)emptyView {
//    return objc_getAssociatedObject(self, @selector(setEmptyView:));
//}
//
//- (void)setNoNetworkView:(UIView *)noNetworkView {
//    objc_setAssociatedObject(self, @selector(setNoNetworkView:), noNetworkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self listenNetwork];
//}
//
//- (UIView *)noNetworkView {
//    return objc_getAssociatedObject(self, @selector(setNoNetworkView:));
//}
//
//@end
