
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'Alamofire', '~> 5.4'
  pod 'SDWebImage', '~> 5.0'
  pod 'RealmSwift', '~> 10.0'
  pod 'Firebase/Analytics'
end

post_install do |installer|
  # 1. 架构兼容性优化
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # M1芯片模拟器兼容性修复
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      
      # 2. 统一部署目标版本
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      
      # 3. Swift版本统一设置
      config.build_settings['SWIFT_VERSION'] = '5.0'
      
      # 4. 模块化支持
      config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
      config.build_settings['DEFINES_MODULE'] = 'YES'
      
      # 5. 调试配置优化
      if config.name == 'Debug'
        # 启用调试符号
        config.build_settings['GCC_GENERATE_DEBUGGING_SYMBOLS'] = 'YES'
        config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
        
        # 添加调试预处理器宏
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DEBUG=1'
      else
        # 发布模式优化
        config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        config.build_settings['GCC_OPTIMIZATION_LEVEL'] = 's'
      end
    end
  end
  
  # 6. 特定库的个性化配置
  installer.pods_project.targets.each do |target|
    case target.name
    when 'RealmSwift'
      # Realm数据库特殊配置
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -DREALM_HAVE_CONFIG'
      end
      
    when 'FirebaseAnalytics'
      # Firebase分析库配置
      target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'FIREBASE_ANALYTICS_SUPPRESS_WARNING=1'
      end
    end
  end
  
  # 7. 资源包处理优化
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) && target.product_type == 'com.apple.product-type.bundle'
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      end
    end
  end
  
  # 8. 编译器优化设置
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 启用ARC
      config.build_settings['CLANG_ENABLE_OBJC_ARC'] = 'YES'
      
      # 设置警告级别
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'NO'
      
      # 链接器优化
      config.build_settings['OTHER_LDFLAGS'] = '$(inherited) -ObjC'
      
      # 搜索路径优化
      config.build_settings['FRAMEWORK_SEARCH_PATHS'] = '$(inherited)'
      config.build_settings['LIBRARY_SEARCH_PATHS'] = '$(inherited)'
      config.build_settings['HEADER_SEARCH_PATHS'] = '$(inherited)'
    end
  end
  
  # 9. 代码签名设置（适用于开发阶段）
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['CODE_SIGN_IDENTITY'] = 'iPhone Developer'
      config.build_settings['DEVELOPMENT_TEAM'] = 'YOUR_TEAM_ID'
    end
  end
  
  # 10. 性能优化设置
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 启用预编译头文件
      config.build_settings['GCC_PRECOMPILE_PREFIX_HEADER'] = 'YES'
      config.build_settings['GCC_PREFIX_HEADER'] = '$(inherited)'
    end
  end
end


# 这个高级post_install钩子提供了以下核心功能：
# 架构兼容性：专门优化M1/M2芯片的模拟器运行问题
# 版本统一管理：确保所有依赖库使用相同的iOS部署目标和Swift版本
# 调试增强：为Debug模式添加专门的优化配置
# 库个性化配置：针对Realm、Firebase等特定库进行定制化设置
# 资源处理优化：改进资源包的构建和签名流程
# 编译器性能优化：通过预编译头文件等设置提升构建速度
# 立即将这个配置添加到你的Podfile文件末尾，然后运行pod install来应用这些优化设置。记得根据你的实际项目需求调整部署目标版本和团队ID等参数。



# post_install钩子是CocoaPods在完成依赖安装后执行的自定义脚本，主要用于修改项目的构建设置和解决特定问题。
# 核心功能与用途
# 基本作用机制
# post_install钩子在pod install或pod update命令执行完毕后自动触发，让你能够访问和修改installer对象来调整项目配置

# 主要应用场景
# ·`架构兼容性修复：解决M1/M2芯片上的模拟器运行问题
# ·`版本统一管理：确保所有依赖库使用相同的部署目标版本
# ·`编译器设置调整：修改编译标志、警告级别等
# ·`特定库的个性化配置：为有问题的库添加特殊设置

# 常用配置示例
# 统一部署目标版本
#   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
# 这段代码将所有pod的最低iOS版本统一设置为12.0，避免不同库使用不同版本导致的编译冲突

# 预处理器宏配置
#   config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
#   config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << "ADHOC"
# 可以为不同的构建配置（Debug、Release等）添加自定义的预处理器宏

# 立即检查你的Podfile文件，在末尾添加post_install钩子来统一管理依赖库的构建设置，这样可以有效解决版本兼容性和架构问题。







