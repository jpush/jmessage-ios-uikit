//
//  JMUIMoreView.m
//  JMUIKit
//
//  Created by oshumini on 15/12/25.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMUIMoreViewDelegate <NSObject>
@optional
- (void)photoClick;
- (void)cameraClick;
@end

@interface JMUIMoreView : UIView
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (assign, nonatomic)  id<JMUIMoreViewDelegate>delegate;

@end