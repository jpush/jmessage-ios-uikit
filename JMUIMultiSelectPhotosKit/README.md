# jmessage-iOS-UI-components
IM SDK UI 组件

多选相册图片的组件

##JMUIMultiSelectPhotosKit 快照 
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIMultiSelectPhotosKit/README_JMUIMultiSelectPhotosKit说明图/JMUIMultiSelectPhotosKit快照.gif)

## JMUIMultiSelectPhotosKit 集成说明
1.下载[JMUIKit](https://github.com/jpush/jmessage-ios-uikit/archive/master.zip) 工程，打开工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIChattingKit/README_JMUIChatting集成说明图/1.打开工程.gif)

2.编译JMUIMultiSelectPhotosKit 库
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIMultiSelectPhotosKit/README_JMUIMultiSelectPhotosKit说明图/编译JMUIMultiSelectPhotosKit库.gif)

3.添加JMUIMultiSelectPhotosKit.framework 库到自己工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIMultiSelectPhotosKit/README_JMUIMultiSelectPhotosKit说明图/添加JMUIMultiSelectPhotosKit库到自己工程.gif)

4.添加JMUIMultiSelectPhotosKit.framework 库资源到自己工程
![image](https://github.com/jpush/jmessage-ios-uikit/blob/master/JMUIMultiSelectPhotosKit/README_JMUIMultiSelectPhotosKit说明图/添加JMUIMultiSelectPhotosKit库资源到自己工程.gif)

##JMUIMultiSelectPhotosKit 的使用
一下是以[JMUIMultiSelectPhotosDemo](/JMUIMultiSelectPhotosDemo) 为例子

1.创建RootViewController类 该类是需要用到选图的类。 

2.在RootViewController 添加头文件#import \<JMUIMultiSelectPhotosKit/JMUIMultiSelectPhotosViewController.h\>
3. RootViewController 遵守 JMUIMultiSelectPhotosDelegate 协议
```
@interface RootViewController ()<JMUIMultiSelectPhotosDelegate> {
}
```
4.RootViewController类中实现 完成发图的回调方法
```
- (void)JMUIMultiSelectedPhotoArray:(NSArray *)selected_photo_array {
    //其中selected_photo_array 存的是你选择的图片(UIImage)
}
```


