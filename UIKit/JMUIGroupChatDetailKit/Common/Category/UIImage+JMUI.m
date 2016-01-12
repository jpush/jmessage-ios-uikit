//
//  UIImage+JMUI.m
//  JMUIKit
//
//  Created by oshumini on 15/12/25.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "UIImage+JMUI.h"

@implementation UIImage (JMUI)
+ (UIImage *)jmui_imageInResource:(NSString *)imageName{
  UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"JMUIKitResource.bundle/%@",imageName]];
  return image;
}
@end
