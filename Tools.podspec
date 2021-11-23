

Pod::Spec.new do |s|

  s.name            = "Tools"
  s.version         = "0.0.1"
  s.summary         = "自己库测试"
  s.homepage        = "https://github.com/Link-Start/Tools"
  s.license         = { :type => "MIT", :file => "LICENSE" }
  s.author          = { "Link-Start" => "532471002@qq.com" }

  s.platform        = :ios, "9.0"
  s.source          = { :git => "https://github.com/Link-Start/Tools.git", :tag => "#{s.version}" }
  s.source_files    = "LSProjectTool/File", "LSProjectTool/File/**/*.{h,m}"
  # s.exclude_files   = "Classes/Exclude"

  s.framework       = "UIKit"
  s.requires_arc    = true


  s.subspec 'MBProgressHUD+Extension' do |ex|
    ex.source_files = "LSProjectTool/lalalal/MBProgressHUD+Extension/**/*.{h,m}"
    ex.dependency "MBProgressHUD"
  end


end
