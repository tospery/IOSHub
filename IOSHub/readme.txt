1、打开Podfile，重命名Target，删除Pods、Podfile.lock和IOSHub.xcworkspace
2、打开IOSHub.xcworkspace，依次重命名Target、工程名、主文件夹和IOSHub.entitlements
3、关闭工程，执行pod install
4、搜索替换IOSHub和ioshub
5、选着info.plist
6、修改bundle id
7、修改R.swift的Build Phases
8、修改APP名称
9、编译运行
10、删除IOSHub的scheme
