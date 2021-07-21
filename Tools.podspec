

Pod::Spec.new do |s|

  s.name            = "Tools"
  s.version         = "0.0.1"
  s.summary         = "A short description of Tools."
  s.homepage        = "https://github.com/Link-Start/Tools"
  s.license         = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author          = { "Link Start" => "532471002@qq.com" }

  s.platform        = :ios, "9.0"
  s.source          = { :git => "https://github.com/Link-Start/Tools.git", :tag => "#{s.version}" }
  s.source_files    = "Tools/LSProjectTool/File", "Tools/LSProjectTool/File/**/*.{h,m}"
  # s.exclude_files   = "Classes/Exclude"

  s.framework       = "UIKit"
  s.requires_arc    = true

  # s.default_subspec = "Default"

  # s.subspec 'Default' do |de|
  #   de.source_files = "Tools/**/*.{h,m}"
  #   de.resources    = "Tools/Resources/*.{boundle}"
  # end

  # s.subspec 'SDWebImage' do |sd|
  #   sd.source_files = "Tools/**/*.{h,m}"
  #   sd.dependency 'SDWebImage', '~> 5.0'
  #   sd.resources    = "Tools/Resources/*.{bundle}"
  # end
  
  # s.subspec 'SDWebImage_AF' do |sd_af|
  #   sd_af.source_files = "Tools/**/*.{h,m}"
  #   sd_af.dependency 'SDWebImage', '~> 5.0'
  #   sd_af.dependency 'AFNetworking'
  #   sd_af.resources    = "Tools/Resources/*.{bundle}"
  # end
  
  # s.subspec 'YYWebImage' do |yy|
  #   yy.source_files = "Tools/**/*.{h,m}"
  #   yy.dependency 'YYWebImage', '~> 1.0.5'
  #   yy.resources    = "Tools/Resources/*.{bundle}"
  # end
  
  # s.subspec 'YYWebImage_AF' do |yy_af|
  #   yy_af.source_files = "Tools/**/*.{h,m}"
  #   yy_af.dependency 'YYWebImage', '~> 1.0.5'
  #   yy_af.dependency 'AFNetworking'
  #   yy_af.resources    = "Tools/Resources/*.{bundle}"
  # end


  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
