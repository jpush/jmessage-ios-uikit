//
//  UIImage+JMUIGroupChatDetail.m
//  JMUIGroupChatDetailKit
//
//  Created by oshumini on 16/1/13.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

#import "UIImage+JMUIGroupChatDetail.h"

@implementation UIImage (JMUIGroupChatDetail)
+ (UIImage *)jmuiGroupChatDetail_imageInResource:(NSString *)imageName {
  UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"JMUIGroupChatDetailKitResource.bundle/%@@2x.png",imageName]];
  return image;
}
@end
