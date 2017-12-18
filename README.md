# jmessage-ios-uikit
### 本库不再维护建议使用 [aurora-imui](https://github.com/jpush/aurora-imui) ，[JMessage 和 aurora-imui demo](https://github.com/jpush/aurora-imui-examples/tree/master/JMessage-example/iOS)

本项目为极光IM iOS SDK 提供配套的 UI组件。

这些组件大多数来自于 [JChat iOS](https://github.com/jpush/jchat-ios) 项目。可以参考该项目源代码来更完整系统地了解一个基于 JMessage SDK 的 App。

本项目包含如何几个部分（组件）：

- [聊天界面组件](JMUIChattingKit/) 包含聊天气泡，文字、语音、图片等聊天内容的显示等。可以运行[聊天Demo](JMUIChattingDemo/)看到集成效果。
- [群聊详情界面组件](JMUIGroupChatDetailKit/) 群聊详情里需要展示群成员列表，以及其他设置项。可以运行[聊天详情Demo](JMUIGroupChatDetailDemo/)看到集成效果。
- [相册多选照片组件](JMUIMultiSelectPhotosKit/) 默认的系统相册里选择图片不支持多选。本组件提供多选功能，并方便发送。可以运行[相册多选Demo](JMUIMultiSelectPhotosDemo/)看到集成效果。

上面的UIKit 组件需要和JMUICommon 一起使用，共同添加到工程中:

- [公共库](JMUICommon/)公共库是把上面库(JMUIChattingKit JMUIGroupChatDetailKit JMUIMultiSelectPhotosKit)所用到的公共代码,和用到的第三方库进行了封装，目的是防止组件之间的命名冲突，如果你的工程里面用到了第三方库与公共类重复，则会出现命名冲突。例如:公共类用到了MBProgressHUD，如果你的工程已经存在MBProgressHUD这个第三方库，那么添加公共库的时候会出现命名冲突，不过幸运的是公共类公开了所有第三方库的头文件，如果你想用到这些类库不需要再次添加，直接使用便可。

-----------------

Three simple demos of component from [JChat iOS](https://github.com/jpush/jchat-ios). Include functions of single chat, recording voice and browsing local images. 

Download this project and import as a project with Android Studio, then you can custom your applications.
