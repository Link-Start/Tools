//
//  iOS动态更换Icon的全过程记录.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2022/5/26.
//  Copyright © 2022 Link-Start. All rights reserved.
//

#ifndef iOS____Icon_______h
#define iOS____Icon_______h

//iOS动态更换Icon的全过程记录
//http://www.zzvips.com/article/166320.html



ios 动态更换icon
动态切换 app 的 icon 这个需求，在上一家公司做一款定制 app 时遇到过一次，这次领导说可能需要做，就又做了一次。虽然不是什么很难的知识点，这里也就记录一下自己做的过程吧。
 info.plist 文件编辑
 更换 icon
 静默切换
info.plist 文件
为了动态更换 icon，我们需要先配置一下我们项目的 info.plist 文件：
iOS动态更换Icon的全过程记录
1、加入 icon files(ios5)，其中会默认有两个 item：
 newsstand icon
 primary icon
2、我们需要加入我们需要的键——cfbundlealternateicons，类型为 dictionary。
3、下面再添加一些字典。这里字典的键是你希望更换 icon 的名称，在下方的 cfbundleiconfiles 数组中，写入需要更换的 icon 的名称。
primary icon： 可以设置 app 的主 icon，一般都不理会。一般主 icon 在 assets.xcassets 中设置。
newsstand icon： 这个设置一般用于在 newsstand 中显示使用。我们也不需要理会。
这里我们就将 info.plist 编辑完成了，下面我们将对应的图片加入到项目中，这里的图片需要直接加到项目中，不能放在 assets.xcassets 中。
iOS动态更换Icon的全过程记录
更换 icon
在 ios 10.3，苹果开放了这个 api，可以让我们动态更换我们的 app icon。
 
// if false, alternate icons are not supported for the current process.
@available(ios 10.3, *)
open var supportsalternateicons: bool { get }
  
// pass `nil` to use the primary application icon. the completion handler will be invoked asynchronously on an arbitrary background queue; be sure to dispatch back to the main queue before doing any further ui work.
@available(ios 10.3, *)
open func setalternateiconname(_ alternateiconname: string?, completionhandler: ((error?) -> void)? = nil)
  
// if `nil`, the primary application icon is being used.
@available(ios 10.3, *)
open var alternateiconname: string? { get }
切换到我们需要的 icon
@ibaction func changeoneclick(_ sender: any) {
  if uiapplication.shared.supportsalternateicons {
    uiapplication.shared.setalternateiconname("lambot") { (error) in
      if error != nil {
        print("更换icon错误")
      }
    }
  }
}
这里的 iconname 直接传入项目中的 icon 名称。这里需要注意的是，项目中的名字、info.plist 中存入的名称以及这里传入的名称需要一致。
重置为原始的 icon
@ibaction func resetclick(_ sender: any) {
  if uiapplication.shared.supportsalternateicons {
    uiapplication.shared.setalternateiconname(nil) { (error) in
      if error != nil {
        print("更换icon错误")
      }
    }
  }
}
如果需要恢复为原始的 icon，只需要在传入 iconname 的地方传入 nil 即可。
iOS动态更换Icon的全过程记录
现在，已经完成了切换 icon 的功能了。但是每次切换时，都会有一个弹框，下面我们就想办法去掉这个弹框。
静默切换
我们可以利用 runtime 的方法来替换掉弹出提示框的方法。
以前 method swizzling 的时候需要在 load 或者 initialize 方法，但是在 swift 中不能使用了。那就只能自己定义一个了。

extension uiviewcontroller {
  public class func initializemethod() {
    if self != uiviewcontroller.self {
      return
    }
        // method swizzling
    dispatchqueue.once(token: "changeicon") {
      let orignal = class_getinstancemethod(self, #selector(uiviewcontroller.present(_:animated:completion:)))
      let swizzling = class_getinstancemethod(self, #selector(uiviewcontroller.jt_present(_:animated:completion:)))
 
      if let old = orignal, let new = swizzling {
        method_exchangeimplementations(old, new)
      }
    }
  }
 
  @objc private func jt_present(_ viewcontrollertopresent: uiviewcontroller, animated flag: bool, completion: (() -> void)? = nil) {
    // 在这里判断是否是更换icon时的弹出框
    if viewcontrollertopresent is uialertcontroller {
 
      let alerttitle = (viewcontrollertopresent as! uialertcontroller).title
      let alertmessage = (viewcontrollertopresent as! uialertcontroller).message
 
      // 更换icon时的弹出框，这两个string都为nil。
      if alerttitle == nil && alertmessage == nil {
        return
      }
    }
        
        // 因为方法已经交换，这个地方的调用就相当于调用原先系统的 present
    self.jt_present(viewcontrollertopresent, animated: flag, completion: completion)
  }
}
定义完 uiviewcontroller 的扩展方法后，记得在 appdelegate 中调用一下。


func application(_ application: uiapplication, didfinishlaunchingwithoptions launchoptions: [uiapplication.launchoptionskey: any]?) -> bool {
 
  uiviewcontroller.initializemethod()
 
  return true
}
因为，swift 中 gcd 之前的 once 函数没有了，这里自己简单定义了一个。


extension dispatchqueue {
  private static var _oncetracker = [string]()
  public class func once(token: string, block: () -> ()) {
    objc_sync_enter(self)
    defer {
      objc_sync_exit(self)
    }
    if _oncetracker.contains(token) {
      return
    }
    _oncetracker.append(token)
    block()
  }
}
defer block 里的代码会在函数 return 之前执行，无论函数是从哪个分支 return 的，还是有 throw，还是自然而然走到最后一行。
现在，我们再更换 icon 的时候，就不会出现弹出框了。



//参考链接：
//information property list key reference
//原文链接：https://juejin.im/post/5d3e4e936fb9a07ece681775

#endif /* iOS____Icon_______h */
