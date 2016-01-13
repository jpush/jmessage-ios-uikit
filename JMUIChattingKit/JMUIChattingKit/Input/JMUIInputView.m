//
//  JMUIInputView.m
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIInputView.h"
#import <JMUICommon/JMUIViewUtil.h>
//#import "UIView+JMUI.h"
#import <JMUICommon/UIView+JMUI.h>

@implementation JMUIInputView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
//    _toolBar = NIB("JMUIChattingKit.framework/JMUIInputToolbar");
    NSArray *toolbars=[[NSBundle mainBundle] loadNibNamed:@"JMUIChattingKit.framework/JMUIInputToolbar.nib"
                                                owner:self
                                              options:nil];
    _toolBar = [toolbars objectAtIndex:0];
    _toolBar.delegate = _delegate;
//    _moreView = NIB("JMUIChattingKit.framework/JMUIMoreView");
    NSArray *moreViews=[[NSBundle mainBundle] loadNibNamed:@"JMUIChattingKit.framework/JMUIMoreView.nib"
                                                owner:self
                                              options:nil];
    _toolBar = [moreViews objectAtIndex:0];
    _moreView.delegate = _delegate;
    
    [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.02];
  }
  return self;
}

- (id)init {
  self = [super init];
  if (self) {
    NSArray *toolbars=[[NSBundle mainBundle] loadNibNamed:@"JMUIChattingKit.framework/JMUIInputToolbar"
                                                    owner:self
                                                  options:nil];
    _toolBar = [toolbars objectAtIndex:0];
    _toolBar.delegate = _delegate;
    NSArray *moreViews=[[NSBundle mainBundle] loadNibNamed:@"JMUIChattingKit.framework/JMUIMoreView"
                                                     owner:self
                                                   options:nil];
    _moreView = [moreViews objectAtIndex:0];
    _moreView.delegate = _delegate;
    [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.02];
  }
  return self;
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
