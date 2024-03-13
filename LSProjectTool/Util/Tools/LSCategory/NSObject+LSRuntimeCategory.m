////
////  NSObject+LSRuntimeCategory.m
////  LSProjectTool
////
////  Created by 刘晓龙 on 2021/6/2.
////  Copyright © 2021 Link-Start. All rights reserved.
////
///// Runtime各种方法属性参见：http://blog.csdn.net/sharktoping/article/details/59486347
////https://bujige.net/blog/iOS-YSCDefender-01.html
//
//
//#import "NSObject+LSRuntimeCategory.h"
//#import <objc/runtime.h>
//
//
//@implementation NSObject (LSRuntimeCategory)
//
///*************************************************************************************************************************************************************************************************************************/
/////获取类的成员变量列表
//+ (NSArray *)getAllIvarList {
//    unsigned int ivarCount = 0;
//    Ivar *ivarList = class_copyIvarList([self class], &ivarCount);
//    NSMutableArray *ivarArray = [NSMutableArray arrayWithCapacity:ivarCount];
//    for (int i = 0; i < ivarCount; i++) {
//        Ivar tempIvar = ivarList[i];
//        const char *ivarName = ivar_getName(tempIvar);
//        NSLog(@"成员变量ivar(%d)：%@", i, [NSString stringWithUTF8String:ivarName]);
//        [ivarArray addObject:[NSString stringWithUTF8String:ivarName]];
//    }
//    free(ivarList);
//    return ivarArray;
//}
///// 获取类的属性列表
//+ (NSArray *)getAllPropertyList {
//    unsigned int count = 0;
//    //传递count的地址
//    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
//    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i < count; i++) {
//        //得到的propertyName为C语言的字符串
//        const char *propertyName = property_getName(propertyList[i]);
//        [propertyArray addObject:[NSString stringWithUTF8String:propertyName]];
//         NSLog(@"属性(%d)：%@", i, [NSString stringWithUTF8String:propertyName]);
//    }
//    free(propertyList);
//    return propertyArray;
//}
///// 获取类的方法列表
//+ (NSArray *)getAllMethodsList {
//    unsigned int methodCount = 0;
//    Method *methodList = class_copyMethodList([self class], &methodCount);
//    NSMutableArray *methodArray = [NSMutableArray arrayWithCapacity:methodCount];
//    for (int i = 0; i < methodCount; i++) {
//        Method tempMethod = methodList[i];
//        SEL name_F = method_getName(tempMethod); //方法名
//        const char *name_s = sel_getName(name_F); //
//        int arguments = method_getNumberOfArguments(tempMethod);
//        const char * encoding = method_getTypeEncoding(tempMethod);
//          NSLog(@"方法名: %@,ArgumentCount: %d,EncodingStyle: %@",[NSString stringWithUTF8String:name_s],arguments,[NSString stringWithUTF8String:encoding]);
//        [methodArray addObject:[NSString stringWithUTF8String:name_s]];
//    }
//    free(methodList);
//    return methodArray;
//}
//
///// 获取类所遵循的协议列表
//+ (NSArray *)getAllProtocolList {
//    unsigned int protocolCount = 0;
//    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &protocolCount);
//    NSMutableArray *protocolArray = [NSMutableArray arrayWithCapacity:protocolCount];
//    for (int i = 0; i < protocolCount; i++) {
//        Protocol *tempProtocol = protocolList[i];
//        const char *protocolName = protocol_getName(tempProtocol);//协议名称
//        NSLog(@"协议(%d)：%@", i, [NSString stringWithUTF8String:protocolName]);
//        [protocolArray addObject:[NSString stringWithUTF8String:protocolName]];
//    }
//    free(protocolList);
//    return protocolArray;
//}
//
//
//
///*************************************************************************************************************************************************************************************************************************/
//// 交换两个类方法的实现
//+ (void)ls_defenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
//    swizzlingClassMethod(targetClass, originalSelector, swizzledSelector);
//}
////交换两个类方法的实现 C 函数
//void swizzlingClassMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
//    Method originalMethod = class_getClassMethod(class, originalSelector);
//    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//// 交换两个对象方法的实现
//+ (void)ls_defenderSwizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
//    swizzlingInstanceMethod(targetClass, originalSelector, swizzledSelector);
//}
////交换两个对象方法的实现 C 函数
//void swizzlingInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//
//
///*************************************************************************************************************************************************************************************************************************/
//// 1. unrecognized selector sent to instance（找不到对象方法的实现）
///**
// 消息转发机制中三大步骤：消息动态解析、消息接受者重定向、消息重定向。通过这三大步骤，可以让我们在程序找不到调用方法崩溃之前，拦截方法调用。
//  没有方法的实现，程序会在运行时挂掉并抛出 unrecognized selector sent to … 的异常。但在异常抛出前，Objective-C 的运行时会给你三次拯救程序的机会：
//  动态方法解析: Method resolution
//  Fast forwarding
//  Normal forwarding

// 大致流程如下：
// 消息动态解析：Objective-C 运行时会调用 +resolveInstanceMethod: 或者 +resolveClassMethod:，让你有机会提供一个函数实现。我们可以通过重写这两个方法，添加其他函数实现，并返回 YES， 那运行时系统就会重新启动一次消息发送的过程。若返回 NO 或者没有添加其他函数实现，则进入下一步。
// 消息接受者重定向：如果当前对象实现了 forwardingTargetForSelector:，Runtime 就会调用这个方法，允许我们将消息的接受者转发给其他对象。如果这一步方法返回 nil，则进入下一步。
// 消息重定向：Runtime 系统利用 methodSignatureForSelector: 方法获取函数的参数和返回值类型。
// 如果 methodSignatureForSelector: 返回了一个 NSMethodSignature 对象（函数签名），Runtime 系统就会创建一个 NSInvocation 对象，并通过 forwardInvocation: 消息通知当前对象，给予此次消息发送最后一次寻找 IMP 的机会。
// 如果 methodSignatureForSelector: 返回 nil。则 Runtime 系统会发出 doesNotRecognizeSelector: 消息，程序也就崩溃了。
// */
///**
// 这里我们选择第二步（消息接受者重定向）来进行拦截。因为 -forwardingTargetForSelector 方法可以将消息转发给一个对象，开销较小，并且被重写的概率较低，适合重写。
// 具体步骤如下：
// 给 NSObject 添加一个分类，在分类中实现一个自定义的 -ysc_forwardingTargetForSelector: 方法；
// 利用 Method Swizzling 将 -forwardingTargetForSelector: 和 -ysc_forwardingTargetForSelector: 进行方法交换。
// 在自定义的方法中，先判断当前对象是否已经实现了消息接受者重定向和消息重定向。如果都没有实现，就动态创建一个目标类，给目标类动态添加一个方法。
// 把消息转发给动态生成类的实例对象，由目标类动态创建的方法实现，这样 APP 就不会崩溃了。
// 实现代码如下：
// */
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 实例对象
//        //拦截 '-forwardingTargetForSelector:'方法，替换自定义实现
//        [NSObject ls_defenderSwizzlingInstanceMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(ls_instanceForwardingTargetForSelector:) withClass:[NSObject class]];
//        
//        // 类
//        //拦截 ‘+ forwardingTargetForSelector: ’ 方法,替换自定义实现
//        [NSObject ls_defenderSwizzlingClassMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(ls_classForwardingTargetForSelector:) withClass:[NSObject class]];
//    });
//}
////自定义实现 '- ls_forwardingTargetForSelector:' 方法
//- (id)ls_instanceForwardingTargetForSelector:(SEL)aSelector {
//    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
//    
//    //获取NSObject 的消息转发方法
//    Method root_forwarding_method = class_getInstanceMethod([NSObject class], forwarding_sel);
//    //获取 当前类 的消息转发方法
//    Method current_forwarding_method = class_getInstanceMethod([self class], forwarding_sel);
//    
//    //判断当前类本身是否实现第二步：消息接收者重定向
//    BOOL realize = method_getImplementation(current_forwarding_method) != method_getImplementation(root_forwarding_method);
//    
//    //如果没有实现第二步：消息接受者重定向
//    if (!realize) {
//        //判断有没有实现第三步：消息重定向
//        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
//        Method root_methodSignature_method = class_getInstanceMethod([NSObject class], methodSignature_sel);
//        
//        Method current_methodSignature_method = class_getInstanceMethod([self class], methodSignature_sel);
//        realize = method_getImplementation(current_methodSignature_method) != method_getImplementation(root_methodSignature_method);
//        
//        // 如果没有实现第三步：消息重定向
//        if (!realize) {
//            // 创建一个新类
//            NSString *errClassName = NSStringFromClass([self class]);
//            NSString *errSel = NSStringFromSelector(aSelector);
//            NSLog(@"出问题的类,出问题的对象方法 == %@ %@", errClassName, errSel);
//            
//            NSString *className = @"CrachClass";
////            char clasName = [className UTF8String];
//            Class cls = NSClassFromString(className);
//            
//            // 如果类不存在 动态创建一个类
//            if (!cls) {
//                Class superClass = [NSObject class];
//                cls = objc_allocateClassPair(superClass, className.UTF8String, 0);
//                //注册类
//                objc_registerClassPair(cls);
//            }
//            //如果类没有对应的方法,则动态添加一个
//            if (!class_getInstanceMethod(NSClassFromString(className), aSelector)) {
//                class_addMethod(cls, aSelector, (IMP)Crash, "@@:@");
//            }
//            //把消息转发到当前动态生成的实例对象上
//            return [[cls alloc] init];
//        }
//    }
//    
//    
//    return [self ls_instanceForwardingTargetForSelector:aSelector];
//}
//
////动态添加的方法实现
//static int Crash(id slf, SEL selector) {
//    return 0;
//}
//
//
//
///*************************************************************************************************************************************************************************************************************************/
//// 2. unrecognized selector sent to class（找不到类方法实现）
////找不到类方法实现的解决方法和之前类似，我们可以利用 Method Swizzling 将 +forwardingTargetForSelector: 和 +ysc_forwardingTargetForSelector: 进行方法交换。
////+ (void)load {
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        //拦截 ‘+ forwardingTargetForSelector: ’ 方法,替换自定义实现
////        [NSObject ls_defenderSwizzlingClassMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(ls_forwardingTargetForSelector:) withClass:[NSObject class]];
////    });
////}
//
////自定义实现 '+ ls_forwardingTargetForSelector: ' 方法
//+ (id)ls_classForwardingTargetForSelector:(SEL)aSelector {
//    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
//    
//    //获取 NSObject 的消息转发方法
//    Method root_forwarding_method = class_getClassMethod([NSObject class], forwarding_sel);
//    //获取 当前类 的消息转发方法
//    Method current_forwarding_method = class_getClassMethod([self class], forwarding_sel);
//    
//    //判断当前类本身是否实现第二步：消息接受者重定向
//    BOOL realize = method_getImplementation(current_forwarding_method) != method_getImplementation(root_forwarding_method);
//    
//    //如果没有实现第二步：消息接受者重定向
//    if (!realize) {
//        // 判断有没有实现第三步：消息重定向
//        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
//        Method root_methodSignature_method = class_getClassMethod([NSObject class], methodSignature_sel);
//        
//        Method current_methodSignature_method = class_getClassMethod([self class], methodSignature_sel);
//        realize = method_getImplementation(current_methodSignature_method) != method_getImplementation(root_methodSignature_method);
//        
//        //如果没有实现第三步：消息重定向
//        if (!realize) {
//            //创建一个新类
//            NSString *errClassName = NSStringFromClass([self class]);
//            NSString *errSel = NSStringFromSelector(aSelector);
//            NSLog(@"出问题的类,出问题的类方法 == %@ %@", errClassName, errSel);
//            
//            NSString *className = @"CrachClass";
//            Class cls = NSClassFromString(className);
//            
//            //如果类不存在 动态创建一个类
//            if (!cls) {
//                Class superClass = [NSObject class];
//                cls = objc_allocateClassPair(superClass, className.UTF8String, 0);
//                // 注册类
//                objc_registerClassPair(cls);
//            }
//            //如果类没有对应的方法,则动态添加一个
//            if (!class_getInstanceMethod(NSClassFromString(className), aSelector)) {
//                class_addMethod(cls, aSelector, (IMP)Crash, "@@:@");
//            }
//            //把消息转发到当前动态生成类的实例对象上
//            return [[cls alloc] init];
//        }
//    }
//    
//    return [self ls_classForwardingTargetForSelector:aSelector];
//}
//
////// 动态添加的方法实现
////static int Crash(id slf, SEL selector) {
////    return 0;
////}
//
//
//
//
//@end
