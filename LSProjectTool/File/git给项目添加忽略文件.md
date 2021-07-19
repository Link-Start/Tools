
# iOS 建立项目过滤机制 —— 给工程添加忽略文件.gitignore
=================================================

https://www.cnblogs.com/someonelikeyou/p/7159765.html

补充更新

也可以参考github 官方地址下面的忽略文件示意
链接：https://github.com/github/gitignore  swift.gitignore  
=========================================================

目前iOS 项目 主要忽略 临时文件、配置文件、或者生成文件等，在不同开发端这些文件会大有不同，如果 git add .把这些文件都push到远程， 就会造成不同开发端频繁改动和提交的问题。
## 步骤：

    1 .  在工程目录下
    2 . touch .gitignore   //在目录下生成.gitignore  文件
    3 . open .gitignore   //打开.gitignore （txt）文件
    4 . 写入忽略目录

####  4.1. 这里iOS 项目，使用CocosPods 框架管理工具会生成Podfile、Podfile.lock、Pods文件夹和.xcworkspace四个。其中：
 
|		文件	  |         说明 	   |                   来源	                  |是否必须提交版本库|
|      --	  |          --	       |                   --	                  |      --	      |
|Podfile      |依赖配置文件	       |自己手动生成或者通过cocoapods-xcode-plugin生成|	     是		  |
|Podfile.lock |当前使用的库的信息	   |用cocoaPods引入库时生成 	                  |	     可选	  |
|Pods	      |依赖库缓存目录		   |用cocoaPods引入依赖库时生成的缓存目录		  |	     否	      |
|*.xcworkspace|带有库配置信息的工作空间|用cocoaPods引入库时生成					  |      可选	  |


以上除Podfile外，其它三个文件都不是必须提交的。

"其中Pods目录没必要提交，里面的文件都是根据Podfile描述的依赖库的配置信息下载和生成的文件。
因为CocoaPods支持语义化版本号，所以需要Podfile.lock文件记住当前使用的版本，当然这个文件也不是必须。不过提交这个的好处是，可以提醒团队里面的人，依赖库版本已经更新”。
 
(1)我们现在配置 设定 忽略依赖库缓存目录Pods/  
忽略目录写法如下：
```
#CocoaPods
Pods/ 
```

(2)xcode相关不需要提交的配置。 

```
# Xcode
#
# gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

# Mac OS X Finder and whatnot
.DS_Store

## Build generated
build/
DerivedData/

## Various settings
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/

## Other
*.moved-aside
*.xcuserstate
*.xccheckout

## Obj-C/Swift specific
*.hmap
*.ipa
*.dSYM.zip
*.dSYM
```

(1)和(2)放一起构成我的.gitignore文件

(3)但是如果你需要忽略的文件意境存在在远端中了，那么你需要将远端中的文件删除掉才可以：

使用 ```git rm -r --cached Pods/``` //进行删除

```git rm –cached``` 把文件.DS_Store从git的索引库中移除,但是对文件.DS_Store本身并不进行任何操作也就是说本地还是有.DS_Store文件的，但是远端却没有了

```之后再使用git commit ／push //之后提交上去 ```

这样就不会再用担心这个文件的冲突了

 

参考 
1 . http://www.cnblogs.com/ShaYeBlog/p/5359849.html

2 . https://segmentfault.com/q/1010000003041610
