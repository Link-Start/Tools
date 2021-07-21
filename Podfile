
source 'https://github.com/CocoaPods/Specs.git'			#知名依赖库的来源地址
platform :ios, '9.0'																#平台ios,版本9.0 #取消对本行的注释以定义项目的全局平台
inhibit_all_warnings!																#忽略引入库的所有警告
# use_frameworks!																		#如果您不使用swift并且不想使用动态框架，请对本行进行注释。


#使用多target 可以用下面这样定义,避免重复书写代码
def all_Pods
	# 常用
	pod 'AFNetworking'											#网络请求
	pod 'AFNetworking+RetryPolicy'					#增加了为使用AFNetworking提出的请求设置重试逻辑的能力
	pod 'DZNEmptyDataSet'										#空白占位图
	pod 'Masonry'														#布局
	pod 'SDAutoLayout'											#布局
	pod 'SDCycleScrollView'									#轮播图
	pod 'SDWebImage'												#请求图片
	pod 'MBProgressHUD'
	pod 'IQKeyboardManager'									#输入框键盘管理iOS8 and later
	pod 'MJExtension'												#数据模型转换
	pod 'MJRefresh'													#刷新
	pod 'ReactiveObjC'											#RAC
	pod 'YYKit'															#富文本,图片请求,模型转换

	pod 'TZImagePickerController'						#照片选择器
	pod 'ZLPhotoBrowser'										#照片选择器(该库OC版本不再维护)
	pod 'HXPhotoPicker'											#照片选择器
	pod 'GKPhotoBrowser'										#iOS仿微信、今日头条等图片浏览器
	# pod 'XLPhotoBrowser+CoderXL'						#一个简单实用的图片浏览器,效果类似微信图片浏览器,支持弹出动画和回缩动画,支持多图浏览,支持本地和网络图片浏览,支持多种属性自定义(支持横竖屏)
	pod 'YTKNetwork'												#YTK 网络请求
	pod 'XHLaunchAd'												#开屏广告

	pod 'BRPickerView'											#选择器(日期,地址...)
	pod 'WMZDropDownMenu'										#筛选菜单,可悬浮,目前已实现闲鱼/美团/Boss直聘/京东/饿了么/淘宝/拼多多/赶集网/美图外卖等等的筛选菜单
	pod 'WMZDialog'													#弹窗，支持普通/微信底部/提示/加载框/日期/地区/日历/选择/编辑/分享/菜单/吐司/自定义弹窗等,支持多种动画,链式编程调用
	pod 'LSTPopView'												#iOS万能弹窗
	pod 'CYLTabBarController'								#一行代码实现 Lottie 动画TabBar，支持中间带+号的TabBar样式，自带红点角标，支持动态刷新
	pod 'FSTextView'                      	#placeholder和最大字数
	pod 'JXCategoryView'                  	#segment
	pod 'Popover.OC'                      	#一款优雅好用的类似QQ和微信消息页面的右上角微型菜单弹窗, 最低支持iOS6
	pod 'ThinkVerb'                       	#iOS动画(链式语法)
	#pod 'TTGTextTagCollectionView'       	#流式标签(搜索历史、热门搜索)
	# pod "TTGTagCollectionView"						#标签流显示控件，同时支持文字或自定义View
	pod 'WZLBadge'                        	#角标
	pod 'SGQRCode'													#【iOS 原生二维码生成与扫描 -> 高仿微信】
	pod 'ACActionSheet'											# 仿微信ActionSheet
	pod 'UICKeyChainStore'									# UICKeyChainStore是iOS、watchOS、tvOS和macOS上钥匙串的简单包装。使使用钥匙串API像NSUserDefaults一样简单。
	 
	pod 'dsBridge'													#三端易用的现代跨平台 Javascript bridge， 通过它，你可以在Javascript和原生之间同步或异步的调用彼此的函数.
	# pod "XXShield"													#防止Crash
	# pod 'LSSafeProtector'										#防止crash
	pod 'PPGetAddressBook'									#一句代码极速获取按A~Z分组精准排序的通讯录联系人 OC版( 已处理姓名所有字符的排序问题 )


	#定位
	pod 'AMapLocation-NO-IDFA'            	#高德地图定位SDK 没有广告IDFA
	#pod 'AMapLocation'                   	#高德地图定位SDK,带有IDFA
	pod 'BMKLocationKit'                  	#百度地图SDK,带有IDFA
	#推送
	pod 'JPush'                           	#极光推送
	#支付
	# pod 'WechatOpenSDK'                 	#微信SDK
	# pod  'AlipaySDK-iOS'									#支付宝支付
  
  
 
  
	#iOS 权限判断
	pod 'LBXPermission/Base'							# 
  pod 'LBXPermission/Camera'						# 相机权限
  pod 'LBXPermission/Photo'							# 相册权限
  pod 'LBXPermission/Contact'						# 通讯录权限
  pod 'LBXPermission/Location'					# 定位权限
  pod 'LBXPermission/Reminder'			
  pod 'LBXPermission/Calendar'					# 日历权限
  # pod 'LBXPermission/Microphone'
  # pod 'LBXPermission/Health'
  # pod 'LBXPermission/Net'
  # pod 'LBXPermission/Tracking' 
  # pod 'LBXPermission/Notification'			# 通知权限
  # pod 'LBXPermission/Bluetooth'					# 蓝牙权限


end

def um_Pods    #### def 方法名第一个字母不能是大写字母
	# UM  友盟
	pod 'UMCommon'                        #必须集成，由原来的UMCCommon变为了UMCommon
  pod 'UMDevice'                        #必须集成
  pod 'UMAPM'                           #性能监控产品 关注crash数据需集成，原错误分析升级为独立产品U-APM（可选）
  pod 'UMCSecurityPlugins'              #安全组件
 	pod 'UMShare/UI'               				#由原来的UMCShare/UI变为了UMShare/UI  U-Share SDK UI模块（分享面板，建议添加）
  pod 'UMShare/Social/WeChat'           #集成微信(完整版14.4M) 原为'UMCShare/Social/WeChat' 
  pod 'UMShare/Social/ReducedQQ'        #集成QQ/QZone/TIM(精简版0.5M) 原为'UMCShare/Social/ReducedQQ'
  pod 'UMPush'                          #原为'UMCPush' #集成友盟统计、推送SDK
  pod 'UMLink'   												#可选集成	  智能超链产品
  pod 'UMABTest'  											#可选集成   统计产品中ABTest功能
  pod 'UMCCommonLog'										#基础库-日志库 开发阶段进行调试SDK及相关功能使用，可在发布 App 前移除
end  

def jiqimao_Pods	#机器猫工具库
	# pod 'KJEmitterView'											#UIKit模块安装
	# pod 'KJEmitterView/Kit'									#UIKit 相关扩展
	# pod 'KJEmitterView/Foundation'					#Foundation模块安装
	# pod 'KJEmitterView/Language' 						# 多语言模块
	# pod 'OpenCV'							
	# pod 'KJEmitterView/Opencv'   						# 图片处理   Opencv图片模块该模块需要引入OpenCV库
	# pod 'KJEmitterView/LeetCode'  					# LeetCode算法模块
	# pod 'KJEmitterView/Classes'  						# 粒子效果模块
	# pod 'KJEmitterView/Control'							# 自定义控件模块
end




# Pods for LSProjectTool
target 'LSProjectTool' do 								# 项目工程名
    all_Pods
    um_Pods 															# 友盟
    jiqimao_Pods													# 工具库


  target 'LSProjectToolTests' do
    inherit! :search_paths
    # Pods for testing
  end
  target 'LSProjectToolUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

