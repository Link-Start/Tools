//
//  Tools.h
//  dddddddddd
//
//  Created by Xcode on 16/5/25.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.  
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

 
// *********************************************************************************

/**
*　　┏┓　　　┏┓+ +
*　┏┛┻━━━┛┻┓ + +
*　┃　　　　　　　┃
*　┃　　　━　　　┃ ++ + + +
* ████━████ ┃+
*　┃　　　　　　　┃ +
*　┃　　　┻　　　┃
*　┃　　　　　　　┃ + +
*　┗━┓　　　┏━┛
*　　　┃　　　┃
*　　　┃　　　┃ + + + +
*　　　┃　　　┃
*　　　┃　　　┃ +  神兽保佑
*　　　┃　　　┃    代码无bug
*　　　┃　　　┃　　+
*　　　┃　 　　┗━━━┓ + +
*　　　┃ 　　　　　　　┣┓
*　　　┃ 　　　　　　　┏┛
*　　　┗┓┓┏━┳┓┏┛ + + + +
*　　　　┃┫┫　┃┫┫
*　　　　┗┻┛　┗┻┛+ + + +
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 功能类
#import "Function.h"
///AFNetworking
///判断文件是否存在，再导入使用
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

/// MBProgressHUD 扩展类
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD+Extension.h"
/// 数据请求
#import "LSBaseViewController.h"
#import "NetworkRequest.h"
/// 将数据写入plist文件
#import "NSObject+PlistTool.h"
/// 宏定义
#import "MacroDefinition.h"
/// UIView扩展类
//#import "UIView+ExtensionForFrame.h"
#import "UIView+LSCategoryForFrame.h"
#import "UIView+LSCategory.h"
#import "UIView+LSExtension.h"
/// 类别 -- 类方法的扩展
#import "ClassExtension.h"

///检测网络状态
#import "RealReachability.h"

///宏定义
#import "DefineColor.h"
#import "DefineModel.h"
#import "DefineNSLog.h"
#import "DefineSystemSize.h"

#import "DefineSystemVersion.h"

/// 使用MJRefresh添加下拉刷新功能,MJ的block块里面必须使用weakSelf
@interface Tools : NSObject

@end
