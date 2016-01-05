//
//  JMUIConversationViewController.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIConversationViewController.h"
#import "JMUIReuseCellMaker.h"
#import "JMUIStringUtils.h"
#import "JMUIFileManager.h"
#import "JMUIConversationDatasource.h"
#import "JMUIConversationLayout.h"

#define interval 60*2 //static =const
#define messageTableColor [UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]

static NSInteger const messagePageNumber = 25;
static NSInteger const messagefristPageNumber = 20;

@interface JMUIConversationViewController (){
  NSInteger messageOffset;
  NSArray *array;
}

@property (strong, nonatomic)JMUIConversationDatasource *messageDatasource; //负责处理消息列表数据
@property (strong, nonatomic)JMUIConversationLayout *conversationLayout;  //负责处理布局
@end

@implementation JMUIConversationViewController
- (IBAction)clickToScrollbottom:(id)sender {
  [_conversationLayout messageTableScrollToBottom:NO];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
  self.title = @"Conversation";
  _inputView.delegate = self;
  
  [self setupData];
  [self setupAllViews];

  [JMessage addDelegate:self withConversation:self.conversation];
}

- (void)viewDidLayoutSubviews {
  [_conversationLayout messageTableScrollToBottom:NO];
}

- (void)setupData {
//  _allMessageDic = @{}.mutableCopy;
//  _allMessageIdArr = @[].mutableCopy;

  [self getSingleConversation];
}

- (void)setupAllViews {
  _messageListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  _messageListTable.backgroundColor = messageTableColor;
  _conversationLayout = [[JMUIConversationLayout alloc] initWithInputView:_inputView tableView:_messageListTable];
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
      _messageDatasource = [[JMUIConversationDatasource alloc] initWithConversation:_conversation
                                                                   showTimeInterval:60 * 5
                                                                 fristPageMsgNumber:20
                                                                              limit:11];
      [_messageDatasource getPageMessage];
    }];
  } else {
    _conversation = conversation;
    _messageDatasource = [[JMUIConversationDatasource alloc] initWithConversation:_conversation
                                                                 showTimeInterval:60 * 5
                                                               fristPageMsgNumber:20
                                                                            limit:11];
    [_messageDatasource getPageMessage];
  }
}
- (void)appendMessage:(JMUIChatModel *)model {
  [_messageDatasource appendMessage:model];
  [_conversationLayout appendTableViewCellAtLastIndex:[_messageDatasource messageCount]];
}

- (void)appendMessageShowTimeData:(NSNumber *)timeNumber {
  JMUIChatModel *lastModel = [_messageDatasource lastMessage];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  
  if ([_messageDatasource messageCount] > 0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self appendTimeData:timeInterVal];
    }
  } else if ([_messageDatasource messageCount] == 0) {//首条消息显示时间
    [self appendTimeData:timeInterVal];
  } else {
    NSLog(@"不用显示时间");
  }
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

- (void)appendTimeData:(NSTimeInterval)timeInterVal {
  [_messageDatasource appendTimeData:timeInterVal];
  [_conversationLayout appendTableViewCellAtLastIndex:[_messageDatasource messageCount]];
}

- (void)relayoutTableCellWithMsgId:(NSString *) messageId{
  if ([messageId isEqualToString:@""]) {
    return;
  }

  NSIndexPath *indexPath = [_messageDatasource tableIndexPathWithMessageId:messageId];
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
}

- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
  if (error != nil) {
    JMUIChatModel *model = [[JMUIChatModel alloc] init];
    [model setErrorMessageChatModelWithError:error];
    [self appendMessage:model];
    return;
  }
  
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  if (message.contentType == kJMSGContentTypeCustom) {
    return;
  }
  NSLog(@"Event - OnReceiveMessage");

  dispatch_async(dispatch_get_main_queue(), ^{
        if (!message) {
          NSLog(@"get the nil message .");
          return;
        }
    
        if ([_messageDatasource getMessageWithMsgId:message.msgId] != nil) {
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
        [self appendMessageShowTimeData:message.timestamp];
        [self appendMessage:model];
      });
}

#pragma -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return [_allMessageIdArr count];
  return [_messageDatasource messageCount];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (![_messageDatasource noMoreHistoryMessage]) {
    if (indexPath.row == 0) { //这个是第 0 行 用于刷新
      return 40;
    }
  }
  JMUIChatModel *model = [_messageDatasource getMessageWithIndex:indexPath.row];
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
  if (![_messageDatasource noMoreHistoryMessage]) {
    if (indexPath.row == 0) {
      JMUILoadMessageTableViewCell *cell = [JMUIReuseCellMaker LoadingCellInTable:_messageListTable];
      [cell startLoading];
      return cell;
    }
  }

  JMUIChatModel *model = [_messageDatasource getMessageWithIndex:indexPath.row];
  if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
    JMUIShowTimeCell *cell = [JMUIReuseCellMaker timeCellInTable:_messageListTable];
    [cell layoutModel:model];
    return cell;
  } else {
    JMUIMessageTableViewCell *cell = [JMUIReuseCellMaker messageCellInTable:_messageListTable];
    [cell setCellData:model delegate:self indexPath:indexPath];
    return cell;
  }
}

#pragma -mark JMUIToolBarDelegate
- (void)inputTextViewDidEndEditing:(JMUIMessageTextView *)messageInputTextView {
  NSLog(@"Did End Editing");
}

- (void)sendText :(NSString *)text {
  NSLog(@"send text");
  JMSGMessage *message = nil;
  JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
  JMUIChatModel *model = [[JMUIChatModel alloc] init];
  
  message = [_conversation createMessageWithContent:textContent];
  [_conversation sendMessage:message];
  [self appendMessageShowTimeData:message.timestamp];
  [model setChatModelWith:message conversationType:_conversation];
  [self appendMessage:model];
}

- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
  NSLog(@"Action - SendMessageWithVoice");
  
  if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
    if ([voiceDuration integerValue]<0.5) {
      NSLog(@"录音时长小于 0.5s");
    } else {
      NSLog(@"录音时长大于 60s");
    }
    return;
  }
  
  JMSGMessage *voiceMessage = nil;
  JMUIChatModel *model =[[JMUIChatModel alloc] init];
  JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                 voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
  
  voiceMessage = [_conversation createMessageWithContent:voiceContent];
  [_conversation sendMessage:voiceMessage];
  [model setChatModelWith:voiceMessage conversationType:_conversation];
  [JMUIFileManager deleteFile:voicePath];
  [self appendMessage:model];
}

- (void)didStartRecordingVoiceAction {
  NSLog(@"Action - didStartRecordingVoice");
  [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
  NSLog(@"Action - didCancelRecordingVoice");
  [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
  NSLog(@"Action - didFinishRecordingVoiceAction");
  [self finishRecorded];
}

- (void)didDragOutsideAction {
  NSLog(@"Action - didDragOutsideAction");
  [self resumeRecord];
}

- (void)didDragInsideAction {
  NSLog(@"Action - didDragInsideAction");
  [self pauseRecord];
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
  if (!_voiceRecordHUD) {
    _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
  }
  return _voiceRecordHUD;
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
  if (!_voiceRecordHelper) {
    WEAKSELF
    _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
    
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
      NSLog(@"已经达到最大限制时间了，进入下一步的提示");
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf finishRecorded];
    };
    
    _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
    };
    
    _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
  }
  return _voiceRecordHelper;
}

- (NSString *)getRecorderPath {
  NSString *recorderPath = nil;
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yy-MMMM-dd";
  recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
  dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
  recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
  return recorderPath;
}

- (void)startRecord {
  NSLog(@"Action - startRecord");
  [self.voiceRecordHUD startRecordingHUDAtView:self.view];
  [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
  }];
}

- (void)finishRecorded {
  NSLog(@"Action - finishRecorded");
  WEAKSELF
  [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
                       voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
  }];
}

- (void)pauseRecord {
  [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
  [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
  WEAKSELF
  [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    
  }];
}

#pragma -mark JMUIMoreViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
