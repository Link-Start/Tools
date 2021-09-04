# Tools
自己整理的知识

1.这里是自己 项目开发过程中搜集的一些知识
2.


/******************* 给工程添加忽略文件.gitignore *******************/

参考 https://www.cnblogs.com/someonelikeyou/p/7159765.html

1.iOS 项目，使用CocosPods 框架管理工具会生成Podfile、Podfile.lock、Pods文件夹和.xcworkspace四个。
以上除Podfile外，其它三个文件都不是必须提交的。
"其中Pods目录没必要提交，里面的文件都是根据Podfile描述的依赖库的配置信息下载和生成的文件。
因为CocoaPods支持语义化版本号，所以需要Podfile.lock文件记住当前使用的版本，当然这个文件也不是必须。不过提交这个的好处是，可以提醒团队里面的人，依赖库版本已经更新”。


use_frameworks!
pod 'FWPopupView'
注意：
1、如出现 [!] Unable to find a specification for 'FWPopupView' 错误 或 看不到最新的版本，
  可执行 pod repo update 命令更新一下本地pod仓库。
2、use_frameworks! 的使用：
（1）纯OC项目中，通过cocoapods导入OC库时，一般都不使用use_frameworks!
（2）纯swift项目中，通过cocoapods导入swift库时，必须使用use_frameworks!
（3）只要是通过cocoapods导入swift库时，都必须使用use_frameworks!
（4）使用动态链接库dynamic frameworks时，必须使用use_frameworks!
