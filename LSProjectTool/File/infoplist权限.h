//
//  infoplist权限.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/4/28.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#ifndef infoplist___h
#define infoplist___h

iOS常用权限请求判断  https://github.com/MxABC/LBXPermission

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 定位。位置
#pragma mark - 相册
#pragma mark - 相机
#pragma mark - IDFA
// 按照下面的方法添加之后，在appDelegate里面调用一次方法,会显示弹窗，不管用户同意还是拒绝弹窗只会弹出一次,除非卸载重装
// 如果卸载重装还是没有弹窗,查看设置-->隐私-->跟踪--允许App请求跟踪 是否把总开关关闭了,
// 要把总开关打开才会有弹窗,下面才会有对应的列表显示你的app
//   IDFA
1.添加 AppTrackingTransparency.frame 库
2.info.plist文件中配置key：NSUserTrackingUsageDescription value：获取设备信息用以精准推送您喜欢的内容
Pricacy - Tracking Usage Description 我们需要获取您的设备信息用以精准推送您喜欢的内容,比如推送商品,或旅游信息等,需要获取您的设备信息,您是否同意?

// 如果需要使用idfa功能所需要引入的头文件
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

//
//如果用户尚未收到授权访问可用于跟踪用户或设备的应用程序相关数据的请求，则返回该值。
//    ATTrackingManagerAuthorizationStatusNotDetermined = 0,
//
//如果访问可用于跟踪用户或设备的应用程序相关数据的授权受到限制，则返回的值。
//    ATTrackingManagerAuthorizationStatusRestricted,
//如果用户拒绝访问可用于跟踪用户或设备的应用程序相关数据的授权，则返回该值。
//    ATTrackingManagerAuthorizationStatusDenied,
//如果用户授权访问可用于跟踪用户或设备的应用程序相关数据，则返回的值
//    ATTrackingManagerAuthorizationStatusAuthorized


///获取IDFA
- (void)obtainIDFA {
    // iOS14方式访问 IDFA
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) { //用户同意授权
                NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                NSLog(@"idfaStr - %@", idfaStr);
            } else {
                NSLog(@"iOS14 用户开启了限制广告追踪");
           }
        }];
    } else {
        // 使用原方式访问 IDFA
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            NSLog(@"iOS13  idfaStr - %@", idfaStr);
        }
    }
}
- (void)obtainIDFA {
     // iOS14方式访问 IDFA
     if (@available(iOS 14, *)) {
          
          //进行权限判断，根据不同权限进行判断
          ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
          switch (status) {
               case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"用户拒绝");
//                    [self applyIDFAAuthority];//申请权限
//                  finishBlock();
                    break;
               case ATTrackingManagerAuthorizationStatusAuthorized:
                    NSLog(@"用户允许");
//                  finishBlock();
                    break;
               case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"用户为做选择或未弹窗");
                    [self applyIDFAAuthority];//申请权限
                    break;
               default:
//                    [self applyIDFAAuthority];//申请IDFA权限
                    break;
          }
          
     } else {
          // 使用原方式访问 IDFA
          if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
               NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
               NSLog(@"idfaStr - %@", idfaStr);
          } else {
               NSLog(@"iOS13  用户开启了限制广告追踪");
          }
     }
}

- (void)applyIDFAAuthority { //申请IDFA权限
     if (@available(iOS 14, *)) {
          //申请权限
         //请求弹出用户授权框，只会在程序运行是弹框1次，除非卸载app重装，通地图、相机等权限弹框一样
          [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
               if (status == ATTrackingManagerAuthorizationStatusAuthorized) { //用户同意授权
                    NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                    NSLog(@"iOS14 idfaStr - %@", idfaStr);
               } else {
                    NSLog(@"iOS14 用户开启了限制广告追踪");
               }
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  finishBlock();
//              });
          }];
     }
}

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 添加自定义字体:Fonts provided by application 数组
//1.添加资源包到工程 2.在info.plist文件中注册字体 3.在工程Bundle Resource中复制字体资源包 4.代码检测查询加入的字体并使用
//1.添加资源包到工程: addFile添加字体资源包或者直接将字体包拖到工程资源文件夹下
//2.在info.plist文件中注册字体
//在工程的info.plist属性列表中添加Fonts provided by application数组属性并在其下添加要加入的自定义字体项。\
   注意，这里在plist文件中写的是文件的全称，包括文件后缀，文件的名字我们是可以随便改的，但建议用本来的字体族名，\
   例如这里是：KristenITC，字体族名是不会变的，之后具体代码中使用的时候是用的字体族名而不是自定义的文件名。\
   本来的字体族名可以右键查看字体文件的详细信息，里面的全称是本来的字体族名，而名称是自定义的。
//3.在工程Bundle Resource中复制字体资源包
//  项目-->targets-->Build Phases-->Copy Bundle Resources下查看是否有字体资源包,如果没有,添加进来
//4.代码检测查询加入的字体并使用
//在具体使用之前，我们可以先通过UIFont类提供的函数打印出系统所有的字体列表，并找到我们更添加的字体看是否添加成功，还可以具体看到我们的资源包有哪些具体的字体样式，例如该字体族的斜体、粗体、粗斜体等等。打印字体族列表的代码如下:
///**
//  * 检查自定义字体族是否成功加入
//  */
// // 取出系统安装了的所有字体族名
// NSArray *familyNames = [UIFont familyNames];
// NSLog(@"系统所有字体族名：%@", familyNames);
// // 打印字体族的所有子字体名(每种字体族可能对应多个子样式字体，例如每种字体族可能有粗体、斜体、粗斜体等等样式)
// for(NSString *familyName in familyNames) {
//   // 字体族的所有子字体名
//   NSArray *detailedNames = [UIFont fontNamesForFamilyName:familyName];
//   NSLog(@"\n字体族%@的所有子字体名：%@", familyName,detailedNames);
// }

//使用字体
//确定字体加入系统之后就可以像自带的系统字体一样直接使用了：
//设置label的字体和大小
// (这里直接使用字体族名也是可以的，有默认的子字体样式，也可以根据需求具体到自字体比如这里的：KristenITC-Regular)
//  [_label setFont:[UIFont fontWithName:@"KristenITC" size:35.0]];


#pragma mark - 设置状态栏字体颜色
1.在info.plist中设置 View controller-based status bar appearance 为 NO    (默认值是YES)
状态栏字体的颜色只由下面的属性设定，默认为白色：
// default is UIStatusBarStyleDefault
[UIApplication sharedApplication].statusBarStyle

解决个别vc中状态栏字体颜色不同的办法
1、在info.plist中，将View controller-based status bar appearance设为NO.
2、在app delegate中：
[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
3、在个别状态栏字体颜色不一样的vc中
-(void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


#endif /* infoplist___h */
