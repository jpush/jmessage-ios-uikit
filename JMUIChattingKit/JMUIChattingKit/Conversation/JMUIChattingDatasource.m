//
//  JMUIConversationDatasource.m
//  JMUIKit
//
//  Created by oshumini on 16/1/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMUIChattingDatasource.h"
#import "JMUIMessageTableViewCell.h"

@interface JMUIChattingDatasource (){
  NSInteger messageOffset;//当前获取消息的指针
  BOOL isNoMoreHistoryMsg;
  JMUIMessageTableViewCell *messageCell;
}

@end

@implementation JMUIChattingDatasource
- (instancetype)initWithConversation:(JMSGConversation*)conversation
                    showTimeInterval:(NSTimeInterval)timeInterval
                  fristPageMsgNumber:(NSInteger)pageNumber
                               limit:(NSInteger)limit {
  if (self = [self init]) {
    _conversation    = conversation;
    _messageLimit      = limit;
    _showTimeInterval  = timeInterval;
    _messagefristPageNumber = pageNumber;
    isNoMoreHistoryMsg = NO;
    _allMessageDic = @{}.mutableCopy;
    _allMessageIdArr = @[].mutableCopy;
    _imgMsgModelArr = @[].mutableCopy;
    messageCell = [[JMUIMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToGetSizeCell"];
  }
  return self;
}

- (void)getPageMessage {
  NSLog(@"Action - getAllMessage");
  
  [_allMessageDic removeAllObjects];
  [_allMessageIdArr removeAllObjects];
  NSMutableArray * arrList = [[NSMutableArray alloc] init];
  [_allMessageIdArr addObject:[[NSObject alloc] init]];
  
  messageOffset = _messagefristPageNumber;
  [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
  if ([arrList count] < _messagefristPageNumber) {
    isNoMoreHistoryMsg = YES;
    [_allMessageIdArr removeObjectAtIndex:0];
  }
  
  for (JMSGMessage *message in arrList) {
    JMUIChatModel *model = [[JMUIChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [self.imgMsgModelArr addObject:model];
    }
    
    [self dataMessageShowTime:message.timestamp];
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allMessageIdArr addObject:model.message.msgId];
  }
}

- (void)getMoreMessage {
  NSMutableArray *arrList = @[].mutableCopy;
  [arrList addObjectsFromArray:[_conversation messageArrayFromNewestWithOffset:@(messageOffset) limit:@(_messageLimit)]];
  messageOffset = messageOffset + _messageLimit;
  if ([arrList count] < _messageLimit) {
    isNoMoreHistoryMsg = YES;
    [_allMessageIdArr removeObjectAtIndex:0];
  }
  
  for (JMSGMessage *message in arrList) {
    JMUIChatModel *model = [[JMUIChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgMsgModelArr insertObject:model atIndex:0];
    }
    
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allMessageIdArr insertObject:model.message.msgId atIndex: isNoMoreHistoryMsg?0:1];
    [self dataMessageShowTimeToTop:message.timestamp];
  }
}

- (void)appendMessage:(JMUIChatModel *)model {
  if (model.isTime) {
    [_allMessageDic setObject:model forKey:model.timeId];
    [_allMessageIdArr addObject:model.timeId];
  } else {
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allMessageIdArr addObject:model.message.msgId];
    if(model.message.contentType == kJMSGContentTypeImage) {
      [_imgMsgModelArr addObject:model];
    }
  }
}

- (void)appendTimeData:(NSTimeInterval)timeInterVal {
  JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];
  [self appendMessage:timeModel];
}

- (void)addmessage:(JMUIChatModel *)model toIndex:(NSInteger)index {
  if (model.isTime) {
    [_allMessageIdArr insertObject:model atIndex:index];
    [_allMessageDic setObject:model forKey:model.timeId];
  } else {
    [_allMessageIdArr insertObject:model atIndex:index];
    [_allMessageDic setObject:model forKey:model.message.msgId];
  }
}

//比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_allMessageIdArr lastObject];
  JMUIChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  
  if (timeInterVal > 1999999999) {
    timeInterVal /= 1000;
  }
  
  if ([_allMessageIdArr count]>0 && lastModel.isTime == NO) {
    NSTimeInterval lastTimeInterVal = [lastModel.messageTime doubleValue];
    
    if (lastTimeInterVal > 1999999999) {
      lastTimeInterVal /= 1000;
    }
    
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:lastTimeInterVal];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > _showTimeInterval) {
      JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];//!
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allMessageIdArr addObject:timeModel.timeId];
    }
  } else if ([_allMessageIdArr count] ==0) {//首条消息显示时间
    JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allMessageIdArr addObject:timeModel.timeId];
  } else {
    NSLog(@"不用显示时间");
  }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  
  //     时间为毫秒时，转换成秒
  if (timeInterVal > 1999999999) {
    timeInterVal = floor(timeInterVal / 1000);
  }
  
  NSString* fristID = _allMessageIdArr[isNoMoreHistoryMsg?1:2];
  JMUIChatModel *fristModel = _allMessageDic[fristID];
  
  if ([_allMessageIdArr count]>0 && fristModel.isTime == NO) {
    
    
    if ([fristModel.messageTime longLongValue] > 1999999999) {
      fristModel.messageTime = [NSNumber numberWithLongLong:floor([fristModel.messageTime longLongValue] / 1000)];
    }
    
    NSDate* fristDate = [NSDate dateWithTimeIntervalSince1970:[fristModel.messageTime doubleValue]];
    
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:fristDate];
    if (fabs(timeBetween) > _showTimeInterval) {
      JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allMessageIdArr insertObject:timeModel.timeId atIndex: isNoMoreHistoryMsg?0:1];
    }
  } else if ([_allMessageIdArr count] ==0) {//首条消息显示时间
    JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allMessageIdArr insertObject:timeModel.timeId atIndex: isNoMoreHistoryMsg?0:1];
  } else {
    NSLog(@"不用显示时间"); //
  }
}


- (JMUIChatModel *)getMessageWithIndex:(NSInteger)index {
  NSString *messageId = _allMessageIdArr[index];
  JMUIChatModel *model = _allMessageDic[messageId];
  return model;
}

- (JMUIChatModel *)getMessageWithMsgId:(NSString *)messageId {
  return  _allMessageDic[messageId];
}

- (JMUIChatModel *)lastMessage {
  NSString *messageId = [_allMessageIdArr lastObject];
  JMUIChatModel *lastModel = _allMessageDic[messageId];
  return lastModel;
}

- (NSInteger)messageCount {
  return _allMessageIdArr.count;
}

- (BOOL)noMoreHistoryMessage {
  return isNoMoreHistoryMsg;
}

- (NSIndexPath *)tableIndexPathWithMessageId:(NSString *)messageId {
  NSInteger index = [_allMessageIdArr indexOfObject:messageId];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  return indexPath;
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

- (NSInteger)getImageIndex:(JMUIChatModel *)model {
  if([_imgMsgModelArr count] == 0) { return 0; }
  
  return [_imgMsgModelArr indexOfObject:model];
}

@end
