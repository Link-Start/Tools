
source 'https://github.com/CocoaPods/Specs.git'			#知名依赖库的来源地址
platform :ios, '13.0' #'9.0'	#平台ios,版本9.0 #取消对本行的注释以定义项目的全局平台
inhibit_all_warnings!	#忽略引入库的所有警告
use_frameworks!			#如果您不使用swift并且不想使用动态框架，请对本行进行注释。
# 默认情况下，通过 CocoaPods 添加的第三方源码库都为动态库，因为在 Xcode 9 之前，不支持 Swift 静态库编译，CocoaPods 的 Profile 中会默认添加 use_frameworks! 标记，要转成静态库，只需要把 use_frameworks! 改成 use_frameworks! :linkage => :static。
#

#使用多target 可以用下面这样定义,避免重复书写代码
def all_Pods
	# 常用
	pod 'AFNetworking'					#网络请求(截至2023年1月17日，AFNetworking已弃用,将不再发布。但仍可在项目中继续使用)，
	pod 'Alamofire'						#Swift中的优雅HTTP网络
	pod 'AFNetworking+RetryPolicy'		#增加了为使用AFNetworking提出的请求设置重试逻辑的能力
	#ObjcAssociatedObjectHelpers		#Objc关联对象助手
	pod 'YTKNetwork'					#YTK 网络请求

	pod 'SQCombineRequest'							#自带网络请求工具、使用的是AFNetworking 4.0版本，如果冲突可以使用下面方式导入(https://www.jianshu.com/p/2419af38c318)
	# pod 'SQCombineRequest/SQCombineRequestCombine'	#不带网络工具，不依赖AFNetworking，要自己设置SQCombineRequestItem的netRequestTool属性


	pod 'DZNEmptyDataSet'				#空白占位图
	pod 'LYEmptyView'					#iOS一行代码集成空白页面占位图(无数据、无网ƒ络占位图)
	pod 'ZXEmptyView'					#【支持tableView、collectionView、scrollView和普通View】轻松构建无数据、网络错误等占位图，简单易用，快速实现各种自定义效果！支持在根控制器中统一设置项目所有页面的空数据图，tableView与collectionView空数据图自动显示与隐藏，一劳永逸！
	pod 'FMListPlaceholder'				#一个优雅的占位图解决方案。适用于 UITableView 和 UICollectionView。
	pod 'JHNoDataEmptyView'

	pod 'TABAnimated'					#一个由iOS原生组件映射出骨架屏的框架，包含快速植入，低耦合，兼容复杂视图等特点，提供国内主流骨架屏动画的加载方案，同时支持上拉加载更多、自定制动画。
										# https://github.com/tigerAndBull/TABAnimated

	pod 'Masonry'						#布局
	pod 'SDAutoLayout'					#布局
	pod 'MyLayout'						#MyLayout是一套iOS界面视图布局框架。
	pod 'SnapKit'                     #适用于iOS和OS X的Swift自动布局DSL
  #SwifterSwift 是 500 多个原生 Swift 扩展的集合，为 iOS、macOS、tvOS、watchOS 和 Linux 提供了（超过 500 个）适用于各种原生数据类型、UIKit 和 Cocoa 类的便捷方法、语法糖和性能改进。
  
	pod 'SQScanView'					#iOS 扫码，简单设置识别区域，一图多码https://www.jianshu.com/p/453dd245498d

	# pod 'SDCycleScrollView'				# 轮播图
	pod 'WMZBanner'						# 2021.10，cell偏移，好像还不支持masonary约束布局，最好用的轻量级轮播图+卡片样式+自定义样式,链式编程语法(可实现各种样式的轮播图,大多需要的功能都有)
	pod 'KJBannerView'					# 有点不好用，轮播图(看demo)，
	pod 'KJBannerView/Downloader'		# KJBannerView 轮播图要配合这个库使用
	pod 'TYCyclePagerView'				# 轮播图，TYPageControl可修改大小
	pod 'ZYBannerView'					# 简单易用, 显示内容定制性强的可循环轮播控件. 可以实现类似淘宝商品详情中侧拉进入详情页的功能.
	pod 'EllipsePageControl'			# 椭圆形 长方形 PageControl 轮播图点
	pod 'XHPageControl'					# 一个简洁好用的自定义UIPageControl（https://github.com/zxhkit/XHPageControl）
	pod 'FSPagerView'

	pod 'SDWebImage'					# 请求图片
	pod 'SDWebImageWebPCoder'			# SDWebImage的WebP编码器插件，使用libwebp
	pod 'MBProgressHUD'					# loading动画
	pod 'SVProgressHUD'					# loading动画
	pod 'NVActivityIndicatorView'		#加载动画集合 loading..动画  Swift语言
	pod 'IQKeyboardManager'				#输入框键盘管理iOS8 and later
	pod 'MJExtension'					#数据模型转换
	pod 'KakaJSON'						# 纯Swift版的JSON与Model转换框架已经开源上架，如果你的项目是用Swift写的Model，墙裂推荐使用KakaJSON（https://github.com/kakaopensource/KakaJSON）
	pod 'MJRefresh'						#刷新
	pod 'ReactiveObjC'					#RAC
	
	pod 'SJAttributesFactory'			# OC，2019，iOS 富文本编辑, 让代码更清晰. 文本编辑, 高度计算, 正则匹配等待... 简便操作, 让你爽到爆!
	# pod 'SJAttributesStringMaker'		# Swift，iOS 富文本编辑, 让代码更清晰. 文本编辑, 高度计算, 正则匹配等待... 简便操作, 让你爽到爆!
	
	pod 'XHLaunchAd'					#开屏广告
	pod 'JQLaunchAdKit'					#开屏广告、启动广告解决方案-支持静态/动态图片广告/mp4视频广告\n 特性: 1.支持静态/动态图片广告. 2.支持mp4视频广告. 3.支持全屏/半屏广告. 4.支持网络及本地资源. 5.兼容iPhone和iPad. 6.支持广告点击事件. 7.支持自定义跳过按钮,添加子视图. 8.支持设置数据等待时间. 9.自带图片/视频下载,缓存功能. 10.支持预缓存图片及视频. 11.支持设置完成动画. 12.支持清除指定资源缓存. 13.支持LaunchImage 和 LaunchScreen.storyboard. 14.等等等...
	# pod 'AutoRotation'				#iOS 横竖屏切换解决方案https://www.jianshu.com/p/da1a03cc1f72

	# 组件化方式：URL路由，target-action ，protocol匹配
	# 组件化框架：MJRouter、CTMediator、BeeHive
	pod 'DCURLRouter'					# URL路由：通过自定义URL实现控制器之间的跳转
	# pod 'MGJRouter'					# URL路由：一个高效/灵活的 iOS URL Router(2015)
	# pod 'JLRoutes'					# URL路由：
	# pod 'HHRouter'					# URL路由：
	pod 'CTMediator'					# target-action：主要采用target-action的方式实现组件化，自身的功能独立，不需要依赖任何组件模块
	pod 'BeeHive'						# protocol class：阿里的BeeHive。BeeHive借鉴了Spring Service、Apache DSO的架构理念，采用AOP+扩展App生命周期API形式，将业务功能、基础功能模块以模块方式以解决大型应用中的复杂问题，并让模块之间以Service形式调用，将复杂问题切分，以AOP方式模块化服务。

	pod 'FLAnimatedImage'				# gif播放

	pod 'HMSegmentedControl'			#UISegmentedControl的高度可定制的下拉式更换件。
	pod 'WMZDropDownMenu'				#2022，🌹一个能几乎实现所有App各种类型筛选菜单的控件,可悬浮,目前已实现闲鱼/美团/Boss直聘/京东/饿了么/淘宝/拼多多/赶集网/美图外卖等等的筛选菜单,可以自由调用代理实现自己想组装的筛选功能和UI,且控件的生命周期自动管理,悬浮自动管理🌹
	pod 'WMZPageController'				#2022,分页控制器,替换UIPageController方案,具备完整的生命周期,多种指示器样式,多种标题样式,可悬浮,支持ios13暗黑模式(仿优酷,爱奇艺,今日头条,简书,京东等多种标题菜单) ，1.5.0版本后改动比较大,如需稳定请指定1.4.6
	pod 'JXCategoryView'				#2022,强大且易于使用的类别视图（分段控制、分段视图、分页视图、页面控制）（APP分类切换滚动视图）
	# pod 'JXSegmentedView'				#JXCategoryView的swift版本
	pod 'JXCategoryViewExt' 			#该库是对JXCategoryView的扩展及优化，目前的JXCategoryView版本1.6.1，JXCategoryViewExt版本1.2.0，基础库：pod 'JXCategoryViewExt' 或 pod 'JXCategoryViewExt/Core'
	pod 'JXPagingView/Pager'			#类似微博主页、简书主页、QQ联系人页面等效果。多页面嵌套，既可以上下滑动，也可以左右滑动切换页面。支持HeaderView悬浮、支持下拉刷新、上拉加载更多
	pod 'GKPageScrollView'				#(主要参考了JXPagingView，在他的基础上做了修改)iOS类似微博、抖音、网易云等个人详情页滑动嵌套效果
	pod 'GKPageSmoothView'				#(主要参考了JXPagingView，在他的基础上做了修改)iOS类似微博、抖音、网易云等个人详情页滑动嵌套效果
	pod 'SwipeTableView'				# 类似半糖、美丽说主页与QQ音乐歌曲列表布局效果，实现不同菜单的左右滑动切换，同时支持类似tableview的顶部工具栏悬停（既可以左右滑动，又可以上下滑动）。兼容下拉刷新，自定义 collectionview实现自适应 contentSize 还可实现瀑布流功能

	pod 'GKVideoScrollView'				# iOS仿抖音等上下滑动切换视图，使用方式类似UITableView，支持不同cell切换
	
	pod 'CYLTabBarController'			#一行代码实现 Lottie 动画TabBar，支持中间带+号的TabBar样式，自带红点角标，支持动态刷新
	pod 'lottie-ios'					#用于原生渲染After Effects矢量动画的iOS库(OC:2.5.3之前版本(, '~> 2.5.3')  swift:3.0之后)
	pod 'FSTextView'					#placeholder和最大字数
	pod 'JVFloatLabeledTextField'		#带有浮动标签的UITextField子类-灵感来自Matt D。史密斯的设计：http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?列表=用户
	
	pod 'ThinkVerb'						#iOS动画(链式语法)
	# pod 'TTGTextTagCollectionView'		#流式标签
	pod "TTGTagCollectionView"			#标签流显示控件，同时支持文字或自定义View(搜索历史、热门搜索)

	pod 'WMZTags'						#2019，多功能标签，具备增加，删除，多选，单选等功能。 链式编程实现，所有属性均可自定义（不维护了）
	pod 'WZLBadge'						#2020,角标
	pod 'RKNotificationHub'				#2018,添加未读消息数显示提醒，为任何UIView添加一个通知角标
	pod 'JSBadgeView'					#2020,添加带动画效果的未读消息数提醒
	pod 'PPBadgeView'					#iOS自定义Badge组件, 支持UIView, UITabBarItem, UIBarButtonItem

	pod 'SGQRCode'						#【iOS 原生二维码生成与扫描 -> 高仿微信】
	pod 'UICKeyChainStore'				# UICKeyChainStore是iOS、watchOS、tvOS和macOS上钥匙串的简单包装。使使用钥匙串API像NSUserDefaults一样简单。
	# ZBWUnifiedStorage					# iOS 统一存储库。支持内存、持久化、钥匙串等多种方式存储；支持过期时间设置；支持多应用隔离。

	pod 'dsBridge'						#三端易用的现代跨平台 Javascript bridge， 通过它，你可以在Javascript和原生之间同步或异步的调用彼此的函数.
	pod "XXShield"					#防止Crash
	pod 'LSSafeProtector'				#防止crash

	# pod 'SKCalendarView'				#一个高可控性的日历基础组件
	pod 'FSCalendar'					#一个完全可定制的iOS日历库，与Objective-C和Swift兼容
	pod 'CalendarLib'
	pod 'OttoKeyboardView'				#自定义键盘，支持数字、小数点、身份证、十六进制键盘、随机布局的安全数字键盘

	# pod 'TextFieldEffects'			#Swift版本，自定义UITextFields效果灵感来自Codrops，
	pod 'SwiftyStoreKit'				#swift版本 苹果内购助手
	
	
	pod 'ZQSearch'				#Search，SearchBar, 仿《饿了么》搜索栏。自定义搜索结果界面。搜索主页、模糊匹配、结果界面之间的状态切换。支持搜索历史和热门设置
	pod 'TOSearchBar'			#搜索框.UISearchBar的基本重新实现，主题更简单，动画更好
	pod 'PYSearch'				#一个优雅的搜索控制器，取代了iOS（iPhone和iPad）版UISearchController
	pod 'GKSliderView'			#iOS - 自定义一个滑杆控件

	# pod 'ZZFLEX', :git => 'https://github.com/tbl00c/ZZFLEX.git'#一个完善的iOS敏捷开发框架，基于UIKit实现，包含常用控件的链式API拓展、一个数据驱动的列表框架、一个事件处理队列。
									# https://github.com/tbl00c/ZZUIHelper
	pod 'ZJKitTool'			#ZJKitTool 可以更加便捷高效的添加UIKit控件,使用链式编程的思想，结合使用Masonry，以及其他工具类的简单使用,底层的封装.
	
	pod 'WMZTreeView'		#类似前端elementUI的树形控件,可自定义节点内容,支持无限极节点,可拖拽增删节点等等,非递归实现

	pod 'WMDragView'		# 2022，WMDragView致力于让任意View都可以自由悬浮拖曳（可拖动，悬浮按钮），类似于iOS的AssistiveTouch效果，微信浮窗。
	pod 'MNFloatBtn'		# 2020，iOS全局悬浮按钮，显示 / 切换当前API环境与版本 ，掌握和测试撕逼主动权~
	pod 'JhtFloatingBall'	# 2019，悬浮球/悬浮按钮/辅助按钮（类似于iOS系统自带的AssistiveTouch/京东/聚划算/建行等的辅助按钮）

	pod 'CWLateralSlide'	# 2019，一行代码集成0耦合侧滑抽屉！



	#热更新封装
	# pod 'MangoFix'				#https://github.com/yanshuimu/MangoFixUtil
	# pod 'MangoFixUtil'			#依赖MangoFix,封装补丁拉取、执行、设备激活、补丁激活完整流程,另外提供本地加密或未加密补丁执行、生成加密补丁等方法。


	#定位
	# pod 'AMapLocation-NO-IDFA'		#高德地图定位SDK 没有广告IDFA
	pod 'AMapLocation'				#高德地图定位SDK,带有IDFA
	pod 'BMKLocationKit'			#百度地图SDK,带有IDFA，定位


	#推送
	# pod 'JPush'					#极光推送，必选项
	#pod 'JCore'					# 可选项，也可由pod 'JPush'自动获取
	pod 'JCore', '~> 2.1.4-noidfa'	# 必选项
  	pod 'JPush', '~> 3.2.6'			#必选项

	#支付
	# pod 'WechatOpenSDK'			#微信SDK(.a静态库版本的OpenSDK,如果导入了友盟分享,直接替换掉友盟分享中的微信SDK即可 https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS_Static_Library_Difference.html)
									#iOS开发工具包（直接提供.a静态库文件的形式，2.0.2版本，包含支付功能）。https://developers.weixin.qq.com/doc/oplatform/Downloads/iOS_Resource.html

	# pod 'WechatOpenSDK-XCFramework'	#(iOS接入指南https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html)
	# pod  'AlipaySDK-iOS'			#支付宝支付(如果和友盟UMCSecurityPlugins冲突,请下载支付宝无UTDID.framework库的兼容版本)（https://opendocs.alipay.com/open/204/105295?pathHash=8cf05d19）
									#iOS 构建时可能发生 utdid 库相关的冲突，此时请改用 兼容版 SDK（https://opendocs.alipay.com/open/04km1h?pathHash=ac7ab8af）
									# 如果 iOS App 需要支持 arm64 架构模拟器上运行，使用 XCFramework 格式的 SDK
    
  
  	pod 'BabyBluetooth','~> 0.7.0'	#一个非常容易使用的蓝牙库,
  	pod 'AAChartKit'				# 图表库 极其精美而又强大的跨平台数据可视化图表框架,支持柱状图、条形图、OC (pod 'AAChartKit', :git => 'https://github.com/AAChartModel/AAChartKit.git')
  	pod 'Charts'					# 图表：折线图、柱状图、饼图	swift，不支持模拟器(i386)	
  	# pod 'DGCharts'					# Charts																		
  	pod 'PNChart'					#

  	pod 'LFPhoneInfo'				#iOS快速获取硬件信息(获取网络运营商、网络状态、设备局域网 IP、是否越狱https://github.com/muzipiao/LFPhoneInfo)

  	pod 'EBBannerView'				#只需一行代码：展示跟 iOS 系统一样的推送通知横幅，或展示一个自定义的 view。支持横屏、自动适应各种机型、自动声音/震动。
									#https://github.com/pikacode/EBBannerView
	pod 'HXRotationTool'			#iOS 屏幕旋转工具类，兼容iOS 16，兼容Xcode 13和Xcode 14。
	

	pod 'MLeaksFinder'				#检测内存泄漏,是结合FBRetainCycleDetector的一个库
	# pod 'FBRetainCycleDetector'		#检测循环引用,
	# pod 'FBMemoryProfiler'		#有助于分析iOS内存使用情况的iOS工具.一个iOS库，使用FBAllocationTracker和FBRetainCycleDetector提供开发人员工具，用于随着时间的推移浏览内存中的对象。
	
	pod 'AMLeaksFinder'				#一款用于自动检测项目中【控制器内存泄漏，View 内存泄漏】的小工具，支持 ObjC，Swift。(https://githubfast.com/liangdahong/AMLeaksFinder)
	# pod 'AMLeaksFinder', '2.2.5',  :configurations => ['Debug'] #
	# pod 'FBRetainCycleDetector', :git => 'https://githubfast.com/facebook/FBRetainCycleDetector.git', :branch => 'main', :configurations => ['Debug']	#如果想查看控制器的强引用链，可导入：Facebook 的 FBRetainCycleDetector 框架即可。

	pod 'DateTools'		#友好化时间，在iOS中简化了日期和时间
	pod 'VVManager'		#页面管理器.跳转指定页面,只需要知道viewController的Class名,如果有storyboard,则需要指定storyboard名.支持URLScheme跳转指定页面
	pod 'PureLayout'	#适用于iOS和OS X自动布局的终极API——简单得令人印象深刻，功能非常强大。与Objective-C和Swift兼容。
	

	
	# pod 'WMPlayer'		#视频播放器，AVPlayer的封装，继承UIView，想怎么玩就怎么玩。支持播放mp4、m3u8、3gp、mov，网络和本地视频同时支持。全屏和小屏播放同时支持。 cell中播放视频，全屏小屏切换自如。


	pod 'UIView+FDCollapsibleConstraints'	#构建以折叠视图及其相关布局约束，模拟“流布局”模式
	pod 'XLForm'	#OC,XLForm是最灵活、最强大的iOS库，用于创建动态表视图表单。与Swift和Obj-C完全兼容。
	# pod 'XLForm', :git => 'https://github.com/xmartlabs/XLForm.git' #使用xmartlabs主分支
	pod 'Eureka'	#是XLForm的Swift版本。

	# pod 'JhForm'	# JhForm - 自定义表单工具,更加简单,快捷的创建表单、设置页面 （https://github.com/iotjin/JhForm）
	
	pod 'CCExcelView'	#iOS ExcelView 自定义表格，支持设置左右向锁住的列数，支持列排序（排序规则自己实现）,支持设置topView，支持列表背景色，支持设置整行还是单元格点击的点击色(https://github.com/Jonas-o/CCExcelView)

	pod 'YTKKeyValueStore'	# A simple Key-Value storage tool, using Sqlite as backend.

	# pod 'HYBHelperKit'		#对常用的控件封装
	pod 'HYBUnicodeReadable'#解决打印日志对于Unicode编码不能正常显示中文的问题，只需要将文件导入工程，不需要引用，就能达到打印日志显示Unicode编码中文数据<要注释 NSObject+HYBUnicodeReadable.文件，否则会崩溃>
	pod 'HYBImageCliped'	#开源高效处理圆角的扩展，包括UIImageView、UIView、UIButton、UIImage的扩展API，可根据图片颜色生成图片带任意圆角，可给UIButton根据不同状态处理图片。所有生成图片都不会引起离屏渲染且不会引起离屏、图层混合，支持添加图片边框
	pod 'HYBMasonryAutoCellHeight'	#基于Masonry自动计算行高的库

	pod 'ZYCornerRadius'	#2018,避免为UIImageView设置圆角时触发离屏渲染所带来的性能损耗，两种工作方式：Category和UIImageView子类。

	pod 'GLEnvs'	#只需一行代码，即可在运行时快速切换App环境和变量，也可即时设置环境及变量(https://github.com/GL9700/GLEnvs)

	# pod 'LEGOImageEditor'	# 图片裁剪，支持大小缩放，设置大小，旋转角度，微调角度，裁剪图片

	pod 'ZJJTimeCountDown'	#iOS倒计时 验证码倒计时 秒杀倒计时 支持cell中的多个倒计时 支持自定义 样式多 支持时间差设置
	pod 'JFCitySelector'	#2020,轻量、灵活、可自定义的三级城市选择器(https://github.com/zhifenx/JFCitySelector)
	pod 'LJContactManager'	#LJContanctManager 是一款操作通讯录的类库，iOS 9 之前使用的是 AddressBook 和 AddressBookUI 系统库，iOS 9 之后使用苹果新推出的 Contacts 和 ContactsUI 框架，一行代码搞定通讯录。https://github.com/leejayID/LJContactManager
	pod 'GroupedData'		#GroupedData - 全网最好用的通讯录联系人排序算法，支持多语言索引排序,接入简单方便无耦合，只需Mode遵守Protocol即可实现排序（pod 更新至 0.0.1） https://github.com/ygf-git/GFGroupedData-master


	pod 'CRBoxInputView'	# 2023，短信验证码输入框，支持密文模式.该组件适用于短信验证码，密码输入框，手机号码输入框这些场景。建议使用前运行Demo。常用功能在Demo中都有体现【https://github.com/CRAnimation/CRBoxInputView】
	pod "JHVerificationCodeView"	# 2020，验证码输入框，验证码，code view，iOS验证码输入,密码输入框 【https://github.com/xjh093/JHVerificationCodeView】



end

def baidumap_ios #百度地图
	# iOS 定位
	#https://lbsyun.baidu.com/faq/api?title=ios-locsdk/guide/create-project/cocoapods-create
	#iOS定位SDK的Pod库的名称BMKLocationKit
	
	# iOS 地图
	#https://lbsyun.baidu.com/faq/api?title=iossdk/guide/create-project/cocoapods
	#iOS 基础地图SDK 的 Pod 库的名称为 BaiduMapKit
	#iOS 步骑行地图(已包含基础地图)SDK 的 Pod 库的名称为 BaiduWalkNaviKit
	#iOS 导航+步骑行地图SDK (已包含基础地图)的 Pod 库的名称为 BaiduNaviKit-All


	pod 'BMKLocationKit'			#百度地图SDK,带有IDFA，定位		
	pod 'BaiduMapKit', '6.5.8' # 默认集成全量包
	pod 'BaiduWalkNaviKit', '6.5.8' # 默认集成Base Map WalkNavi 组件
	pod 'BaiduNaviKit-All', '6.5.8' # 默认集成Base Map Navi WalkNavi组件
    # 可选组件
    # pod 'BaiduMapKit/Map', '6.5.8'    # 集成地图Map包
    # pod 'BaiduMapKit/Search', '6.5.8' # 集成地图Search包
    # pod 'BaiduMapKit/Utils', '6.5.8'  # 集成地图Utils包

end
def gaodemap_ios #高德地图

	#iOS 定位
	# https://lbs.amap.com/api/ios-sdk/guide/create-project/cocoapods

	# 基础SDK： AMapFoundationKit.framework
	pod 'AMaplocation'		#定位SDK，
	pod 'AMapsearch'		#地图SDK搜索功能，<AMapSearchKit>
	pod 'AMap3DMap'			#3D地图SDK，<MAMapKit>


	####### IDFA 版本
	# pod 'AMapLocation'			# 定位SDK，IDFA版本，
	# pod 'AMapSearch'				# 搜索功能，IDFA版本，<AMapSearchKit>
	# pod 'AMap2DMap'				# 2D地图SDK，IDFA版本，3D地图与2D地图不能同时使用，<MAMapKit>
	# pod 'AMap3DMap'				# 3D地图SDK，IDFA版本，3D地图与2D地图不能同时使用，<MAMapKit>
	# pod 'AMapNavi'				# AMapNavi，IDFA版本，已包含3D地图，无需单独引入3D地图

	####### NO IDFA 版本
	# pod 'AMapLocation-NO-IDFA'	# 定位SDK，NO-IDFA版本
	# pod 'AMapSearch-NO-IDFA'		# 搜索功能，NO-IDFA版本
	# pod 'AMap2DMap-NO-IDFA'		# 2D地图SDK，NO-IDFA版本，3D地图与2D地图不能同时使用
	# pod 'AMap3DMap-NO-IDFA'		# 3D地图SDK，NO-IDFA版本，3D地图与2D地图不能同时使用
	# pod 'AMapNavi-NO-IDFA'		# 导航SDK，NO-IDFA版本，已包含3D地图，无需单独引入3D地图


	# 备注： 
	# 1.pod 'AMapLocation' 命令还会引入基础 SDK(AMapFoundationKit.framework) !!!!!!!!!!!!!
	# 2.SystemConfiguration.framework、CoreTelephony.framework、Security.framework 是为了统计app信息使用。
	# 3.手动部署需要引入的资源文件包括：AMap.bundle，其中：AMap.bundle 在 MAMapKit.framework 包中，AMap.bundle资源文件中存储了定位、默认大头针标注视图等图片，可利用这些资源图片进行开发。
	# 4.2D地图和3D地图的资源文件是不同的，在进行SDK切换时，需要同时更换对应的资源文件。
	# 5.在TARGETS->Build Settings->Other Linker Flags 中添加-ObjC，字母 O 和 C 大写。
end


def noLonger_maintainLib # 不再维护的库
	# pod 'ChameleonFramework'			#不再维护!!!一个 iOS 的颜色框架
	# pod 'PKRevealController'			#不再维护!!!PKRevealController是一个令人愉快的iOS视图控制器容器，使您能够将多个控制器叠加在一起。
	# pod 'SlackTextViewController'		#不再维护!!!一个下拉式 UIViewController 子类，具有不断增长的文本输入视图和其他有用的消息功能
	pod 'IAPHelper'					#此回购协议不再维护!!!苹果内购助手,Apple 在购买应用时为 IAP 提供帮助
	# pod 'XYXFilterMenu'				#一个超级流畅的菜单筛选项，支持tableView和collectionView以及自定义输入范围模式，可以根据你的需要设定显示方式。
end


def douYinComment_iOS	#1.抖音视频转场动画,抖音左滑push进个人主页, 评论手势拖拽效果 , 视频播放, 边下边播, 预加载, TikTok 2.网易云iOS小组件Widget 3.铃声多多,上传铃声音频到库乐队(GarageBand) 4.微博主页、简书主页等。多页面嵌套列表分页滚动，上下滑动，左右滑动切换页面。类似TableView共用HeaderView悬浮,仿头条标签编辑,铃声多多音乐播放界面(豆瓣电影主页)。
	# pod 'TTCTool'
	# 或者只导入单个功能,https://github.com/tangtiancheng/DouYinComment
	pod 'TTCTool/TCCommentsPopView'	# 抖音评论效果
	pod 'TTCTool/TTCTransition'		# 抖音转场动画
	pod 'TTCTool/TTCPanPush'		# 抖音左滑进入个人主页
	pod 'TTCTool/TCViewPage'		# 分页
	pod 'TTCTool/TagChannelManager'	# 标签管理
end

def jiqimao_tools_ios	#机器猫工具库
	# ---------------------------------------------------------------------------------------
	# https://github.com/yangKJ/KJEmitterView
	# pod 'KJEmitterView'				#UIKit模块安装
	# pod 'KJEmitterView/Kit'			#UIKit 相关扩展
	# pod 'KJEmitterView/Foundation'	#Foundation模块安装
	# pod 'KJEmitterView/Language'		# 多语言模块
	# pod 'OpenCV'							
	# pod 'KJEmitterView/Opencv'		# 图片处理   Opencv图片模块该模块需要引入OpenCV库
	# pod 'KJEmitterView/LeetCode'		# LeetCode算法模块
	# pod 'KJEmitterView/Classes'		# 粒子效果模块
	pod 'ChainThen'						#UIKit快捷链式创建
	pod 'KJExceptionDemo'				#Crash防护
	pod 'Foggy'						# 自动防护异常崩溃(未捕获的Objective-C异常(NSException),通过向自己发送SIGABRT信号导致程序崩溃)
	# 说是不再维护 分离为新的库 KJCategories
	# ---------------------------------------------------------------------------------------

	########### 超实用开发加速工具收集, ios, '10.0' ###########
	pod 'KJCategories'					#该模块主要涵盖常用核心分类(1.0.0 中文) , '1.0.0'	
	pod 'KJCategories/KitExtension'		# UIKit
	pod 'KJCategories/Foundation'		# Foundation
	pod 'KJCategories/Customized'		# 自定义控件模块

	# pod 'OpencvQueen'					# Opencv模块,图片处理


	########### 网络请求库 ###########
	pod 'KJNetworkPlugin'				#一款纯OC版 批量 和 链式 插件版网络请求库

	# pod 'KJNetworkPlugin/Chain'		#

	########### 响应式插件版网络基础架构 swift ###########
	pod 'RxNetworks'
	# pod 'RxNetworks/MoyaNetwork'		# 导入网络架构API,该模块是基于Moya封装的网络API架构
	# pod 'RxNetworks/HandyJSON'			# 导入数据解析,
	# pod 'RxNetworks/MoyaPlugins'# 该模块主要就是基于moya封装网络相关插件
	# pod 'RxNetworks/MoyaPlugins/Cache'		#网络数据缓存插件
	# pod 'RxNetworks/MoyaPlugins/Loading'		#加载动画插件
	# pod 'RxNetworks/MoyaPlugins/Indicator'	#指示器插件
	# pod 'RxNetworks/MoyaPlugins/Warning'		#网络失败提示插件
	# pod 'RxNetworks/MoyaPlugins/Debugging'	#网络打印，内置插件
	# pod 'RxNetworks/MoyaPlugins/GZip'			#解压缩插件

	############ 基于 MVVM + RxSwift 搭建响应式数据绑定基础架构 ###########RxSwift扩展和MVVM组件项目架构
	pod 'Rickenbacker'
	# pod 'Rickenbacker/Adapter'			#导入项目响应式基类模块
	# pod 'Rickenbacker/Mediatror'		#导入组件化模块
	# pod 'Rickenbacker/HBDNavigationBar'	#导入导航栏基础模块
	# pod 'Rickenbacker/MJRefresh'		#导入自动刷新模块
	# pod 'Rickenbacker/DZNEmptyDataSet'	#导入空数据自动展示模块


	########### 多内核多功能播放器 ###########
	pod 'KJPlayer'
	# #KJPlayerDemo[视频支持格式：mp4、m3u8、wav、avi; 音频支持格式：midi、mp3]
	# pod 'KJPlayer/TryTime'		# vip尝试观看功能
	# pod 'KJPlayer/SkipTime'		# vip跳过片头片尾功能
	# pod 'KJPlayer/RecordTime'	# vip自动记忆播放功能[该功能大于跳过片头功能,简单讲就是该功能实现之后下次会直接从上次播放位置开始继续观看]
	# # 1.播放器模块
	# pod 'KJPlayer/MIDI'			# midi内核
	# pod 'KJPlayer/IJKPlayer'	# ijk内核
	# pod 'KJPlayer/AVPlayer/AVCore'	# av内核
	# pod 'KJPlayer/CustomView'	# 自定义UI
	# pod 'KJPlayer/Database'		# 数据库
	# # 2.功能区域模块
	# pod 'KJPlayer/AVPlayer/AVDownloader'	# AVPlayer内核扩展功能,边下边播边存分支
	# # pod 'KJPlayer/RecordTime'	# 记忆播放
	# pod 'KJPlayer/FreeTime'		# 尝鲜播放
	# # pod 'KJPlayer/SkipTime'		# 跳过片头片尾
	# pod 'KJPlayer/Cache'		# 缓存板块
	# pod 'KJPlayer/Screenshots'	# 视频截屏板块
	# pod 'KJPlayer/DynamicSource'	# 前支持3种内核：AVPlayer内核、MIDI内核、IJKPlayer内核
end

def tencent_QMUI_iOS_tool		#QMUIKit工具(使用:https://qmuiteam.com/ios/get-started)
	#https://qmuiteam.com/ios/documents		功能列表
	pod 'QMUIKit'				#QMUI iOS——致力于提高项目 UI 开发效率的解决方案
end

def table_iOS_OC #tableView 的封装
	pod 'RETableViewManager'		# 2016.UITableView的强大数据驱动内容管理器。允许轻松管理任何UITableView的内容，包括表单和列表.(https://github.com/romaonthego）
	pod 'ZLCellDataSource'			#mvvm，mvp的应用。为viewcontroller瘦身，把tableview和collectionview的datasource提取出来，可节省1/3的代码量。
	pod 'ZXTableView'				#快速、高效地构建TableView，节省80%以上重复代码，无需设置数据源和代理。(https://github.com/SmileZXLee/ZXTableView)
	pod 'ZXSlideSelectTableView'	#基于ZXTableView快速实现tableView的构造,快速、轻松地实现滑动选择tableView，支持各种自定义显示效果
	#HSSetTableViewController、TFTableview		#mvvm tableView封装
	# pod 'TFTableViewDataSource'			#mvvm tableView封装
	# pod 'RWTableView'			#参考mvvm tableView封装
	#IGListKitDemoOC
	pod 'YBHandyList'		#让 UITableView/UICollectionView 更加简单优雅,轻易实现列表动态化、模块化、MVVM 架构


	pod 'SJStaticTableView'			#2017.基于MVVM，用于快速搭建设置页，个人信息页表格等静态表格的框架
	pod 'HSSetTableViewController'	#2017.所有App都能用到的设置界面和个人信息框架，高度封装，外部只需要组装数据源。简单实用！分类+继承，0污染
	# pod "MTSetting", :git=>'https://github.com/MrTung/MTSetting.git'	#个人中心设置界面快速集成框架


	#LXB-HorizontalScroll	#横向滚动table列表
	pod 'UITableViewDynamicLayoutCacheHeight'	#2021,🖖高性能的自动计算采用 Autolayout 布局的 UITableViewCell 和 UITableViewHeaderFooterView 的高度，内部自动管理高度缓存。(参考自 FDTemplateLayoutCell)
	pod 'UITableView+FDTemplateLayoutCell'		#用于自动计算UITableViewCell高度的模板自动布局单元格,使用xib和storyboard在添加约束来自动计算行高的库

	pod 'MGSwipeTableCell'	#一个易于使用的UITableViewCell子类,允许显示具有各种过渡的可滑动按钮。左滑按钮

	pod 'IMYAOPTableView'	#无业务入侵,无逻辑入侵,外部察觉不到的UITableView/UICollectionView AOP框架,(具体可查看demo)

end

def collection_iOS_OC #collection布局
	pod 'IGListKit'							#一个数据驱动的UICollectionView框架，用于构建快速灵活的列表。
	pod 'HDCollectionView'					#2月前，数据驱动(data driven)的高效灵活列表。基于Flexbox，支持 悬浮、瀑布流、装饰view、横向滑动、分段布局、各种对齐方式。支持链式语法初始化。支持diff刷新，渐进式加载，动画更新UI
	pod 'FMLayoutKit'						#2020，08，自定义CollectionView的布局，可以快速实现瀑布流，标签布局，商品详情，各种电商首页等，悬停，拖拽排序等等功能丰富，可以穿插布局（垂直水平）
	pod 'ZLCollectionViewFlowLayout'		#瀑布流和标签用起来好像有问题，2022.03,基于UICollectionView实现，目前支持标签布局，列布局，百分比布局，定位布局，填充式布局，瀑布流布局等。支持纵向布局和横向布局，可以根据不同的section设置不同的布局，支持拖动cell，头部悬浮，设置section背景色和自定义section背景view，向自定义背景view传递自定义方法。功能强大，超过Android的recyclerview，实现了电影选座等高难度的布局。
	pod 'JQCollectionViewWaterfallLayout'	#瀑布流布局,<垂直和水平滚动方向>
	pod 'BMLongPressDragCellCollectionView'	#让你轻松实现类似支付宝的拖拽重排功能, 支持各种自定义操作。
	pod 'SDMovableCellCollectionView'		#这是一个可移动的集合视图。您可以通过拖放单元格来对数据进行排序。

	pod 'CHTCollectionViewWaterfallLayout'	#swift，瀑布流,<仅支持垂直滚动>，UICollectionView的瀑布（即类似Pinterest的）布局。
	pod 'CHTCollectionViewWaterfallLayout/ObjC'	# OC 版本，仅支持垂直滚动。 UICollectionView的瀑布（即类似Pinterest的）布局。
	
	pod 'JJCollectionViewRoundFlowLayout'	# JJCollectionViewRoundFlowLayout可设置CollectionView的BackgroundColor、Cell的对齐方式，可跟据用户Cell个数计算背景图尺寸，可自定义是否包括计算CollectionViewHeaderView、CollectionViewFootererView或只计算Cells。设置简单，可自定义背景颜色偏移，设置显示方向（竖向、横向）显示,不同Section设置不同的背景颜色，设置Cell的对齐方式，支持左对齐，右对齐，居中。
											# (OC：https://github.com/kingjiajie/JJCollectionViewRoundFlowLayout)
											# 2025.11.24使用简单，可用
	
	pod 'DYWaterFallFlowLayout'				# 可设置不同分组等高或等宽或分页的瀑布流



	# pod 'CollectionSwipableCellExtension', :git => 'https://github.com/KosyanMedia/CollectionSwipableCellExtension.git'	# swift，UICollectionView和UITableView的可刷按钮，左滑按钮


	# pod 'UICollectionView-ARDynamicHeightLayoutCell', :git => 'https://github.com/AugustRush/UICollectionView-ARDynamicHeightLayoutCell.git' #2015,用于计算自动布局UICollectionViewCell大小的简单类别。自动管理单元的大小缓存，自动失效，极大地提高了效率。
end

def cycle_banner_iOS # 轮播图
	pod 'SDCycleScrollView'				# 轮播图
	pod 'WMZBanner'						# 2021.10，cell偏移，好像还不支持masonary约束布局，最好用的轻量级轮播图+卡片样式+自定义样式,链式编程语法(可实现各种样式的轮播图,大多需要的功能都有)
	pod 'KJBannerView'					# 有点不好用，不如SDCycle用着好用，轮播图(看demo)
	pod 'KJBannerView/Downloader'		# KJBannerView 轮播图要配合这个库使用
	pod 'TYCyclePagerView'				# 轮播图，TYPageControl可修改大小
	pod 'ZYBannerView'					# 简单易用, 显示内容定制性强的可循环轮播控件. 可以实现类似淘宝商品详情中侧拉进入详情页的功能.
	pod 'EllipsePageControl'			# 椭圆形 长方形 PageControl 轮播图点
end

def autoLayout # 自动布局
	pod 'Masonry'						#布局
	pod 'SDAutoLayout'					#布局
	pod 'MyLayout'						#MyLayout是一套iOS界面视图布局框架。
end

def image_photo_ios	# 照片选择、图片浏览
	pod 'TZImagePickerController'	#照片选择器
	pod 'ZLPhotoBrowser'			#照片选择器(4.0.0版本以后由Swift重新编写，该库OC版本不再维护)
	# pod 'ZLPhotoBrowser-objc'		#照片选择器 (OC)
	pod 'HXPhotoPicker'				#照片选择器 
	pod 'HXPhotoPickerObjC'			#
	pod 'GKPhotoBrowser'			#iOS仿微信、今日头条等图片浏览器
	pod 'KNPhotoBrowser'			#图片浏览器(本地和网络) ,视频浏览器 (本地和网络), 无耦合性,自定义控件,资源路径保存和获取, 完美适配 iPhone 以及 iPad ,屏幕旋转功能.

	pod 'KSPhotoBrowser'			#一个带有交互式解雇动画的美丽照片浏览器。一个小而美的图片浏览器。
	
	# YBImageBrowser 会自动导入 YYImage库
	# pod 'YBImageBrowser'		#iOS 图片浏览器，#如果你需要支持 WebP,需要导入pod 'YYImage/WebP'
	# pod 'YBImageBrowser/Video'  #视频功能需添加
	# #去除 SDWebImage 的依赖（版本需 >= 3.0.4）
	# pod 'YBImageBrowser/NOSD'
	# pod 'YBImageBrowser/VideoNOSD'  //视频功能需添加

	pod 'JPImageresizerView'		#2024,一个专门裁剪图片、GIF、视频的轮子😋 简单易用、功能丰富☕️（高自由度的参数设定、支持旋转和镜像翻转、蒙版、压缩等），能满足绝大部分裁剪的需求。[https://github.com/Rogue24/JPImageresizerView]


	# pod 'XLPhotoBrowser+CoderXL'	#(不再维护)一个简单实用的图片浏览器,效果类似微信图片浏览器,支持弹出动画和回缩动画,支持多图浏览,支持本地和网络图片浏览,支持多种属性自定义(支持横竖屏)
end

def yyKit_tools # YYKit
	# pod 'YYKit'						#富文本,图片请求,模型转换
	# pod 'YYImage', :git => 'https://github.com/QiuYeHong90/YYImage.git'
	pod 'YYModel'					# — 高性能的 iOS JSON 模型框架。
	pod 'YYCache'					# — 高性能的 iOS 缓存框架。
	pod 'YYImage'					# — 功能强大的 iOS 图像框架。
	pod 'YYImage/WebP'				# => pod 配置并没有包含 WebP 组件, 如果你需要支持 WebP，可以在 Podfile 中添加 pod 'YYImage/WebP'。你可以调用 YYImageWebPAvailable() 来检查一下 WebP 组件是否被正确安装。
	pod 'YYWebImage'				# — 高性能的 iOS 异步图像加载框架。
	pod 'YYText'					# — 功能强大的 iOS 富文本框架。
	pod 'YYKeyboardManager'			# — iOS 键盘监听管理工具。
	pod 'YYDispatchQueuePool'		# — iOS 全局并发队列管理工具。
	pod 'YYAsyncLayer'				# — iOS 异步绘制与显示的工具。
	pod 'YYCategories'				# — 功能丰富的 Category 类型工具库。


end

def alertView_ios #弹窗
	pod 'LEEAlert'			#优雅的可自定义 Alert ActionSheet,只能同时显示一个弹窗(当前所有弹窗的controller是同一个,也就是说只能同时显示一个弹窗,不能同时显示多个)
	pod 'ACActionSheet'		#仿微信ActionSheet,系统actionSheet
	pod 'BRPickerView'		#选择器(日期,地址...)
	pod 'WMZDialog'			#弹窗，支持普通/微信底部/提示/加载框/日期/地区/日历/选择/编辑/分享/菜单/吐司/自定义弹窗等,支持多种动画,链式编程调用
	pod 'LSTPopView'		#iOS万能弹窗,可同时显示多个弹窗
	pod 'SSAlert'			#自带常用自定义弹窗，类型系统的UIAlertView,UIActionSheet。支持自定义动画。
	pod 'FWPopupViewOC'		#信手拈来的OC弹窗库：1、继承 FWPopupBaseView 即可轻松实现各种位置、动画类型的弹窗；2、新功能引导弹窗
	pod 'FWPopupView'		#swift版
	pod 'STPopup'			#STPopup为iPhone和iPad提供STPopupController，它的工作原理与弹出式UINavigationController相同。它用Objective-C编写，并与Swift兼容。
	pod 'SCLAlertView-Objective-C'	#美丽的动画警报视图。用Objective-C编写


	pod 'Popover.OC'		#一款优雅好用的类似QQ和微信消息页面的右上角微型菜单弹窗, 最低支持iOS6
	# pod 'FTPopOverMenu'	#类似QQ和微信消息页面的右上角微型菜单弹窗
	pod 'LMJDropdownMenu'	#一个简单好用的下拉菜单控件,类似QQ和微信消息页面的右上角微型菜单弹窗,<<<顶部会多一个按钮(btn)，莫名其妙，奇奇怪怪的感觉>>>
	pod 'KxMenu'			#类似QQ和微信消息页面的右上角微型菜单弹窗,https://github.com/kolyvan/kxmenu/
	pod "DXPopover"			#使用UIKit的弹出窗口模拟Facebook应用程序弹出窗口,类似QQ右上角item弹窗
	pod 'YBPopupMenu'		#2023， 快速集成popupMenu  【https://github.com/lyb5834/YBPopupMenu】


	# pod 'QBPopupMenu'		#无需使用图片文件的 iOS 弹出式菜单.它的外观类似于iOS3 的UIMenuController(UIMenuController-iOS3~iOS16)


	pod 'GKCover'			#一行代码显示遮罩视图，让你的弹窗更easy!
	#LPFGuidView			#新功能引导，根据传入的视图（UIView子类）精确定位高亮显示，并自动生成遮罩蒙版。不必自己计算位置(https://github.com/lpfRoc/LPFGuidView)
	#JMHoledView			#引导图,要填充孔的视图设计...
	
	
	pod 'CustomPopOverView'	#一款小巧灵活的自定义弹出视图, 可以做自定义AlertView、弹出窗口等等https://github.com/maltsugar/CustomPopOverView

	pod 'HWPanModal'		#HWPanModal 用于从底部弹出控制器（UIViewController），并用拖拽手势来关闭控制器。提供了自定义视图大小和位置，高度自定义弹出视图的各个属性。
	pod 'LNPopupController'	#一个用于将视图控制器显示为其他视图控制器弹出窗口的框架，就像Apple Music和Podcasts应用程序一样。


	pod 'TFDropDownMenu'	# 2019，下拉菜单选择器，多级下拉式菜单选项，下拉式左右分区选择菜单
	# pod 'ZHFilterMenuView'	# 2020，一款类似贝壳找房的通用房屋筛选控件！提供新房、二手房、租房的完整筛选功能实现！当然不仅仅局限用于房屋筛选，也可用于其他类型的筛选！【https://github.com/hi-zhouyn/ZHFilterMenuView】

end


def permission_ios # iOS权限判断
	#iOS 权限判断
	pod 'LBXPermission/Base'		# 
  	pod 'LBXPermission/Camera'		# 相机权限
	pod 'LBXPermission/Photo'			# 相册权限
	pod 'LBXPermission/Contact'		# 通讯录权限
	pod 'LBXPermission/Location'		# 定位权限
	pod 'LBXPermission/Reminder'			
	pod 'LBXPermission/Calendar'		# 日历权限
	pod 'LBXPermission/Microphone'
	pod 'LBXPermission/Health'
	pod 'LBXPermission/Net'
	pod 'LBXPermission/Tracking' 
	pod 'LBXPermission/Notification'	# 通知权限
	pod 'LBXPermission/Bluetooth'		# 蓝牙权限
end

def zf_player_ios #视频播放器 https://github.com/renzifeng/ZFPlayer
	pod 'ZFPlayer'							# 支持自定义任何播放器SDK和控制层
	# pod 'ZFPlayer', '~> 4.0'				# 只需使用播放器模板
	pod 'ZFPlayer/ControlView'				# 使用默认控件View
	pod 'ZFPlayer/AVPlayer'					# 使用AVPlayer只需将以下行添加到您的Podfile中：
	pod 'ZFPlayer/ijkplayer'				# 使用ijkplayer只需将以下行添加到您的Podfile中
end
def sj_videoPlayer #短视频播放器 可接入 ijkplayer aliplayer alivodplayer plplayer
	# Player with default control layer.
	pod 'SJVideoPlayer'
	# The base player, without the control layer, can be used if you need a custom control layer.
	pod 'SJBaseVideoPlayer'

	# # 如果网络不行安装不了, 可改成以下方式进行安装
	# pod 'SJBaseVideoPlayer', :git => 'https://gitee.com/changsanjiang/SJBaseVideoPlayer.git'
	# pod 'SJVideoPlayer', :git => 'https://gitee.com/changsanjiang/SJVideoPlayer.git'
	# $ pod update --no-repo-update   (不要用 pod install 了, 用这个命令安装)
end

def nav_iOS #导航栏nav
	pod 'HBDNavigationBar'	#2022，自定义UINavigationBar，用于在各种状态之间平稳切换，包括条形样式、条形色调颜色、背景图像、背景alpha、条形隐藏、标题文本属性、色调颜色、阴影隐藏...
	pod 'HBDStatusBar'		#状态栏

	pod 'YPNavigationBarTransition'	# 2022，类似微信 UINavigationBar 效果的切换方案，支持任意透明半透明图片背景等等不同样式的 UINavigationBar 的切换。

	pod 'ZXNavigationBarKit'		#2022，自定义导航条,比起系统UINavigationBar设置背景色，背景透明度更加方便
	pod 'ZXNavigationBar'			#灵活轻量的自定义导航栏，导航栏属于控制器view，支持导航栏联动，一行代码实现【导航栏背景图片设置、导航栏渐变、折叠、修改Item大小和边距、自定义导航栏高度、全屏手势返回、pop拦截、仿系统导航栏历史堆栈】等各种效果
	pod 'WRNavigationBar'			#OC，2021,超简单！！！ 一行代码设置状态栏、导航栏按钮、标题、颜色、透明度，移动等 
	pod 'JZNavigationExtension'		#nav
	# pod 'FDFullscreenPopGesture'	#UINavigationController的类别，用于启用iOS7+系统风格的全屏弹出手势,要下载下来，pod下来的代码不是最新的
	pod 'KMNavigationBarTransition'	#一个用来统一管理导航栏转场以及当 push 或者 pop 的时候使动画效果更加顺滑的通用库，并且同时支持竖屏和横屏。你不用为这个库写一行代码，所有的改变都悄然发生。
	pod "UINavigation-SXFixSpace"	#导航栏按钮位置偏移的解决方案,兼容iOS7~iOS15,可自定义间距

	pod "RTRootNavigationController"	# 2023，隐含地让每个视图控制器都有自己的导航栏

	# pod 'GKNavigationBarViewController' #2021,iOS自定义导航栏-导航栏联动，侵入性较高，推荐使用GKNavigationBar
	pod 'GKNavigationBar'			# 2024,iOS自定义导航栏 - 导航栏联动效果，GKNavigationBarViewController的分类实现，耦合度底，使用更便捷
	# pod 'GKNavigationBar/GestureHandle'	#只使用手势处理


	pod 'JNAPushPopCompletionBlock'	# 2019.UINavigationController Push/Pop UIViewController的完成block

	pod 'ZHHRootNavigationController' #自定义导航控制器，支持每个视图控制器独立导航栏，全屏滑动返回、可配置滑动范围，并支持右侧边缘左滑 push 控制器。
									  # iOS 13.0+
		
end

def autoCellHeight_iOS #计算cell高度
	
end

def pp_tools_iOS
	pod 'PPBadgeView'					#iOS自定义Badge组件, 支持UIView, UITabBarItem, UIBarButtonItem
	pod 'PPGetAddressBook'				#一句代码极速获取按A~Z分组精准排序的通讯录联系人 OC版( 已处理姓名所有字符的排序问题 )
	pod 'PPNumberButton'				#iOS中一款高度可定制性商品计数按钮(京东/淘宝/饿了么/美团外卖/百度外卖样式)
	pod 'PPTextField'					#UITextField各种限制，从此一个属性就能解决！比如：手机号（11位）、密码（只能数字和字母）、最大字符串（是否区分中英文）等等这样的限制,以及实时监测输入文字、结束编辑时回调等
	# pod 'PPNetworkHelper',:git => 'https://github.com/jkpang/PPNetworkHelper.git'	#AFNetworking 3.x 与YYCache封装
	pod 'PPCounter'

end

def animations_iOS	#动画，Animations
	
	pod "PulsingHalo"	#涟漪动画效果

	pod 'JHChainableAnimations'	# 具有强大的可链接式动画，并且语法易于读/写，但是它不支持多链式动画，仅支持UIView不支持直接操作CALayer,不支持参数参数自动补全
	# https://github.com/Lision/LSAnimator/blob/master/README_ZH-CN.md
	pod 'LSAnimator'			# OC，基于 JHChainableAnimations，在其上扩充可控维度（支持多链式动画），支持 CALayer 与参数自动补全等功能。
	# pod 'CoreAnimator'			# swift，基于 LSAnimator 上的简单封装，提供对于 Swift 更优雅的接口

	pod 'TLTransitions'			#2020，快速实现控制器的转场和View的快速popover显示，并支持自定义动画、手势退场【https://github.com/LoongerTao/TLTransitions】
	pod 'GXTransition'			#2020，iOS常用转场动画（包括自定义和OC自带转场动画）
end	


def um_Pods    #### def 方法名第一个字母不能是大写字母
	# UM  友盟 (升级指南:https://developer.umeng.com/docs/119267/detail/119534)
	# 集成流程 cocoapods:https://developer.umeng.com/docs/119267/detail/119508
	# =>							#删除工程中的UMAnalytics.framework，引入新版本UMCommon 
	pod 'UMCommon'					#！必须集成，由原来的UMCCommon变为了UMCommon(UMAnalytics.framework和UMCommon.framework合并为一个包：UMCommon.framework)
  	pod 'UMDevice'					#！必须集成

  	pod 'UMAPM'						#性能监控产品 关注crash数据需集成，原错误分析升级为独立产品U-APM（可选）
  	pod 'UMCSecurityPlugins'		#安全组件 如果和支付宝SDK产生冲突,请下载支付宝无UTDID.framework的兼容版本
 	pod 'UMShare/UI'				#由原来的UMCShare/UI变为了UMShare/UI  U-Share SDK UI模块（分享面板，建议添加）
 	pod 'UMShare/Social/WeChat'		#集成微信(完整版14.4M) 原为'UMCShare/Social/WeChat'
  #从2020年6月1日起该旧版本SDK会被微信限制使用正常分享功能（分享时会显示“未验证应用”）。因此U-Share已下线微信iOS精简版，且后续不再提供。
  #建议已使用微信iOS精简版的客户，后续使用微信iOS完整版，可以体验更多高级功能。
  #微信SDK:https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html

  	# 集成微信支付功能
  	# https://developer.umeng.com/docs/128606/detail/129467
 	#1.微信原生SDK有包含微信支付和不包含微信支付两个版本，友盟UShare微信分享组件中不包含微信支付模块，所以UShare SDK里的WXApiObject文件里没有PayReq对象
 	# 	iOS开发工具包（直接提供.a静态库文件的形式，2.0.2版本，包含支付功能）。(https://developers.weixin.qq.com/doc/oplatform/Downloads/iOS_Resource.html)
	#2、必须集成友盟分享微信完整版
	#3.用微信官方包含支付功能的库libWeChatSDK.a及相关的头文件：WxApiObject.h、WxApi.h和WechatAuthSDK.h替换掉UShare组件中同名的库文件和头文件
		#! 其他UShare相关库文件仍然需要添加至工程中，
		#!! linSocialOffcialWechat.a代表了微信完整版，
		#!!! libSocialWeChat.a代表了微信精简版（友盟微信完整版代码依赖精简版代码功能，但是不会出现只集成微信精简版“未验证应用“问题），这两个文件也必须要添加
#!!! 注意 用微信包含支付的库文件替换方式只能通过上述手动集成方式完成，因为自动集成方式这样替换会校验不通过，因此要想同时使用支付和分享功能，请您采用手动集成方式
   
   # pod 'UMShare/Social/QQ'		#集成QQ/QZone/TIM(完整版7.6M)，如果集成微信支付，必须手动集成并且使用微信完整版和QQ完整版
  	pod 'UMShare/Social/ReducedQQ'	#集成QQ/QZone/TIM(精简版0.5M) 原为'UMCShare/Social/ReducedQQ'
  	pod 'UMPush'					#原为'UMCPush' #集成友盟统计、推送SDK
  	pod 'UMLink'					#可选集成	 对应了智能超链产品U-Link，如想统计分享回流人数、分享新增用户指标则必选
  	pod 'UMABTest'					#可选集成 统计产品中ABTest功能
  	pod 'UMCCommonLog'				#基础库-日志库 开发阶段进行调试SDK及相关功能使用，可在发布 App 前移除
end

def jiguang_push #极光推送
	# 标准版
	pod 'JPush'					#必选项
	pod 'JCore'					#可选项，也可由pod 'JPush'自动获取
  # 无IDFA版
  # pod 'JPush', '3.2.6'		#必选项
  # pod 'JCore', '2.1.4-noidfa'	#必选项
	
end

def tx_IMSDK_UI #腾讯IM 含UI(https://cloud.tencent.com/document/product/269/37060)
	# # https://cloud.tencent.com/document/product/269/37060
	# # TUIKit 使用到了第三方静态库，这个设置需要屏蔽
	# # use_frameworks!
	# #TXIMSDK_TUIKit_live_iOS 使用了 *.xcassets 资源文件，需要加上这条语句防止与项目中资源文件冲突。
	# # install! 'cocoapods', :disable_input_output_paths => true  
	# # 集成聊天，关系链，群组功能
	# pod 'TXIMSDK_TUIKit_iOS'  
	# # 集成音视频通话、群直播，直播广场，默认依赖 TXLiteAVSDK_TRTC 音视频库
	# pod 'TXIMSDK_TUIKit_live_iOS'    
	# # 集成音视频通话、群直播，直播广场，默认依赖 TXLiteAVSDK_Professional 音视频库
	# # pod 'TXIMSDK_TUIKit_live_iOS_Professional'

# TUIKit视频通话(https://cloud.tencent.com/document/product/269/39167)
# 4.8.50 ~ 5.1.60 版本：TUIKit 组件默认集成了音视频通话 UI 组件和 TRTC 音视频库，默认支持音视频通话相关功能。
# 5.4.666 ~ 5.6.1200 版本：TUIKit 组件默认不再集成音视频通话 UI 组件和 TRTC 音视频库，音视频相关逻辑都移到了 TUIKitLive 组件里面，如果您需要使用音视频通话功能，您需要 pod 集成 TXIMSDK_TUIKit_live_iOS 。
# 5.7.1435 以上版本：TUIKit 组件默认不再集成音视频通话 UI 组件和 TRTC 音视频库，音视频相关逻辑都移到了 TUICalling 组件里面，如果您需要使用音视频通话功能，请参考 步骤2：集成 TUICalling 组件 。


	#TUIKit 从 5.7.1435 版本开始支持模块化集成，您可以根据自己的需求选择所需模块集成。
	#TUIKit 从 6.9.3557 版本开始新增了全新的简约版 UI 组件，之前版本 UI 组件依旧保留，我们称之为经典版 UI 组件
	# 防止 TUI 组件里的 *.xcassets 与您项目里面冲突。
	# install! 'cocoapods', :disable_input_output_paths => true #这句话要放在platform同级位置
	# use_frameworks! ## TUI 组件依赖了静态库，需要屏蔽此设置，如果报错，请参考常见问题说明。
	# use_frameworks! :linkage => :static #如果在某种情况下,需要使用use_frameworks!,则请使用cocoapods1.9.0及以上版本进行pod install
	# 请按需开启 modular headers，开启后 Pod 模块才能使用 @import 导入，简化 Swift 引用 OC 的方式。
  	# use_modular_headers!

	# # 集成聊天功能 主要用于收发和展示消息。
	# pod 'TUIChat'
	# # 集成会话功能 主要用于拉取和展示会话列表。
	# pod 'TUIConversation'
	# # 集成关系链功能 主要用于拉取和展示好友列表。
	# pod 'TUIContact'
	# # 集成群组功能 主要用于拉取和展示群信息。
	# pod 'TUIGroup'
	# # 集成搜索功能 主要用于搜索和展示会话或消息。（需要购买旗舰版套餐）
	# pod 'TUISearch' 
	# # 集成音视频通话功能 主要用于音视频通话。
	# pod 'TUICalling'
	# 			#腾讯云的音视频库不能同时集成,会有符号冲突,
	# 			#如果您使用了非TRTC版本的音视频库,建议pod集成 TUICalling/Professional版本,
	# 			#该版本依赖的 LiteAV_Professional 音视频库包含了音视频的所有基础能力。
	#    		腾讯实时音视频（Tencent Real-Time Communication，TRTC）

# 1.如果您直接 pod 'TUIChat'，不指定经典版或简约版，默认会集成两套版本 UI 组件。 
# 2. 经典版和简约版 UI 不能混用，集成多个组件时，您必须同时全部选择经典版 UI 或简约版 UI。
# 	例如，经典版 TUIChat 组件必须与经典版 TUIConversation、TUIContact、TUIGroup组件搭配使用。
# 	同理，简约版 TUIChat 组件必须与简约版 TUIConversation、TUIContact、TUIGroup 组件搭配使用。
# 3.如果您使用的是 Swift，请开启 use_modular_headers!，并将头文件引用改成 @import 模块名形式引用。

# TRTC：腾讯实时音视频服务
# pod 'TUICallKit'				# TXLiteAVSDK_TRTC 库
# pod 'TUICallKit/Professional'	# TXLiteAVSDK_Professional 库，Professional：专业的，Enterprise:企业
# 多人音视频房间 SDK （TUIRoomKit）

# 音视频通话（TUICallKit）
# TUICallKit 是腾讯云推出一款新的音视频通话 UI 组件，是 TUICalling 的升级版本，TUICallKit 体积更小，稳定性更好，也支持更多特性：
# TUIKit 主要功能介绍
# TUIKit 主要分为 TUISearch、TUIConversation、TUIChat、TUICallKit、TUIContact、TUIGroup 和 TUIOfflinePush 几个 UI 子组件，每个 UI 组件负责展示不同的内容。
# TUIChat 主要负责消息界面的展示。您还可以利用它直接发送不同类型的消息、对消息长按点赞/回复/引用、查询消息已读回执详情等。
# TUIContact 主要负责联系人的展示、权限设置等。
# TUIConversation 主要负责会话列表的展示和编辑。
# TUIGroup 主要负责群资料、群成员、群组权限的管理。
# TUISearch 主要负责本地搜索，支持搜索联系人、群聊、聊天记录。
# TUICallKit 主要负责语音、视频通话。
# TUIOfflinePush 主要负责离线推送消息展示。

end

def tx_IMSDK_UI_Classic # 腾讯IM 含UI 经典版 (https://cloud.tencent.com/document/product/269/37060)
	# # 防止 TUIKit 组件里的 *.xcassets 与您项目里面冲突。
	# install! 'cocoapods', :disable_input_output_paths => true #这句话要放在platform同级位置

	# # 从 7.1 版本开始，TUIKit 组件依赖动态库，需要开启此设置。如果您不升级到 7.1 及以后，可以保持关闭。
 	# # use_frameworks!
 	# # 请按需开启 modular headers，开启后 Pod 模块才能使用 @import 导入，简化 Swift 引用 OC 的方式。
 	# # use_modular_headers!

 	# # 集成聊天功能
	# pod 'TUIChat/UI_Classic' 
	# # 集成会话功能
	# pod 'TUIConversation/UI_Classic'
	# # 集成关系链功能
	# pod 'TUIContact/UI_Classic'
	# # 集成群组功能
	# pod 'TUIGroup/UI_Classic' 
	# # 集成搜索功能（需要购买旗舰版套餐）
	# pod 'TUISearch/UI_Classic' 
	# # 集成离线推送
	# pod 'TUIOfflinePush'
	# # 集成音视频通话功能
	# pod 'TUICallKit'
	  
	# # 集成投票插件，从 7.1 版本开始支持
	# pod 'TUIPollPlugin'
	# # 集成群接龙插件，从 7.1 版本开始支持
	# pod 'TUIGroupNotePlugin'
	# # 集成翻译插件，从 7.2 版本开始支持（需开通增值功能，请联系腾讯云商务开通）
	# pod 'TUITranslationPlugin'  
	# # 集成会话分组插件，从 7.3 版本开始支持
	# pod 'TUIConversationGroupPlugin'
	# # 集成会话标记插件，从 7.3 版本开始支持
	# pod 'TUIConversationMarkPlugin'


	# 从 7.1 版本开始，新增了 TUIKit 插件（TUIXXXPlugin），TUIKit 插件是动态库依赖，需要开启此设置。
	# 如果您不依赖 TUIKit 插件，该设置可以保持关闭。
	# use_frameworks!
	# 请按需开启 modular headers，开启后 Pod 模块才能使用 @import 导入，简化 Swift 引用 OC 的方式。
	# use_modular_headers!

	# 集成聊天功能
	pod 'TUIChat/UI_Classic' 
	# 集成会话功能
	pod 'TUIConversation/UI_Classic'
	# 集成关系链功能
	pod 'TUIContact/UI_Classic'
	# 集成群组功能
	pod 'TUIGroup/UI_Classic' 
	# 集成搜索功能（需要购买旗舰版套餐）
	pod 'TUISearch/UI_Classic' 
	# 集成音视频通话功能
	pod 'TUICallKit'
	  
	# 集成投票插件，从 7.1 版本开始支持
	pod 'TUIPollPlugin'
	# 集成群接龙插件，从 7.1 版本开始支持
	pod 'TUIGroupNotePlugin'
	# 集成翻译插件，从 7.2 版本开始支持（需开通增值功能，请联系腾讯云商务开通）
	pod 'TUITranslationPlugin'  
	# 集成会话分组插件，从 7.3 版本开始支持
	pod 'TUIConversationGroupPlugin'
	# 集成会话标记插件，从 7.3 版本开始支持
	pod 'TUIConversationMarkPlugin'
	# 集成语音转文字插件，从 7.5 版本开始支持
	pod 'TUIVoiceToTextPlugin'
	# 集成客服插件，从 7.6 版本开始支持
	pod 'TUICustomerServicePlugin'
	# 集成消息推送插件，从 7.6 版本开始支持
	pod 'TIMPush'

end

def tx_IMSDK_UI_Minimalist  # 腾讯IM 含UI 简约版 (https://cloud.tencent.com/document/product/269/37060)
	# 集成聊天功能
	pod 'TUIChat/UI_Minimalist' 
  # 集成会话功能
	pod 'TUIConversation/UI_Minimalist'
  # 集成关系链功能
	pod 'TUIContact/UI_Minimalist'
  # 集成群组功能
	pod 'TUIGroup/UI_Minimalist' 
  # 集成搜索功能（需要购买旗舰版套餐）
	pod 'TUISearch/UI_Minimalist' 
  # 集成离线推送
	pod 'TUIOfflinePush'
  # 集成音视频通话功能
	pod 'TUICallKit'

  # 集成翻译插件，从 7.2 版本开始支持（需开通增值功能，请联系腾讯云商务开通）
	pod 'TUITranslationPlugin'

end

def tx_IMSDK_NoUI #腾讯IM 不含UI(https://cloud.tencent.com/document/product/269/32675)
	pod 'TXIMSDK_iOS'							#基础版 SDK，原有标准版

	pod 'TXIMSDK_Plus_iOS'						#增强版 SDK，原有精简版
	# pod 'TXIMSDK_Plus_Swift_iOS'				
	# pod 'TXIMSDK_Plus_iOS_Bitcode'				#增强版 bitcode 版本 SDK

	pod 'TXIMSDK_Plus_iOS_XCFramework'			#增强版 xcframework 版本 SDK
	# pod 'TXIMSDK_Plus_Swift_iOS_XCFramework'
	# pod 'TXIMSDK_Plus_iOS_Bitcode_XCFramework'	#增强版 xcframework 版本 SDK（支持 bitcode）


	pod 'TXIMSDK_Plus_Pro_iOS'					#增强版 Pro SDK,

# 在 SDK 体积和安装包增量上，增强版与基础版相比有大幅度缩减。
# 在 SDK 功能支持上，增强版与基础版相比提供了更多新功能特性。
# 后续新功能开发，只在增强版上提供支持；基础版后续只做例行维护与现有问题修复
# SDK 从 6.8 版本开始，发布增强版 Pro，支持网络层双线路加速，提供更强的网络抗性。

# => 				对比项				基础版 						增强版
# SDK 体积 		framework大小			57.7MB						11.2MB
# app 体积 		ipa增量					2.1MB						1.1MB
#

end

def tx_IM_DevelopPods	#https://cloud.tencent.com/document/product/269/37060
# Pods 集成（方式一） 适合无源码修改时的集成:
# 	优点是： 当 TUIKit 有版本更新时您只需再次 Pod update 即可完成更新。
# 	缺点是： 当您有源码修改时，使用 Pod update 更新时，新版本的 TUIKit 会覆盖您的修改。
# DevelopPods 本地集成（方式二） 适合有涉及源码自定义修改的客户：
# 	优点是： 当您有自己的 git 仓库时，可以跟踪修改，并且修改源码后，使用 Pod update 更新（其他非本地集成 Pod）时，不会覆盖您的修改。
# 	缺点是： 您需要手动从 TUIKit 源码 覆盖您本地 TUIKit 文件夹进行更新。

	# 注意:使用本地集成方案时，如需升级时需要从  https://github.com/TencentCloud/TIMSDK/tree/master/iOS/TUIKit 
	# 获取最新的组件代码，放置在本地指定目录下(覆盖本地目录)如/TIMSDK/ios/TUIKit/TUICore
	# 注意:当私有化修改和远端有冲突时，需要手动合并，处理冲突。
	# 注意：TUIKit插件需要依赖TUICore的版本 务必确保插件版本和"../TUIKit/TUICore/TUICore.spec"中的spec.version一致


# 方式2：DevelopPods源码集成（有源码修改时推荐）#https://cloud.tencent.com/document/product/269/37060
# 	1. 从 GitHub 下载 TUIKit 源码。直接拖入您的工程目录下: TIMSDK/iOS/TUIKit
# 	2. 修改您Podfile中每个组件的本地路径， 路径修改为TUIKit文件夹相对您工程Podfile文件的路径 
# 如 Demo中的  pod 'TUICore', :path => "../TUIKit/TUICore"
# 说明： 示例图片中的TUIKit文件夹位于 Podfile的 上一层级（父目录），此时 我们使用 pod 'TUICore', :path => "../TUIKit/TUICore"
# ---------------------------------------------------------------------------------------
# 其他相对路径的表示如下：
# 父目录： pod 'TUICore', :path => "../TUIKit/TUICore"
# 当前目录： pod 'TUICore', :path => "TUIKit/TUICore"				# 经实践 当前目录 TUIKit前面不能加 /
# 子目录：  pod 'TUICore', :path => "./TUIKit/TUICore"
# ---------------------------------------------------------------------------------------
# 使用 DevelopPods源码集成 时，不能将文件拖入项目(不能使用copy if need)，直接将文件夹放到项目目录中，然后 path 中写对路径就行了，
# 使用 DevelopPods源码集成 时，如果将文件拖入了项目，会报错：文件重复定义【Duplicate interface definition for class】



# 必须含有 .podspec  文件才能使用DevelopPods源码集成方式,
  pod 'TUICore', :path => "../TUIKit/TUICore"
  pod 'TIMCommon', :path => "../TUIKit/TIMCommon"
  pod 'TUIChat', :path => "../TUIKit/TUIChat"
  pod 'TUIConversation', :path => "../TUIKit/TUIConversation"
  pod 'TUIContact', :path => "../TUIKit/TUIContact"
  pod 'TUIGroup', :path => "../TUIKit/TUIGroup"
  pod 'TUISearch', :path => "../TUIKit/TUISearch"
  
  # 注意: TUIKit插件需要跟随TUICore的版本
  # 需要确保插件版本和"../TUIKit/TUICore/TUICore.spec"中的spec.version一致
  pod 'TUIPollPlugin', '7.6.5011'					#集成投票插件
  pod 'TUIGroupNotePlugin', '7.6.5011'				#集成群接龙插件
  pod 'TUITranslationPlugin', '7.6.5011'			#集成翻译插件
  pod 'TUIConversationGroupPlugin', '7.6.5011'		#集成会话分组插件
  pod 'TUIConversationMarkPlugin', '7.6.5011'		#集成会话标记插件
  pod 'TIMPush', '7.6.5011'							#集成消息推送插件
  
  # 其他 Pod，
  #备注： 注意！！！！！
  #TUICallKit/Professional 和 TUIRoomKit 同时集成会报错：The 'Pods-AnBao' target has frameworks with conflicting names: txsoundtouch.xcframework and txffmpeg.xcframework.
  #TUICallKit 和 TUIRoomKit 同时集成会 不会报错.
  pod 'TUICallKit/Professional'				# 集成音视频通话功能
  # pod 'TUIRoomKit' 						#最低版本需要iOS 13，多人音视频房间 SDK
  # pod 'MJRefresh'
  # pod 'Masonry'
  pod 'TPNS-iOS-Extension' # 移动推送扩展库
  pod 'TPNS-iOS'          #, '~> 版本'  #如果不指定版本则默认为本地 pod TPNS-iOS 最新版本



end


def zhibo_anmiation_mp4_ios #直播间送礼物动画 .mp4格式，这个用不了，完全不知道怎么用
	pod 'FelgoIOS', :git => 'https://github.com/FelgoSDK/FelgoIOS.git' #将Felgo与现有的iOS应用程序集成
end



def method_name # !!!!!!方法名称不能以大写字母开头!!!!!!!!!!!!
	
end



# Pods for LSProjectTool
target 'LSProjectTool' do 								# 项目工程名
	  # tx_IMSDK_UI														# 腾讯IM(含UI库)
    all_Pods				#
    um_Pods					# 友盟
    yyKit_tools				# YYKit
    jiqimao_tools_ios		# 工具库
    tencent_QMUI_iOS_tool	# 工具
    pp_tools_iOS			#
    image_photo_ios			# 照片选择、图片浏览
    permission_ios			# iOS权限判断
    alertView_ios			# 弹窗
    zf_player_ios			# 支持自定义任何播放器SDK和控制层
    table_iOS_OC			# tableView封装
    collection_iOS_OC		# collectionView布局
    animations_iOS			# 动画
    nav_iOS					# 自定义nav
    autoCellHeight_iOS		# 自动计算cell的高度
    sj_videoPlayer			# 短视频播放器
    douYinComment_iOS		# 仿抖音功能



    # zhibo_anmiation_mp4_ios								# 直播间送礼物动画 .mp4格式
    noLonger_maintainLib									# 不再维护的库



  target 'LSProjectToolTests' do
    inherit! :search_paths
    # Pods for testing
  end
  target 'LSProjectToolUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

install! 'cocoapods', #这些配置通常使用默认值即可
  :clean => true, #安装过程中清理未使用的文件，删除podspec和项目支持的平台指定的pod未使用的任何文件
  :deterministic_uuids => true, #为Pods项目生成确定的UUID，这有助于保持项目文件的稳定性
  :integrate_targets => true, #将已安装的pod集成到你的Xcode项目中。如果设为false，Pod会被下载但不会集成到项目中
  :warn_for_unused_master_specs_repo => false, #屏蔽关于未使用master specs仓库的警告
  :lock_pod_sources => false #经常修改pod库中的文件，可以将 :lock_pod_sources 设为 false 来避免频繁的解锁提示

# 常用配置项说明：
# clean：是否清理未使用的文件，默认true
# deterministic_uuids：是否生成确定性UUID，默认true
# integrate_targets：是否将pod集成到项目中，默认true
# lock_pod_sources：是否锁定pod源文件，默认true
# warn_for_unused_master_specs_repo：是否显示未使用master仓库警告



#以下这段代码是CocoaPods的post_install钩子，用于在pod安装完成后修改项目的构建设置
# 代码功能详解：
# 1）.post_install钩子：在CocoaPods完成依赖安装后自动执行
# 2）.遍历所有target：对项目中的每个pod目标进行配置
# 3）.设置排除架构：清除了模拟器架构排除列表，解决M1芯片兼容性问题
# 	  'EXCLUDED_ARCHS[sdk=iphonesimulator*]' = '' 确保模拟器能正常运行
#     架构兼容性修复，这个设置清除了模拟器架构排除列表，特别适合解决M1/M2芯片Mac上的模拟器运行问题
# 4）.统一部署目标：将所有pod的最低iOS版本设置为11.0,避免不同pod库使用不同iOS版本导致的编译冲突
#     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
#     将所有pod库的最低iOS版本统一设置为11.0，避免不同库使用不同版本导致的编译冲突
# 使用位置：
# 这段代码应该放在Podfile文件的末尾，在所有target定义和install配置之后。

#6.
# post_install do |installer|
#     installer.pods_project.targets.each do |target|
#         target.build_configurations.each do |config|            
#             config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
#             config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
#             config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
#             config.build_settings['ENABLE_BITCODE'] = "NO"
#             config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "11.0"
#         end
#     end
# end

# 5.
	# #不管是静态库还是动态库,不管是手动集成还是cocoapods集成,只要有OC和Swift混编,打包出来的XCFramework,集成方都有可能报错,找不到类或者方法,
	# #这个问题找了很久,终于在github上看到解决方案:
	# #集成方需要在podfile最下面添加设置
	# post_install do |installer|
  	# 	installer.pods_project.targets.each do |target|
    # 		target.build_configurations.each do |config|
    # 			config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    # 		end
	# 	end
	# end


# 4.
	# post_install do |installer|
  	# 	# 调试flutter时打开
	# 	#  flutter_post_install(installer) if defined?(flutter_post_install)
  
  	# 	installer.pods_project.targets.each do |target|
    # 		target.build_configurations.each do |config|
    
    #  			config.build_settings['ENABLE_BITCODE'] = 'NO'
      
    #  			# 同步 pod 库的最低支持版本为 11.0
    #  			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      
    # 			config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
    #  			config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      
	# 			#config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""

    # 			# pod 也要添加“模拟器排除 arm64 支持”
    # 			config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"

   	# 			# 修复 Xcode 15 上，ios 14及以下版本运行时崩溃的问题
	# 			xcode_version = `xcrun xcodebuild -version | grep Xcode | cut -d' ' -f2`.to_f
    # 				if xcode_version ≥ 15
    #     				config.build_settings["OTHER_LDFLAGS"] = "$(inherited) -Wl, -ld_classic"
    # 				end
      
    # 			# 修复 Xcode 14 中，Pod 工程中的 Bundle target 签名报错的问题
    # 			config.build_settings["CODE_SIGN_IDENTITY"] = ""
      
	# 		#	if target.name.eql?('SnapKit')
	# 		#	libraries = config.build_settings['OTHER_LDFLAGS']
	# 		#	config.build_settings['OTHER_LDFLAGS'] = "#{libraries} -lswiftCoreGraphics"
	# 		#	libraryPath = config.build_settings['LIBRARY_SEARCH_PATHS']
	# 		#	config.build_settings['LIBRARY_SEARCH_PATHS'] = "#{libraryPath} $(SDKROOT)/usr/lib/swift"
	# 		#	end

    # 		end
  	# 	end
	# end

# 3.
# (File not found: ../libarclite_iphonesimulator.a)
# xcode 14.3更新后arc路径缺失导致pod的引用路径全部无法正常找到。这里需要重新创建该路径及文件或者将报错的 Cocopods 引入的库的最低版本改为 iOS 11.0即可。
	post_install do |installer|
  		installer.pods_project.targets.each do |target|
    		target.build_configurations.each do |config|
    			config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = ''
      			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    		end
  		end
	end
# 2.
    # post_install do |installer|
  	# 	installer.generated_projects.each do |project|
    # 		project.targets.each do |target|
    #     		target.build_configurations.each do |config|
    #         		config.build_settings['CODE_SIGN_IDENTITY'] = ''
    #      		end
    # 		end
  	# 	end
	# end
# 1.
	# post_install do |installer|
  	# 	installer.pods_project.targets.each do |target|
    # 		target.build_configurations.each do |config|
    #   			deployment_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
    #   			if !deployment_target.nil? && !deployment_target.empty? && deployment_target.to_f < 11.0
    #     			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    #   			end
    # 		end
  	# 	end
	# end


#如果：
#报错：The 'Pods-xx' target has transitive dependencies that include statically linked binaries: 
# 报错：“Pods xx ”目标具有可传递的依赖项，其中包括静态链接的二进制文件：
# 解决方法：1.在podfile中加入下面的代码
# pre_install do |installer|
#   # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
#   Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
# end

#再次执行pod install之后成功。
#引用swift库时需要把#import改为@import
#@import XXXX;

# 解决方法：2.使用：use_frameworks! :linkage => :static






