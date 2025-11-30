

#------------------------------------------------------------------------------------------------
#平台和版本配置
#platform :ios, '10.0'					# 设置iOS平台和最低版本
#platform :tvos, '9.0'					# tvOS平台
#platform :watchos, '2.0'				# watchOS平台

#依赖管理配置
#use_frameworks!						# 使用动态框架（Swift项目推荐）
#inhibit_all_warnings!					# 屏蔽所有警告信息

#源仓库配置
source 'https://github.com/CocoaPods/Specs.git'		# 官方源
source 'https://github.com/artsy/Specs.git'			# 自定义源

# 主项目target
target 'YourAppName' do
#版本控制策略
pod 'AFNetworking'										#安装最新版本
pod 'AFNetworking', '~> 3.0'							#安装3.x的最新版本
pod 'AFNetworking', '>= 3.0'							#安装3.0及以上版本
pod 'AFNetworking', :path => '~/Documents/Alamofire'	#本地路径
end

#安装选项配置
install! 'cocoapods',
  :clean => true,                           # 清理未使用文件
  :deterministic_uuids => true,            # 生成确定性UUID
  :integrate_targets => true,              # 集成到项目中
  :lock_pod_sources => false,              # 是否锁定源文件
  :warn_for_unused_master_specs_repo => false  # 屏蔽未使用仓库警告

配置说明
核心配置项功能：
platform：定义目标平台和最低版本要求
use_frameworks!：启用动态框架支持，适合Swift项目
inhibit_all_warnings!：屏蔽依赖库中的警告信息
install!：控制CocoaPods的安装行为
source：指定依赖库的源仓库地址
版本控制说明：
使用~>操作符可以灵活控制版本更新范围，既保证兼容性又能够获得bug修复
立即检查你的项目根目录下是否存在Podfile文件，将上述配置复制进去并根据你的项目需求修改target名称和依赖库，然后运行pod install即可生效。

#------------------------------------------------------------------------------------------------

platform :ios, '10.0'									# 指定平台和最低版本
use_frameworks!											# 使用动态框架（Swift项目）
inhibit_all_warnings!									# 屏蔽所有警告
source 'https://github.com/CocoaPods/Specs.git'			# 指定源仓库

target 'YourAppName' do 								# 主项目target
end 

install! 'cocoapods',									# 安装配置选项
  :clean => true,
  :deterministic_uuids => true,
  :integrate_targets => true,
  :lock_pod_sources => false,
  :warn_for_unused_master_specs_repo => false

#------------------------------------------------------------------------------------------------
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







