//
//  cocoaPods相关.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/10/10.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#ifndef cocoaPods___h
#define cocoaPods___h


// CocoaPods原理： https://blog.csdn.net/u014600626/article/details/102922568

// CocoaPods对三方库的管理探究： https://juejin.cn/post/6895536359323205645


CocoaPods是IOS项目上负责管理依赖的工具，即对第三方库的依赖。

CocoaPods 的原理是将所有的依赖库都放到另一个名为Pods的项目中, 然而让主项目依赖Pods项目,
这样,源码管理工作任务从主项目移到了Pods项目中.
　　1.Pods项目最终会编译成一个名为libPods.a的文件, 主项目只要依赖这个.a文件即可.
　　2.对于资源文件, CocoaPods提供了一个名为Pods-resources.sh的bash脚步, 该脚本在每次项目
　　  编译的时候都会执行,将第三方库的各种资源文件复制到目标目录中.
　　3.CocoaPods通过一个名为Pods.xcconfig的文件在编译设置所有的依赖和参数

 

IOS工程有3种库项目，framework，static library，meta library，我们通常只使用前两种。我们在使用static library库工程时，一般使用它编译出来的静态库libxxx.a，以及对应的头文件，在写应用时，将这些文件拷贝到项目里，然后将静态库添加到链接的的依赖库路径里，并将头文件目录添加到头文件搜索目录中。而framework库的依赖会简单很多，framework是资源的集合，将静态库和其头文件包含在framework目录里。

CocoaPods同时支持static library和framework的依赖管理，下面介绍这两种情况下CocoaPods是如何实现构建上的依赖的

static library
先看一下普通的项目的文件结构

CardPlayer
├── CardPlayer
│   ├── CardPlayer
│   ├── CardPlayer.xcodeproj
│   ├── CardPlayerTests
│   └── CardPlayerUITests
├── exportOptions.plist
└── wehere-dev-cloud.mobileprovision
然后我们使用Pod来管理依赖，编写的PodFile如下所示:

project 'CardPlayer/CardPlayer.xcodeproj'
 
target 'CardPlayer' do
  pod 'AFNetworking', '~> 1.0'
end
 
文件结构的变化
然后使用pod install，添加好依赖之后，项目的文件结构如下所示:

CardPlayer
├── CardPlayer
│   ├── CardPlayer
│   ├── CardPlayer.xcodeproj
│   ├── CardPlayerTests
│   └── CardPlayerUITests
├── CardPlayer.xcworkspace
│   └── contents.xcworkspacedata
├── PodFile
├── Podfile.lock
├── Pods
│   ├── AFNetworking
│   ├── Headers
│   ├── Manifest.lock
│   ├── Pods.xcodeproj
│   └── Target\ Support\ Files
├── exportOptions.plist
└── wehere-dev-cloud.mobileprovision
可以看到我们添加了如下文件

PodFile 依赖描述文件

Podfile.lock 当前安装的依赖库的版本

CardPlayer.xcworkspace

xcworkspace文件，使用CocoaPod管理依赖的项目，XCode只能使用workspace编译项目，如果还只打开以前的xcodeproj文件进行开发，编译会失败

xcworkspace文件实际是一个文件夹，实际Workspace信息保存在contents.xcworkspacedata里，该文件的内容非常简单，实际上只指示它所使用的工程的文件目录

如下所示:

     
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
version = "1.0">
<FileRef
location = "group:CardPlayer/CardPlayer.xcodeproj">
</FileRef>
<FileRef
location = "group:Pods/Pods.xcodeproj">
</FileRef>
</Workspace>
Pods目录

Pods.xcodeproj，Pods工程，所有第三方库由Pods工程构建，每个第3方库对应Pods工程的1个target，并且这个工程还有1个Pods-Xxx的target，接下来在介绍工程时再详细介绍

AFNetworking 每个第3方库，都会在Pods目录下有1个对应的目录

Headers

在Headers下有两个目录，Private和Public，第3方库的私有头文件会在Private目录下有对应的头文件，不过是1个软链接，链接到第3方库的头文件 第3方库的Pubic头文件会在Public目录下有对应的头文件，也是软链接

如下所示:

Headers/
 ├── Private
 │   └── AFNetworking
 │       ├── AFHTTPClient.h -> ../../../AFNetworking/AFNetworking/AFHTTPClient.h
 │       ├── AFHTTPRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFHTTPRequestOperation.h
 │       ├── AFImageRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFImageRequestOperation.h
 │       ├── AFJSONRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFJSONRequestOperation.h
 │       ├── AFNetworkActivityIndicatorManager.h -> ../../../AFNetworking/AFNetworking/AFNetworkActivityIndicatorManager.h
 │       ├── AFNetworking.h -> ../../../AFNetworking/AFNetworking/AFNetworking.h
 │       ├── AFPropertyListRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFPropertyListRequestOperation.h
 │       ├── AFURLConnectionOperation.h -> ../../../AFNetworking/AFNetworking/AFURLConnectionOperation.h
 │       ├── AFXMLRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFXMLRequestOperation.h
 │       └── UIImageView+AFNetworking.h -> ../../../AFNetworking/AFNetworking/UIImageView+AFNetworking.h
 └── Public
     └── AFNetworking
         ├── AFHTTPClient.h -> ../../../AFNetworking/AFNetworking/AFHTTPClient.h
         ├── AFHTTPRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFHTTPRequestOperation.h
         ├── AFImageRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFImageRequestOperation.h
         ├── AFJSONRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFJSONRequestOperation.h
         ├── AFNetworkActivityIndicatorManager.h -> ../../../AFNetworking/AFNetworking/AFNetworkActivityIndicatorManager.h
         ├── AFNetworking.h -> ../../../AFNetworking/AFNetworking/AFNetworking.h
         ├── AFPropertyListRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFPropertyListRequestOperation.h
         ├── AFURLConnectionOperation.h -> ../../../AFNetworking/AFNetworking/AFURLConnectionOperation.h
         ├── AFXMLRequestOperation.h -> ../../../AFNetworking/AFNetworking/AFXMLRequestOperation.h
         └── UIImageView+AFNetworking.h -> ../../../AFNetworking/AFNetworking/UIImageView+AFNetworking.h
 
Manifest.lock manifest文件 描述第3方库对其它库的依赖

PODS:
  - AFNetworking (1.3.4)
 
DEPENDENCIES:
  - AFNetworking (~> 1.0)
 
SPEC CHECKSUMS:
  AFNetworking: cf8e418e16f0c9c7e5c3150d019a3c679d015018
 
PODFILE CHECKSUM: 349872ccf0789fbe3fa2b0f912b1b5388eb5e1a9
 
COCOAPODS: 1.3.1
 
Target Support Files 支撑target的文件

Target\ Support\ Files/
├── AFNetworking
│   ├── AFNetworking-dummy.m
│   ├── AFNetworking-prefix.pch
│   └── AFNetworking.xcconfig
└── Pods-CardPlayer
    ├── Pods-CardPlayer-acknowledgements.markdown
    ├── Pods-CardPlayer-acknowledgements.plist
    ├── Pods-CardPlayer-dummy.m
    ├── Pods-CardPlayer-frameworks.sh
    ├── Pods-CardPlayer-resources.sh
    ├── Pods-CardPlayer.debug.xcconfig
    └── Pods-CardPlayer.release.xcconfig
在Target Support Files目录下每1个第3方库都会有1个对应的文件夹，比如AFNetworking，该目录下有一个空实现文件，也有预定义头文件用来优化头文件编译速度，还会有1个xcconfig文件，该文件会在工程配置中使用，主要存放头文件搜索目录，链接的Flag(比如链接哪些库)

在Target Support Files目录下还会有1个Pods-XXX的文件夹，该文件夹存放了第3方库声明文档markdown文档和plist文件，还有1个dummy的空实现文件，还有debug和release各自对应的xcconfig配置文件，另外还有2个脚本文件，Pods-XXX-frameworks.sh脚本用于实现framework库的链接，当依赖的第3方库是framework形式才会用到该脚本，另外1个脚本文件: Pods-XXX-resources.sh用于编译storyboard类的资源文件或者拷贝*.xcassets之类的资源文件

工程结构的变化
上一节里提到在引入CocoaPods管理依赖后，会新增workspace文件，新增的workspace文件会引用原有的应用主工程，还会引用新增的Pods工程。后续不能再直接打开原来的应用主工程进行编译，否则会失败。实际上是因为原来的应用主工程的配置现在也有了变化。下面分别介绍一下Pods工程以及主工程的变化。

Pods工程
Pods工程配置

Pods工程会为每个依赖的第3方库定义1个Target，还会定义1个Pods-Xxx的target，每个Target会生成1个静态库，如下图所示:

cocoapods_pod_project_target

Pods工程会新建Debug和Release两个Configuration，每个Configuration会为不同的target设置不同的xcconfig，xcconfig指出了头文件查找目录，要链接的第3方库，链接目录等信息，如下图所示:

cocoapods_project_target_configuration

AFNetworking.xcconfig文件的内容如下所示:

CONFIGURATION_BUILD_DIR = $PODS_CONFIGURATION_BUILD_DIR/AFNetworking
GCC_PREPROCESSOR_DEFINITIONS = $(inherited) COCOAPODS=1
HEADER_SEARCH_PATHS = "${PODS_ROOT}/Headers/Private" "${PODS_ROOT}/Headers/Private/AFNetworking" "${PODS_ROOT}/Headers/Public" "${PODS_ROOT}/Headers/Public/AFNetworking"
OTHER_LDFLAGS = -framework "CoreGraphics" -framework "MobileCoreServices" -framework "Security" -framework "SystemConfiguration"
PODS_BUILD_DIR = $BUILD_DIR
PODS_CONFIGURATION_BUILD_DIR = $PODS_BUILD_DIR/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
PODS_ROOT = ${SRCROOT}
PODS_TARGET_SRCROOT = ${PODS_ROOT}/AFNetworking
PRODUCT_BUNDLE_IDENTIFIER = org.cocoapods.${PRODUCT_NAME:rfc1034identifier}
SKIP_INSTALL = YES
上述内容说明了AFNetworking编译时查找头文件的目录Header_SERACH_PATHS，OTHER_LD_FLAGS指明了要链接的framework

Pods-CardPlayer.debug.xcconfig文件的内容如下所示：

GCC_PREPROCESSOR_DEFINITIONS = $(inherited) COCOAPODS=1
HEADER_SEARCH_PATHS = $(inherited) "${PODS_ROOT}/Headers/Public" "${PODS_ROOT}/Headers/Public/AFNetworking"
LIBRARY_SEARCH_PATHS = $(inherited) "$PODS_CONFIGURATION_BUILD_DIR/AFNetworking"
OTHER_CFLAGS = $(inherited) -isystem "${PODS_ROOT}/Headers/Public" -isystem "${PODS_ROOT}/Headers/Public/AFNetworking"
OTHER_LDFLAGS = $(inherited) -ObjC -l"AFNetworking" -framework "CoreGraphics" -framework "MobileCoreServices" -framework "Security" -framework "SystemConfiguration"
PODS_BUILD_DIR = $BUILD_DIR
PODS_CONFIGURATION_BUILD_DIR = $PODS_BUILD_DIR/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
PODS_PODFILE_DIR_PATH = ${SRCROOT}/..
PODS_ROOT = ${SRCROOT}/../Pods
Pods-CardPlayer.debug文件中OTHER_LDFLAGS说明了编译Pods时需要链接AFNetworking库，还需要链接其它framework

所以我们在xcode里能看到AFNetworking依赖的framework:

cocoapods_target_lib_dependency

Pods工程文件组织

IOS工程在XCode上看到的结构和文件系统的结构并不一致，在XCode上看到的文件夹并不是物理的文件夹，而是叫做Group，在组织IOS工程时，会将逻辑关系较近的文件放在同一个Group下。如下图所示:

cocoapods_pods_project_files

coacoapods_pods_project_afnetworking_support

可以看到Group的组织大概是以下形式:

Pods
├── Podfile # 指向根目录下的Podfile 说明依赖的第3方库
├── Frameworks  # 文件系统并没有对应的目录 这只是1个虚拟的group 表示需要链接的frameowork
├── └── iOS     # 文件系统并没有对应的目录 这只是1个虚拟的group 这里表示是ios需要链接的framework
├──     └── Xxx.framework # 链接的frameowork列表
├── Pods        # 虚拟的group 管理所有第3方库
│   └── AFNetwoking  #AFNetworking库 虚拟group 对应文件系统Pods/AFNetworking/AFNetworking目录下的内容
│       ├── xxx.h    #AFNetworking库的头文件 对应文件系统Pods/AFNetworking/AFNetworking目录下的所有头文件
│       ├── xxx.m    #AFNetworking库的实现文件 对应文件系统Pods/AFNetworking/AFNetworking目录下的所有实现文件
│       └── Support Files  # 虚拟group 支持文件 没有直接对应的文件系统目录，该group下的文件都属于目录: Pods/Target Support Files/AFNetworking/
│           ├── AFNetworking.xcconfig  # AFNetworking编译的工程配置文件
│           ├── AFNetworking-prefix.pch # AFNetworking编译用的预编译头文件
│           └── AFNetworking-dummy.m   # 空实现文件
├── Products  # 虚拟group
│   ├── libAFNetworking.a # AFNetworking target将生成的静态库
│   └── libPods-CardPlayer.a  # Pods-CardPlayer target将生成的静态库
└── Targets Support Files  # 虚拟group 管理支持文件
    └── Pods-CardPlayer    # 虚拟group Pods-CardPlayer target
        ├── Pods-CardPlayer-acknowledgements.markdown # 协议说明文档
        ├── Pods-CardPlayer-acknowledgements.plist   # 协议说明文档
        ├── Pods-CardPlayer-dummy.m  # 空实现
        ├── Pods-CardPlayer-frameworks.sh  # 安装framework的脚本
        ├── Pods-CardPlayer-resources.sh    # 安装resource的脚本
        ├── Pods-CardPlayer.debug.xcconfig  # debug configuration 的 配置文件
        └── Pods-CardPlayer.release.xcconfig # release configuration 的 配置文件
 
主工程
引入CocoaPods之后， 主工程的设置其实也会变化， 我们先看一下引入之前，主工程的Configuration设置，如下图所示:

cocoapods_before_project_config

可以看到Debug和Release的Configuration没有设置任何配置文件，再看引入CocoaPods之后，主工程的Configuration如下图所示:

cocoapod_main_project_configuration

可以看到采用CocoaPods之后，Debug Configuration设置了配置文件Pods-CardPlayer.debug.xcconfig文件，Release Configuration则设置了配置文件Pods-CardPlayer.release.xcconfig文件，这些配置文件指明了头文件的查找目录，要链接的第三方库

编译并链接第3方库的原理
头文件的查找

上一节里已经讲到主工程的Configuration已经设置了配置文件，而这份配置文件里说明了头文件的查找目录：

HEADER_SEARCH_PATHS = $(inherited) "${PODS_ROOT}/Headers/Public" "${PODS_ROOT}/Headers/Public/AFNetworking"
OTHER_CFLAGS = $(inherited) -isystem "${PODS_ROOT}/Headers/Public" -isystem "${PODS_ROOT}/Headers/Public/AFNetworking"
所以主工程可以引用第3方库的头文件，比如像这样: #import <AFNetworking/AFHTTPClient.h>

如何链接库

配置文件同样说明了链接库的查找目录以及要链接的库:

LIBRARY_SEARCH_PATHS = $(inherited) "$PODS_CONFIGURATION_BUILD_DIR/AFNetworking"
OTHER_LDFLAGS = $(inherited) -ObjC -l"AFNetworking" -framework "CoreGraphics" -framework "MobileCoreServices" -framework "Security" -framework "SystemConfiguration"
 
而在我们主工程的main target还会添加对libPods-CardPlayer.a的链接，如下图所示:

cocoapod_main_project_dependency_pods

编译顺序

我们的主工程的main target显示指出了需要链接库libPods-CardPlayer.a，而libPods-CardPlayer.a由target Pods-CardPlayer产生，所以主工程的main target将会隐式依赖于target Pods-CardPlayer，而在target Pods-CardPlayer的配置中，显示指出了依赖对第三方库对应的target的依赖，如下所示:

cocoapods_pods_dendency

所以main target -> target Pods-CardPlayer -> 第3方库对应的target

因为存在上述依赖关系，所以能保证编译顺序，保证编译链接都不会有问题

framework
如果我们在PodFile设置了use_frameworks!，则第3方库使用Framework形式的库,PodFile的内容如下所示：

project 'CardPlayer/CardPlayer.xcodeproj'
 
use_frameworks!
 
target 'CardPlayer' do
  pod 'AFNetworking', '~> 1.0'
end
 
framework这类型的库和static library比较类似，在文件结构上没什么太大变化，都是新增了Pods工程，和管理Pods工程及原主工程的workspace，但是Pods工程设置的target的类型都是framework，而不是static library，而主工程对Pods的依赖，也不再是依赖libPods-CardPlayer.a，而是Pods_CardPlayer.framework。

如下图所示:

cocoapods_framework_dependency

cocoapods_pods_framework_thrid_party

另外编译配置文件也有一些不同:

AFNetworking.xcconfig文件如下所示:

CONFIGURATION_BUILD_DIR = $PODS_CONFIGURATION_BUILD_DIR/AFNetworking
GCC_PREPROCESSOR_DEFINITIONS = $(inherited) COCOAPODS=1
HEADER_SEARCH_PATHS = "${PODS_ROOT}/Headers/Private" "${PODS_ROOT}/Headers/Public"
OTHER_LDFLAGS = -framework "CoreGraphics" -framework "MobileCoreServices" -framework "Security" -framework "SystemConfiguration"
PODS_BUILD_DIR = $BUILD_DIR
PODS_CONFIGURATION_BUILD_DIR = $PODS_BUILD_DIR/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
PODS_ROOT = ${SRCROOT}
PODS_TARGET_SRCROOT = ${PODS_ROOT}/AFNetworking
PRODUCT_BUNDLE_IDENTIFIER = org.cocoapods.${PRODUCT_NAME:rfc1034identifier}
SKIP_INSTALL = YES
而Pods-CardPlayer.debug.xcconfig文件的内容如下所示:

FRAMEWORK_SEARCH_PATHS = $(inherited) "$PODS_CONFIGURATION_BUILD_DIR/AFNetworking"
GCC_PREPROCESSOR_DEFINITIONS = $(inherited) COCOAPODS=1
LD_RUNPATH_SEARCH_PATHS = $(inherited) '@executable_path/Frameworks' '@loader_path/Frameworks'
OTHER_CFLAGS = $(inherited) -iquote "$PODS_CONFIGURATION_BUILD_DIR/AFNetworking/AFNetworking.framework/Headers"
OTHER_LDFLAGS = $(inherited) -framework "AFNetworking"
PODS_BUILD_DIR = $BUILD_DIR
PODS_CONFIGURATION_BUILD_DIR = $PODS_BUILD_DIR/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
PODS_PODFILE_DIR_PATH = ${SRCROOT}/..
PODS_ROOT = ${SRCROOT}/../Pods
使用framework形式的库之后,Pods-CardPlayer-frameworks.sh脚本也有一些不同，

...
f [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework "${BUILT_PRODUCTS_DIR}/AFNetworking/AFNetworking.framework"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework "${BUILT_PRODUCTS_DIR}/AFNetworking/AFNetworking.framework"
fi
if [ "${COCOAPODS_PARALLEL_CODE_SIGN}" == "true" ]; then
  wait
fi
 
编译framework后，它会将AFNetworking.framework安装到产品编译目录下，这样才能在运行时链接该framework

而我们的主工程的main target配置Build Phases有一项安装pod的framework，会调用Pod-CardPlayer-frameworks.sh，所以能保证正确安装framework，如下图所示:

cocoapods_target_embed_pods_framework

 

总结一下
CocoaPods 的原理是将所有的依赖库都放到另一个名为Pods的项目中, 然而让主项目依赖Pods项目（可以是framework，可以是.a文件）,修改xcode project上的一些配置，添加编译期脚本，来保证三方库能够正确的编译连接。
这样,源码管理工作任务从主项目移到了Pods项目中，编译的时候也可以正常的通过编译了。








#endif /* cocoaPods___h */
