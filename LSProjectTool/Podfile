#取消对下一行的注释以定义项目的全局平台
platform :ios, '9.0'

#如果您不使用swift并且不想使用动态框架，请对下一行进行注释。
use_frameworks!


#使用多target 可以用下面这样定义,避免重复书写代码
def all_Pods
  pod 'AFNetworking'                    #网络请求
  pod 'SDWebImage'                      #请求图片
  pod 'MJRefresh'                       #刷新
  pod 'Masonry', '~> 1.1.0'  #布局
  pod 'IQKeyboardManager'    #输入框键盘管理iOS8 and later
  pod 'MJExtension'          #数据模型转换
  pod 'DZNEmptyDataSet'      #空白占位图
  pod 'MBProgressHUD'
  pod 'FSTextView'           #placeholder和最大字数
  pod 'SDCycleScrollView', '~> 1.75'   #轮播图
  pod 'BRPickerView', '~> 2.2.1'       #选择器
  pod 'WechatOpenSDK'   #微信SDK
  pod 'JPush'           #极光推送
  pod 'XHLaunchAd'      #开屏广告
  pod 'AMapLocation-NO-IDFA'  #pod 'AMapLocation' #定位SDK 没有广告IDFA
end


# Pods for LSProjectTool
target 'LSProjectTool' do
    all_Pods


  target 'LSProjectToolTests' do
    inherit! :search_paths
    # Pods for testing
  end
  target 'LSProjectToolUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

