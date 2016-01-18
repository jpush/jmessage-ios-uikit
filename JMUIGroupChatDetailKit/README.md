# jmessage-iOS-UI-components
IM SDK UI 组件

简单的群聊详情组件

##JMUIChatting 快照 
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIGroupChatDetailKit/README_JMUIGroupChatDetailKit说明图/JMUIGroupChatDetailDemo快照.gif)

## JMUIChatting 集成说明
1.下载[JMUIKit](https://github.com/jpush/jmessage-ios-uikit/archive/master.zip) 工程，打开工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/1.打开工程.gif)

2.编译JMUICommon
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/2.编译JMUICommon.gif)

3.JMUIGroupChatDetail 库
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/3.编译JMUIChatting库.gif)

4.添加JMUICommon.framework 到自己工程中
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIGroupChatDetailKit/README_JMUIGroupChatDetailKit说明图/添加JMUICommon库到自己工程.gif)

5.添加JMUICommon.framework 库资源到自己工程中
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/5.拷贝JMUIChatting库到自己工程中.gif)

6.添加JMessage.framework库到自己工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIGroupChatDetailKit/README_JMUIGroupChatDetailKit说明图/添加JMessage库到自己工程.gif)

7.添加JMessage SDK 到自己工程 并且根据官网的集成文档集成该framework [JMessage 集成教程](http://docs.jpush.io/guideline/jmessage_ios_guide/)

8.添加JMUIGroupChatDetail.framework 库到自己工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIGroupChatDetailKit/README_JMUIGroupChatDetailKit说明图/添加JMUIGroupChatDetail%20库到自己工程.gif)

9.添加JMUIGroupChatDetail.framework 库资源到自己工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIGroupChatDetailKit/README_JMUIGroupChatDetailKit说明图/添加JMUIGroupChatDetail库资源到自己工程.gif)

##JMUIGroupChatDetail 的使用
一下是以[JMUIGroupChatDetailDemo](/JMUIGroupChatDetailDemo) 为例子

1.添加创建会话类 MyGroupDetailViewController
2.添加头文件 #import <JMUIGroupChatDetailKit/JMUIGroupChatDetailViewController.h>
3. MyGroupDetailViewController 继承 JMUIGroupChatDetailViewController 类

