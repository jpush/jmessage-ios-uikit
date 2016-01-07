//
//  JMUIMoreView.h
//  JMUIKit
//
//  Created by oshumini on 15/12/25.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIMoreView.h"
#import "JMUIViewUtil.h"

@implementation JMUIMoreView

- (void)drawRect:(CGRect)rect {
  
}

- (IBAction)photoBtnClick:(id)sender {
  
  if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
    [self.delegate photoClick];
  }
}
- (IBAction)cameraBtnClick:(id)sender {
  if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
    [self.delegate cameraClick];
  }
}
@end



