
# 这些post_install钩子示例提供了多种实用的配置功能：
# ·`架构兼容性修复：专门解决M1/M2芯片的模拟器运行问题
# ·`版本统一管理：确保所有依赖库使用相同的iOS部署目标
# ·`Swift配置优化：为Swift项目设置正确的模块化和版本配置
# ·`编译问题修复：为有问题的库添加特定的编译标志
# ·`调试支持增强：为调试模式添加专用的预处理器定义
# ·`资源包处理：优化资源包的构建和签名设置
# ·`每个示例都可以根据项目具体需求进行调整和组合使用。


# 关键要点
# 单一钩子原则：CocoaPods只允许一个post_install钩子
# 模块化组织：在单个钩子内按功能模块分组配置
# 执行顺序：配置按代码顺序执行，后面的配置可能覆盖前面的设置
# 立即检查你的Podfile文件，将所有post_install配置合并到同一个钩子中，然后运行pod install来应用这些设置

post_install do |installer|
  # 示例1: 解决M1芯片模拟器兼容性问题
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
  
  # 示例2: 统一所有pod的最低部署版本
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
  
  # 示例3: 启用模块化头文件
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
      config.build_settings['DEFINES_MODULE'] = 'YES'
    end
  end
  
  # 示例4: 设置Swift版本
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) && target.product_type == 'com.apple.product-type.bundle'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end
  
  # 示例5: 为特定库添加编译标志
  installer.pods_project.targets.each do |target|
    if target.name == 'SomeProblematicLibrary'
      target.build_configurations.each do |config|
        config.build_settings['OTHER_CFLAGS'] = '$(inherited) -Wno-unused-variable'
      end
    end
  end
  
  # 示例6: 禁用bitcode（某些旧库需要）
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
  
  # 示例7: 为调试模式添加预处理器宏
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)', 'DEBUG=1']
      end
    end
  end
  
  # 示例8: 修改资源包复制规则
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) && target.product_type == 'com.apple.product-type.bundle'
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
  
  # 示例9: 设置Always Embed Swift Standard Libraries
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
    end
  end
end
