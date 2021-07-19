一、使用CDN（速度飞一般）

# 在Profile文件头部添加,使用CDN
source 'https://cdn.cocoapods.org/'
二、安装

# 安装所有库
pod install
 
# 安装前，强制更新索引库(pod repo)
pod install --repo-update
 
# 安装前，忽略更新索引库(pod repo)
pod install --no-repo-update
 
# 忽略本地缓存，强制远程pod库完整安装
pod install --clean-install
 
二、更新

# 更新所有库
pod update 
 
# 更新所有库，更新前忽略索引库(pod repo)更新
pod update --no-repo-update
 
 
# 更新指定库,同时更新多个库用空格隔开
pod update 库名 
 
# 更新指定库,新前忽略索引库(pod repo)更新
pod update 库名 --no-repo-update
