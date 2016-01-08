//
//  HMPhotoPickerViewController.h
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMUIPhotoSelectViewController.h"
@interface JMUIPhotoPickerViewController : UINavigationController
@property (weak, nonatomic)id<JMUIPhotoPickerViewControllerDelegate> photoDelegate;
@end
