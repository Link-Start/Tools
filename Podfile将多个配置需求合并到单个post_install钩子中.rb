
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'Alamofire', '~> 5.4'
  pod 'SDWebImage', '~> 5.0'
end

post_install do |installer|
  # 配置1: 解决M1芯片模拟器兼容性问题
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
  
  # 配置2: 统一所有pod的最低部署版本
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
  
  # 配置3: 设置Swift版本
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
  
  # 配置4: 为调试模式添加预处理器宏
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DEBUG=1'
      end
    end
  end
  
  # 配置5: 禁用bitcode
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end

# 关键要点
# 单一钩子原则：CocoaPods只允许一个post_install钩子
# 模块化组织：在单个钩子内按功能模块分组配置
# 执行顺序：配置按代码顺序执行，后面的配置可能覆盖前面的设置
# 立即检查你的Podfile文件，将所有post_install配置合并到同一个钩子中，然后运行pod install来应用这些设置。



