//
//  ClassExtension.h
//  Tractor
//
//  Created by Xcode on 16/6/24.
//  Copyright © 2016年 mc. All rights reserved.
//

/*
//类扩展 （Class Extension也有人称为匿名分类），Extension:扩展, 延展, 匿名分类;放在.m文件中;
   //作用：
        //1.能为某个类附加额外的属性，成员变量，方法声明___[1.声明私有属性(不对子类暴露);2.声明私有方法;3.声明私有成员变量;]
        //2.一般的类扩展写到.m文件中
        //3.一般的私有属性写到类扩展
   //使用格式：
         //@interface Mitchell()     //类扩展(Extension)的小括号中没有名字
             //属性
             //方法
         //@end

//分类 (category) 又叫类目
     //作用：
           // 1.分类只能扩充方法，不能扩展属性和成员变量（如果包含成员变量会直接报错）[可以通过runtime去关联增加一个额外的属性]
           // 2.如果分类中声明了一个属性，那么分类只会生成这个属性的set、get方法声明，也就是不会有实现。
    //使用格式：
             //@interface 类名（分类名字）      //分类的小括号中必须有名字
                   //方法声明
             //@end
             //@implementation类名（分类名字）
                   //方法实现
             //@end

 
 
 分类(Category)和扩展(Extension)区别?
 分类(Category)               扩展(Extension)
 运行时决议                      编译时决议
 有单独的.h和.m文件               以声明的方式存在, 寄生于宿主类的.m文件
 可以为系统类添加分类              不能为系统类添加扩展
 看不到源码的类可以添加分类         没有.m源码的类无法为其添加扩展
 
 
 
 https://zhuanlan.zhihu.com/p/389007381?utm_id=0
 iOS 小技能：App Extension的应用
 
 !-------! App Extension类型

 对于 iOS 来说，可以使用的扩展接入点有以下几个：
--- NotificationServiceExtension：
    iOS NotificationServiceExtension实现VoiceBroadcast【app处于后台/被杀死的状态仍可进行语言播报】iOS12.1以上在后台或者被杀死无法语音播报的解决方案
    https://blog.csdn.net/z929118967/article/details/103702284
 --- Today 扩展 - 在下拉的通知中心的 "今天" 的面板中添加一个 widget

 在这里插入图片描述
 --- 分享扩展 ： 使用户在不同的应用程序之间分享内容。点击分享按钮后将网站、文件或者照片通过应用分享。

 在这里插入图片描述
 --- 动作扩展 - 点击 Action 按钮后通过判断上下文来将内容发送到应用：动作扩展允许在Action Sheet中创建自定义动作按钮，例如允许用户为文档添加水印、向提醒事项中添加内容、将文本翻译成其他语言等。动作扩展和分享扩展一样都可以在任意的应用程序中激活使用，同样也需要开发者进行相应的设置
 --- 照片编辑扩展 - 在系统的照片应用中提供照片编辑的能力：将你提供的滤镜或编辑工具嵌入到系统的照片和相机应用程序中，这样用户就可以很容易地将其应用到图像和视频中
 --- 文档提供扩展 - 提供和管理文件内容：如果你的应用程序是给用户提供iOS文档的远程存储，就可以创建一个Document Provider，让用户可以直接在任何兼容的应用程序中上传和下载文档
 --- 自定义键盘
         提供一个可以用在所有应用的替代系统键盘的自定义键盘或输入法：自定义键盘需要用户在设置中进行配置，才能在输入文字时使用。
         例子： iOS上USB Keyboard安装后，打开“设置 - 通用 - 键盘 - 键盘 - 添加新键盘“，在”第三方键盘“区域点击”USB Keyboard“。
 --- Audio
      通过音频单元扩展，你可以提供音频效果、声音生成器和乐器，这些可以由音频单元宿主应用程序使用，并通过应用程序商店分发。

 
 !-------!扩展的生命周期
应用程序扩展 并不是一个独立的应用程序，它是包含在应用Bundle里一个独立的包，后缀名为.appex。包含应用程序扩展的应用程序被称为容器应用（Containing App），能够使用该扩展的应用被称为宿主应用（Host App）
    例子：，Safari里使用微信的扩展，将一个网页分享到微信中，则Safari就是宿主应用，微信就是容器应用。
    当用户在手机中安装容器应用时，应用程序扩展也会随之一起被安装；如果容器应用被卸载，应用程序扩展也会被卸载。
    宿主应用程序中定义了提供给扩展的上下文环境，并在响应用户请求时启动扩展。应用程序扩展通常在完成从宿主应用程序接收到的请求不久后终止。

    扩展的生命周期和包含该扩展的容器 app (container app) 本身的生命周期是独立的，准确地说它们是两个独立的进程。
    扩展需要对宿主 app (host app，即调用该扩展的 app) 的请求做出响应，
    当然，通过进行配置和一些手段，我们可以在扩展中访问和共享一些容器 app 的资源.

    一般来说，用户在宿主 app 中触发了该扩展后，扩展的生命周期就开始了：
    比如在分享选项中选择了你的扩展，或者向通知中心中添加了你的 widget 等等。
    而所有的扩展都是由 ViewController 进行定义的，在用户决定使用某个扩展时，其对应的 ViewController 就会被加载，因此你可以像在编写传统 app 的 ViewController 那样获取到诸如 viewDidLoad 这样的方法，并进行界面构建及做相应的逻辑。
    扩展应该保持功能的单一专注，并且迅速处理任务，在执行完成必要的任务，或者是在后台预约完成任务后，一般需要尽快通过回调将控制权交回给宿主 app，至此生命周期结束。
    关于应用程序扩展的生命周期，我们可简单描述如下 1）用户选择需要使用的应用程序扩展。 2）系统启动应用程序扩展。 3）运行应用程序扩展的代码。 4）系统终止应用程序扩展的运行。

 !-------!
 ---- App Extension通信
 应用程序扩展、容器应用和宿主应用之间是如何通信？
 在宿主应用中打开一个应用程序扩展，宿主应用向应用程序扩展发送一个请求，即传递一些数据给应用程序扩展，应用程序扩展接收到数据后，展示应用程序扩展的界面并执行一些任务，当应用程序扩展任务完成后，将数据处理的结果返回给宿主应用。
 虚线部分表示应用程序扩展与容器应用之间存在有限的交互方式
 系统Today视图中的小组件，可以通过调用NSExtensionContext的-openURL:completionHandler:方法使系统打开容器应用，但这个方式只限Today视图中的小组件。
 对于任何应用程序扩展和它的容器应用，有一个私有的共享资源，它们都可以访问其中的文件。
 在这里插入图片描述
 2.1 扩展和容器应用的交互
 通过App Group Identifier创建一个NSUserDefaults类的实例对象，存储键值对类型的数据 通过NSFileManager类的-containerURLForSecurityApplicationGroupIdentifier:方法获取共享资源的文件路径，然后读写相应文件。
 通过开启 App Groups 和进行相应的配置来开启在两个进程间的数据共享（选中Capabilities，打开App Groups选项）。
 这包括了使用 NSUserDefaults 进行小数据的共享，或者使用 NSFileCoordinator 和 NSFilePresenter 甚至是 CoreData 和 SQLite 来进行更大的文件或者是更复杂的数据交互。（添加VPN配置，Packet Tunnel Provider extension :可以利用这个扩展点来实现客户端的自定义VPN隧道协议。）
 自定义的 url scheme 也是从扩展向应用反馈数据和交互的渠道之一（点击跳转到APP）
 可以使用 iOS 8 新引入的自制 framework 的方式来组织需要重用的代码，这样在链接 framework 后 app 和扩展就都能使用相同的代码了
 
*/

#pragma mark - 类别、分类、类目 category 的小括号中必须有名字

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///给类增加方法
@interface ClassExtension : NSObject

@end

//*********************************************************  NSString
#pragma mark - NSString 扩展
@interface NSString (Extension)
/**
 *  返回值是该字符串所占的大小(width, height)
 *
 *  @param
 *  @param font: 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *  @param maxSize : 为限制该字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定的值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

///UTF8 编码 也可以直接使用系统的方法
- (NSString *)URLEncodingUTF8String;//
///UTF8 解码
- (NSString *)URLDecodingUTF8String;//解码


@end

//*********************************************************  UIColor
#pragma mark - UIColor 扩展
@interface UIColor (Extension)
/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color 十六进制颜色值 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 *  @return UIColol 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

///颜色转换 IOS中十六进制的颜色转换为UIColor
+ (instancetype)colorFromHexString:(NSString *)hexString;


@end

//*********************************************************
#pragma mark - NSDictionary 扩展
@interface NSDictionary (Extension)
/*
 NSLog打印 NSDictionary 时会自动进行如下操作,方便数组在线校验及格式化
 //1.自动补全缺失""
 //2.自动转换数组()转换为[]
 //3.自动转换unicode编码为中文
*/

//######################
//######################
/*!
*  @brief 根据key值 取出一个安全的value
*
*  @param key key
*
*  @return 如果所要取的对象为空,返回空字符串
*/
- (id)getSafeValueWithKey:(id)key;
@end

//*********************************************************
#pragma mark - NSArray 扩展
@interface NSArray (Extension)
// 判断数组是否为空的方法，数组为空返回YES,数组不为空返回NO
+ (BOOL)isEmptyArray:(NSArray *)array;

@end

//*********************************************************











