//
//  JMUIConversationLayout.m
//  JMUIKit
//
//  Created by oshumini on 16/1/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMUIChattingLayout.h"
#import <JMUICommon/UIView+JMUI.h>


static NSInteger const inputViewHeight = 297;
static CGFloat const animationDuration = 0.25;

@interface JMUIChattingLayout (){
  UITableView *_messageListTable;
  JMUIInputView *_jmuiinputView;
}

@end

@implementation JMUIChattingLayout

-(instancetype)initWithInputView:(JMUIInputView *)inputView tableView:(UITableView *)tableview
{
  if (self = [self init]) {
    _jmuiinputView = inputView;
    _jmuiinputView.jmui_height = inputViewHeight;
    _jmuiinputView.jmui_width = kApplicationWidth;
    _jmuiinputView.jmui_left = 0;
    _jmuiinputView.jmui_top = [_jmuiinputView superview].jmui_height - 45;
    
    _messageListTable = tableview;
    _messageListTable.jmui_height = [_messageListTable superview].jmui_height - 45;
    _jmuiinputView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
  }
  return self;
}

-(void)insertTableViewCellAtRows:(NSArray*)addIndexs
{
  if (!addIndexs.count) {
    return;
  }
  NSMutableArray *addIndexPathes = [NSMutableArray array];
  [addIndexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [addIndexPathes addObject:[NSIndexPath indexPathForRow:[obj integerValue] inSection:0]];
  }];
  [_messageListTable beginUpdates];
  [_messageListTable insertRowsAtIndexPaths:addIndexPathes withRowAnimation:UITableViewRowAnimationNone];
  [_messageListTable endUpdates];
  
  NSTimeInterval scrollDelay = .01f;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(scrollDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [_messageListTable scrollToRowAtIndexPath:[addIndexPathes lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  });
}

- (void)appendTableViewCellAtLastIndex:(NSInteger)index {
  NSIndexPath *path = [NSIndexPath indexPathForRow:index - 1 inSection:0];
  [_messageListTable beginUpdates];
  [_messageListTable insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageListTable endUpdates];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self messageTableScrollToIndeCell:index];
  });
}

- (void)messageTableScrollToBottom:(BOOL)animation {
  if (_messageListTable.contentSize.height + _messageListTable.contentInset.top > _messageListTable.frame.size.height)
  {
    CGPoint offset = CGPointMake(0, _messageListTable.contentSize.height - _messageListTable.frame.size.height);
    if (animation) {
      [UIView animateWithDuration:animationDuration animations:^{
        [_messageListTable setContentOffset:offset];
      }];
    } else {
      [_messageListTable setContentOffset:offset animated:animation];
      [_messageListTable setContentOffset:offset];
    }
  }
}

- (void)messageTableScrollToBottom:(BOOL)animation withDuration:(CGFloat)duration {
  if (_messageListTable.contentSize.height + _messageListTable.contentInset.top > _messageListTable.frame.size.height)
  {
    CGPoint offset = CGPointMake(0, _messageListTable.contentSize.height - _messageListTable.frame.size.height);
    if (animation) {
      
      [UIView animateWithDuration:duration animations:^{
        [_messageListTable setContentOffset:offset];
      }];
      
    } else {
      [_messageListTable setContentOffset:offset animated:animation];
      [_messageListTable setContentOffset:offset];
    }
  }
}


- (void)messageTableScrollToIndeCell:(NSInteger)index {
  [_messageListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)hideKeyboard {
  [_jmuiinputView hideKeyboard];
}

- (void)showMoreView{
  _jmuiinputView.jmui_top = kApplicationHeight - _jmuiinputView.jmui_height - 64;
  _messageListTable.jmui_height = [_messageListTable superview].jmui_height - _jmuiinputView.jmui_height;
  [self messageTableScrollToBottom:YES];
}

- (void)showKeyboard:(CGFloat)keybordHeight withDuration:(CGFloat)duration {
  _jmuiinputView.jmui_top = kApplicationHeight - keybordHeight - 64 - _jmuiinputView.toolBar.jmui_height;
  
  _messageListTable.jmui_height = [_messageListTable superview].jmui_height - keybordHeight - 45;
  
//  [self messageTableScrollToBottom:YES];
  [self messageTableScrollToBottom:YES withDuration:duration];
}

- (void)hideMoreView {
  [UIView animateWithDuration:animationDuration animations:^{
    _jmuiinputView.jmui_top = [_jmuiinputView superview].jmui_height - 45;
    _messageListTable.jmui_height = [_messageListTable superview].jmui_height - 45;
  }];
}
@end
