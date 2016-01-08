//
//  UIView+JMUI.m
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "UIView+JMUI.h"

@implementation UIView (JMUI)

- (CGFloat)jmui_left {
  return self.frame.origin.x;
}

- (void)setJmui_left:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)jmui_top {
  return self.frame.origin.y;
}

- (void)setJmui_top:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)jmui_right {
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setJmui_right:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)jmui_bottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setJmui_bottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}

- (CGFloat)jmui_centerX {
  return self.center.x;
}

- (void)setJmui_centerX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)jmui_centerY {
  return self.center.y;
}

- (void)setJmui_centerY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)jmui_width {
  return self.frame.size.width;
}

- (void)setJmui_width:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)jmui_height {
  return self.frame.size.height;
}

- (void)setJmui_height:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (CGPoint)jmui_origin {
  return self.frame.origin;
}

- (void)setJmui_origin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}

- (CGSize)jmui_size {
  return self.frame.size;
}

- (void)setJmui_size:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}

- (UIViewController *)jmui_viewController{
  for (UIView* next = self; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
}
@end
