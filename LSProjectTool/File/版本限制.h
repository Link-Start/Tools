//
//  版本限制.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/17.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#ifndef _____h
#define _____h

iOS开发 available版本限制基础使用

1. 类判断
   限制当前类在某个版本之后才能使用

OC
API_AVAILABLE(ios(10.0)) 会对类添加系统版本约束
API_AVAILABLE(ios(10.0))
@interface TestClass: NSObject { }
Swift
@available(iOS 10.0, *) 对类添加系统版本约束
@available(iOS 10.0, *)
class TestClass: NSObject { }

2. 属性判断
//从版本iOS 10开始才使用这个属性
@property(nonatomic,strong)NSDate * date API_AVAILABLE(ios(10.0),*)
*代表全平台（iPhone、ipad、iWatch等）

3. 函数外判断
OC
__IPHONE_OS_VERSION_MIN_REQUIRED：最低iOS版本要求
__IPHONE_OS_VERSION_MAX_ALLOWED：允许最大的iOS版本
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 100000 // (iOS10以上的版本才适用)
- (void)methodName{}
#else
- (void)methodName2 {} //iOS 10以下的版本执行这个
#endif
Swift
@available(iOS 10.0, *) 限制函数适用系统范围 10.0以上
@available(iOS 10.0, *)
func funcName() { }

4. 函数内判断
OC
- (void)methodName3 {
    if (@avavilable(iOS 10.0,*)) {
        //这里的需要超过iOS 10才会执行
    }
}

Swift
func methodName4() {
    if #available(iOS 10.0, *) {
        print("iOS系统在10.0以上(包含10.0)才适用")
    } else {
        print("iOS系统在10.0以下才适用")
    }
}




iOS @available 和 #available 的用法


Swift 2.0 中,引入了可用性的概念。对于函数,类,协议等,可以使用**@available** 声明这些类型的生命周期依赖于特定的平台和操作系统版本。
而**#available** 用在判断语句中(if, guard, while等),在不同的平台上做不同的逻辑。

@available
@available放在函数(方法),类或者协议前面。表明这些类型适用的平台和操作系统。看下面一个例子:

@available(iOS 9, *) func myMethod() {
    
  // do something
}

@available(iOS 9, *)必须包含至少2个特性参数,其中iOS 9表示必须在 iOS 9 版本以上才可用。
另外一个特性参数: 星号( * ),表示包含了所有平台

@available(iOS 9, *)
// 是一种简写形式。全写形式是@available(iOS, introduced=9.0)
// introduced=9.0参数表示指定平台(iOS)从 9.0 开始引入该声明。
// 为什么可以采用简写形式呢?当只有introduced这样一种参数时,就可以简写成以上简写形式。

@available还有其他一些参数可以使用,分别是:

// deprecated = 版本号:从指定平台某个版本开始过期该声明
// obsoleted = 版本号:从指定平台某个版本开始废弃(注意弃用的区别,deprecated是还可以继续使用,只不过是不推荐了,obsoleted是调用就会编译错误)该声明
// message = 信息内容:给出一些附加信息
// unavailable : 指定平台上是无效的
// renamed = 新名字:重命名声明

@available(iOS, introduced: 6.0, deprecated: 9.0, message:"")
func myMethod() { }

@available(iOS, introduced: 8.0, obsoleted: 10.0, message:"")
func myMethod() { }

#available
#available 用在条件语句代码块中,判断不同的平台下,做不同的逻辑处理

if #available(iOS 8, *) {

  // iOS 8 及其以上系统运行
}

guard #available(iOS 8, *) else {

  return //iOS 8 以下系统就直接返回
}
