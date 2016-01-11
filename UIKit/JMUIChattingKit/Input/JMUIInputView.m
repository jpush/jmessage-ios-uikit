//
//  JMUIInputView.m
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIInputView.h"
#import "JMUIViewUtil.h"
#import "UIView+JMUI.h"
@implementation JMUIInputView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    _toolBar = NIB(JMUIInputToolbar);
    _toolBar.delegate = _delegate;
    _moreView = NIB(JMUIMoreView);
    _moreView.delegate = _delegate;
    
    [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.02];
  }
  return self;
}

- (id)init {
  self = [super init];
  if (self) {
    _toolBar = NIB(JMUIInputToolbar);
    _toolBar.delegate = _delegate;
    _moreView = NIB(JMUIMoreView);
    _moreView.delegate = _delegate;
    [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.02];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  _toolBar = NIB(JMUIInputToolbar);
  _toolBar.delegate = _delegate;
  _moreView = NIB(JMUIMoreView);
  _moreView.delegate = _delegate;
  
  [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.02];
  
}

- (void)addtoolbar {
  _toolBar.frame = CGRectMake(0, 0, kApplicationWidth, 45);
  [self addSubview:_toolBar];
  
  _moreView.frame = CGRectMake(0, 45, kApplicationWidth, self.jmui_height - 45);
  [self addSubview:_moreView];
}

- (void)setDelegate:(id<JMUIMoreViewDelegate,JMUIToolBarDelegate>)delegate {
  _toolBar.delegate = delegate;
  _moreView.delegate = delegate;
}

- (void)hideKeyboard {
  [_toolBar.textView resignFirstResponder];
}
@end
