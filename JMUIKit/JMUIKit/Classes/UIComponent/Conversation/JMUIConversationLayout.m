//
//  JMUIConversationLayout.m
//  JMUIKit
//
//  Created by oshumini on 16/1/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMUIConversationLayout.h"


@interface JMUIConversationLayout (){
  UITableView *_messageListTable;
  JMUIInputView *_inputView;
}

@end

@implementation JMUIConversationLayout

-(instancetype)initWithInputView:(JMUIInputView *)inputView tableView:(UITableView *)tableview
{
  if (self = [self init]) {
    _inputView = inputView;
    _messageListTable = tableview;
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
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

- (void)messageTableScrollToBottom:(BOOL)animation {
  if (_messageListTable.contentSize.height + _messageListTable.contentInset.top > _messageListTable.frame.size.height)
  {
    CGPoint offset = CGPointMake(0, _messageListTable.contentSize.height - _messageListTable.frame.size.height);
    [_messageListTable setContentOffset:offset animated:animation];
  }

}
@end
