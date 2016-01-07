//
//  NSString.m
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "NSString+JMUI.h"

@implementation NSString (JMUI)
- (NSString *)stringByTrimingWhitespace {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines {
  return [[self componentsSeparatedByString:@"\n"] count] + 1;
}
@end
