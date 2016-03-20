//
//  UIImage+JMUIChatting.m
//  JMUIChattingKit
//
//  Created by oshumini on 16/1/13.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

#import "UIImage+JMUIChatting.h"

@implementation UIImage (JMUIChatting)
+ (UIImage *)jmuiChatting_imageInResource:(NSString *)imageName {
  UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"JMUIChattingKitResource.bundle/%@@2x.png",imageName]];
  return image;
}
@end
