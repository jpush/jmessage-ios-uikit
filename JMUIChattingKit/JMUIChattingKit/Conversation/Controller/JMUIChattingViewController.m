//
//  JMUIConversationViewController.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIChattingViewController.h"
#import "JMUIChattingReuseCellMaker.h"
#import <JMUICommon/JMUICommon.h>
#import "JMUIChattingDatasource.h"
#import "JMUIChattingLayout.h"
#import <JMUICommon/MBProgressHUD+Add.h>
#import <JMUICommon/MBProgressHUD.h>

#define messageTableColor [UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]

static NSInteger const interval = 60*2;
static NSInteger const messagePageNumber = 25;
static NSInteger const messagefristPageNumber = 20;

@interface JMUIConversationViewController (){
  NSInteger messageOffset;
  NSArray *array;
}

@property (strong, nonatomic)JMUIChattingDatasource *messageDatasource; //负责处理消息列表数据
@property (strong, nonatomic)JMUIChattingLayout *conversationLayout;  //负责处理布局
@end

@implementation JMUIConversationViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
  self.title = @"Conversation";
  [self addNotification];
  [self setupData];
  [self setupAllViews];

  [JMessage addDelegate:self withConversation:self.conversation];
}

- (void)viewDidLayoutSubviews {
  _messageListTable.frame = CGRectMake(0, 0, kApplicationWidth, self.view.frame.size.height - 45);
  [_conversationLayout messageTableScrollToBottom:NO];
}

- (void)addNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)setupData {
  _messageDatasource = [[JMUIChattingDatasource alloc] initWithConversation:_conversation
                                                               showTimeInterval:60 * 5
                                                             fristPageMsgNumber:20
                                                                          limit:11];
  [_messageDatasource getPageMessage];
}

- (void)setupAllViews {
  _messageListTable = [[UITableView alloc] initWithFrame:CGRectZero];
  _messageListTable.delegate = self;
  _messageListTable.dataSource = self;
  _jmuiInputView = [JMUIInputView new];
  
  [self.view addSubview: _messageListTable];
  [self.view addSubview:_jmuiInputView];
  _jmuiInputView.delegate = self;
  _messageListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  _messageListTable.backgroundColor = messageTableColor;
  _conversationLayout = [[JMUIChattingLayout alloc] initWithInputView:_jmuiInputView
                                                                tableView:_messageListTable];
  
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapClick:)];
  [self.view addGestureRecognizer:gesture];
}

- (void)tapClick:(UIGestureRecognizer *)gesture
{
  [_conversationLayout hideKeyboard];
  [_conversationLayout hideMoreView];
}

- (void)appendMessage:(JMUIChatModel *)model {
  [_messageDatasource appendMessage:model];
  [_conversationLayout appendTableViewCellAtLastIndex:[_messageDatasource messageCount]];
}

- (void)appendMessageShowTimeData:(NSNumber *)timeNumber {
  JMUIChatModel *lastModel = [_messageDatasource lastMessage];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if (timeInterVal > 1999999999) {
    timeInterVal /= 1000;
  }
  
  if ([_messageDatasource messageCount] > 0 && lastModel.isTime == NO) {
    NSTimeInterval lastTimeInterVal = [lastModel.messageTime doubleValue];
    
    if (lastTimeInterVal > 1999999999) {
      lastTimeInterVal /= 1000;
    }
    
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:lastTimeInterVal];
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
    [MBProgressHUD showMessage:alert?:[error description] view:self.view];
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

- (void)onLoginUserKicked {
  UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"登录状态出错"
                                                     message:@"你已在别的设备上登录!"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
  [alertView show];
}

#pragma -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
      JMUILoadMessageTableViewCell *cell = [JMUIChattingReuseCellMaker LoadingCellInTable:_messageListTable];
      [cell startLoading];
      return cell;
    }
  }

  JMUIChatModel *model = [_messageDatasource getMessageWithIndex:indexPath.row];
  if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
    JMUIShowTimeCell *cell = [JMUIChattingReuseCellMaker timeCellInTable:_messageListTable];
    [cell layoutModel:model];
    return cell;
  } else {
    JMUIMessageTableViewCell *cell = [JMUIChattingReuseCellMaker messageCellInTable:_messageListTable];
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

- (void)pressMoreBtnClick :(UIButton *)btn {
  [_conversationLayout hideKeyboard];
  [_conversationLayout showMoreView];
}

- (void)noPressmoreBtnClick :(UIButton *)btn {
  [_conversationLayout hideKeyboard];
  [_conversationLayout showMoreView];
}
- (void)pressVoiceBtnToHideKeyBoard {
  [_conversationLayout hideMoreView];
  [_conversationLayout hideKeyboard];
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


#pragma -mark Notification listener
- (void)inputKeyboardWillShow:(NSNotification *)notification {
  CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  [_conversationLayout showKeyboard: keyBoardFrame.size.height];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
