# jmessage-iOS-UI-components
IM SDK UI 组件

简单的聊天组件, 实现了聊天功能。
##JMUIChatting 快照 
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/JMUIChatting快照.gif)

## JMUIChatting 集成说明
1.下载[JMUIKit](https://github.com/jpush/jmessage-ios-uikit/archive/master.zip) 工程，打开工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/1.打开工程.gif)

2.编译JMUICommon
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/2.编译JMUICommon.gif)

3.编译JMUIChattingKit
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/3.编译JMUIChatting库.gif)

4.复制JMUIChatting.framework 到自己工程中
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/4.复制JMUICommon库到工程.gif)

5.复制JMUICommon.framework 到自己工程中
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/5.拷贝JMUIChatting库到自己工程中.gif)

6.添加framework 资源到自己工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/6.在自己的工程中使用framework的资源.gif)

7.添加JMessage SDK 到自己工程 并且根据官网的集成文档集成该framework [JMessage 集成教程](http://docs.jpush.io/guideline/jmessage_ios_guide/)

##JMUIChatting 使用
一下是以[JMUIChattingDemo](/JMUIChattingDemo) 为例子
1.添加创建会话类 MyConversationViewController 
2.添加头文件 #import <JMUIChattingKit/JMUIChattingViewController.h>
3. MyConversationViewController 继承 JMUIChattingViewController 类
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/代码JMUIChatting集成说明.gif)
