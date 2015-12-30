//
//  JMUIConversationViewController.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIConversationViewController.h"
#import "JMUIMessageCellMaker.h"
#import "JMUIStringUtils.h"

#define interval 60*2 //static =const
#define messageTableColor [UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]

static NSInteger const messagePageNumber = 25;
static NSInteger const messagefristPageNumber = 20;

@interface JMUIConversationViewController (){
  NSInteger messageOffset;
}

@property(strong, nonatomic)NSMutableArray *allMessageIdArr;
@property(strong, nonatomic)NSMutableDictionary *allMessageDic;
@property(assign, nonatomic)BOOL isNoMoreHistoryMsg;

@end

@implementation JMUIConversationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _inputView.delegate = self;
  
  [self setupData];
  [self setupMessageListTable];
  [JMessage addDelegate:self withConversation:self.conversation];
}

- (void)setupData {
  _allMessageDic = @{}.mutableCopy;
  _allMessageIdArr = @[].mutableCopy;
  [self getSingleConversation];
}

- (void)setupMessageListTable {
  _messageListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  _messageListTable.backgroundColor = messageTableColor;
}

- (void)getSingleConversation {
  JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:@"5558"];
  if (conversation == nil) {
    [JMSGConversation createSingleConversationWithUsername:@"5558" completionHandler:^(id resultObject, NSError *error) {
      if (error) {
        NSLog(@"创建会话失败");
        return ;
      }
       _conversation = resultObject;
      [self getPageMessage];
    }];
  } else {
    _conversation = conversation;
    [self getPageMessage];
  }
}

- (void)getPageMessage {
  NSLog(@"Action - getAllMessage");

  [_allMessageDic removeAllObjects];
  [_allMessageIdArr removeAllObjects];
  NSMutableArray * arrList = [[NSMutableArray alloc] init];
  [_allMessageIdArr addObject:[[NSObject alloc] init]];
  
  messageOffset = messagefristPageNumber;
  [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
  if ([arrList count] < messagefristPageNumber) {
    _isNoMoreHistoryMsg = YES;
    [_allMessageIdArr removeObjectAtIndex:0];
  }
  
  for (NSInteger i=0; i< [arrList count]; i++) {
    JMSGMessage *message = [arrList objectAtIndex:i];
    JMUIChatModel *model = [[JMUIChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
    }
    
    [self dataMessageShowTime:message.timestamp];
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allMessageIdArr addObject:model.message.msgId];
  }
  [_messageListTable reloadData];
  [self scrollToBottomAnimated:NO];
}

- (void)addMessage:(JMUIChatModel *)model {
  if (model.isTime) {
    [_allMessageDic setObject:model forKey:model.timeId];
    [_allMessageIdArr addObject:model.timeId];
  } else {
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allMessageIdArr addObject:model.message.msgId];
  }
  [self addCellToTabel];
}

- (void)addCellToTabel {
  NSIndexPath *path = [NSIndexPath indexPathForRow:[_allMessageIdArr count]-1 inSection:0];
  [_messageListTable beginUpdates];
  [_messageListTable insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageListTable endUpdates];
//  [self scrollToEnd];
  [self scrollToBottomAnimated:YES];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  NSInteger rows = [_messageListTable numberOfRowsInSection:0];
  if (rows > 0) {
    [_messageListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allMessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
  }
}

// TODO:
//一下三个函数，看看能不能合
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [_allMessageIdArr lastObject];
  JMUIChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  
  if ([_allMessageIdArr count] > 0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  } else if ([_allMessageIdArr count] == 0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  } else {
    NSLog(@"不用显示时间");
  }
}

//比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_allMessageIdArr lastObject];
  JMUIChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  
  if ([_allMessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
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
  NSString *messageId = [_allMessageIdArr lastObject];
  JMUIChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  
  if ([_allMessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allMessageIdArr insertObject:timeModel.timeId atIndex: _isNoMoreHistoryMsg?0:1];
    }
  } else if ([_allMessageIdArr count] ==0) {//首条消息显示时间
    JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allMessageIdArr insertObject:timeModel.timeId atIndex: _isNoMoreHistoryMsg?0:1];
  } else {
    NSLog(@"不用显示时间");
  }
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  JMUIChatModel *timeModel =[[JMUIChatModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];
  [self addMessage:timeModel];
}

- (void)relayoutTableCellWithMsgId:(NSString *) messageId{
  if ([messageId isEqualToString:@""]) {
    return;
  }
  NSInteger index = [_allMessageIdArr indexOfObject:messageId];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  
  JMUIMessageTableViewCell *tableviewcell = [_messageListTable cellForRowAtIndexPath:indexPath];
  [tableviewcell layoutAllView];
}

#pragma -mark JMessageDelegate

- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
  NSLog(@"Event - sendMessageResponse");
  [self relayoutTableCellWithMsgId:message.msgId];
  if (error != nil) {
    NSLog(@"Send response error - %@", error);
    [_conversation clearUnreadCount];
    NSString *alert = [JMUIStringUtils errorAlert:error];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showMessage:alert view:self.view];
    return;
  }
  JMUIChatModel *model = _allMessageDic[message.msgId];
  if (!model) {
    return;
  }
}

- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
  if (error != nil) {
    JMUIChatModel *model = [[JMUIChatModel alloc] init];
    [model setErrorMessageChatModelWithError:error];
    [self addMessage:model];
    return;
  }
  
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  if (message.contentType == kJMSGContentTypeCustom) {
    return;
  }
  NSLog(@"Event - receiveMessageNotification");

  dispatch_async(dispatch_get_main_queue(), ^{
        if (!message) {
          NSLog(@"get the nil message .");
          return;
        }
    
        if (_allMessageDic[message.msgId] != nil) {
          NSLog(@"该条消息已加载");
          return;
        }
    
        if (message.contentType == kJMSGContentTypeEventNotification) {
          if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
              && ![((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
          }
        }
    
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
          return;
        }
    
        JMUIChatModel *model = [[JMUIChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        [self addmessageShowTimeData:message.timestamp];
        [self addMessage:model];
      });
}

#pragma -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_allMessageIdArr count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!_isNoMoreHistoryMsg) {
    if (indexPath.row == 0) { //这个是第 0 行 用于刷新
      return 40;
    }
  }
  NSString *messageId = _allMessageIdArr[indexPath.row];
  JMUIChatModel *model = _allMessageDic[messageId ];
  if (model.isTime == YES) {
    return 31;
  }
  
  if (model.message.contentType == kJMSGContentTypeEventNotification) {
    return model.contentHeight + 17;
  }
  
  if (model.message.contentType == kJMSGContentTypeText) {
    return model.contentHeight + 17;
  } else if (model.message.contentType == kJMSGContentTypeImage) {
    
    if (model.imageSize.height == 0) {
      [model setupImageSize];
    }
    return model.imageSize.height < 44?59:model.imageSize.height + 14;
    
  } else if (model.message.contentType == kJMSGContentTypeVoice) {
    return 69;
  } else {
    return 49;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!_isNoMoreHistoryMsg) {
    JMUILoadMessageTableViewCell *cell = [JMUIMessageCellMaker LoadingCellInTable:_messageListTable];
    [cell startLoading];
    return cell;
  }
  
  NSString *messageId = _allMessageIdArr[indexPath.row];
  if (!messageId) {
    NSLog(@"messageId is nil%@",messageId);
    return nil;
  }
  
  JMUIChatModel *model = _allMessageDic[messageId];
  if (!model) {
    NSLog(@"JCHATChatModel is nil%@", messageId);
    return nil;
  }
  
  if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
    JMUIShowTimeCell *cell = [JMUIMessageCellMaker timeCellInTable:_messageListTable];
    [cell layoutModel:model];
    return cell;
  } else {
    JMUIMessageTableViewCell *cell = [JMUIMessageCellMaker messageCellInTable:_messageListTable];
    [cell setCellData:model delegate:self indexPath:indexPath];
    return cell;
  }
}

#pragma -mark JMUIToolBarDelegate
- (void)inputTextViewDidEndEditing:(JMUIMessageTextView *)messageInputTextView {
  NSLog(@"Did End Editing");
  [_conversation sendTextMessage:messageInputTextView.text];
}

- (void)sendText :(NSString *)text {
  NSLog(@"send text");
  JMSGMessage *message = nil;
  JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
  JMUIChatModel *model = [[JMUIChatModel alloc] init];
  
  message = [_conversation createMessageWithContent:textContent];
  [_conversation sendMessage:message];
  [self addmessageShowTimeData:message.timestamp];
  [model setChatModelWith:message conversationType:_conversation];
  [self addMessage:model];
}
#pragma -mark JMUIMoreViewDelegate



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
