//
//  UIImage+XHRecord.m
//  JMUIComman
//
//  Created by oshumini on 16/1/13.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

#import "UIImage+XHRecord.h"

@implementation UIImage (XHRecord)
+ (UIImage *)xhrecord_imageInResource:(NSString *)imageName {
  UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"JMUIChattingKitResource.bundle/%@@2x.png",imageName]];
  return image;
}
@end
