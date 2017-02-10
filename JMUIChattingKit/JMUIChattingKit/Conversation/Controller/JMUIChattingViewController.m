//
//  JMUIConversationViewController.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIChattingViewController.h"
#import "JMUIChattingReuseCellMaker.h"
#import "UIImage+ResizeMagick.h"
#import "JMUISendMsgManager.h"

#import <JMUICommon/JMUICommon.h>
#import "JMUIChattingDatasource.h"
#import "JMUIChattingLayout.h"
#import <JMUICommon/MBProgressHUD+Add.h>
#import <JMUICommon/MBProgressHUD.h>
#import <MobileCoreServices/UTCoreTypes.h>

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
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardFrameChange:)
                                               name:UIKeyboardWillChangeFrameNotification
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
  _messageListTable = [[JMUIMessageTableView alloc] initWithFrame:CGRectZero];
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
      [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
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

- (void)flashToLoadMessage {
//  NSMutableArray * arrList = @[].mutableCopy;
//  NSArray *newMessageArr = [_conversation messageArrayFromNewestWithOffset:@(messageOffset) limit:@(messagePageNumber)];
//  [arrList addObjectsFromArray:newMessageArr];
//  if ([arrList count] < messagePageNumber) {// 判断还有没有新数据
//    isNoOtherMessage = YES;
//    [_allmessageIdArr removeObjectAtIndex:0];
//  }
//  
//  messageOffset += messagePageNumber;
//  for (NSInteger i = 0; i < [arrList count]; i++) {
//    JMSGMessage *message = arrList[i];
//    JCHATChatModel *model = [[JCHATChatModel alloc] init];
//    [model setChatModelWith:message conversationType:_conversation];
//    
//    if (message.contentType == kJMSGContentTypeImage) {
//      [_imgDataArr insertObject:model atIndex:0];
//      model.photoIndex = [_imgDataArr count] - 1;
//    }
//    
//    [_allMessageDic setObject:model forKey:model.message.msgId];
//    [_allmessageIdArr insertObject:model.message.msgId atIndex: isNoOtherMessage?0:1];
//    [self dataMessageShowTimeToTop:message.timestamp];// FIXME:
//  }
  [self.messageDatasource getMoreMessage];
  [_messageListTable loadMoreMessage];
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
- (void)cameraClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [picker setMediaTypes:arrMediaTypes];
    picker.showsCameraControls = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.editing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  }
}

- (void)photoClick {
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
  UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
  ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  ipc.delegate = self;
  [self presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  if ([mediaType isEqualToString:@"public.movie"]) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showMessage:@"不支持视频发送" view:self.view];
    return;
  }
  UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self prepareImageMessage:image];
//  [self dropToolBarNoAnimate]; // TODO: fix it
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
  img = [img resizedImageByWidth:upLoadImgWidth];
  
  JMSGMessage* message = nil;
  JMUIChatModel *model = [[JMUIChatModel alloc] init];
  JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
  if (imageContent) {
    message = [_conversation createMessageWithContent:imageContent];
    [[JMUISendMsgManager ins] addMessage:message withConversation:_conversation];
    [self appendMessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    
    [model setupImageSize];
    [self appendMessage:model];
  }
}

#pragma -mark Notification listener
- (void)keyboardFrameChange:(NSNotification *)notification {
//  let dic = NSDictionary(dictionary: (notification as NSNotification).userInfo!)
  NSDictionary *dic = notification.userInfo;
  NSValue *keyboardValue = dic[UIKeyboardFrameEndUserInfoKey];
  CGFloat bottomDistance = [UIScreen mainScreen].bounds.size.height - keyboardValue.CGRectValue.origin.y;
  NSNumber *duration = dic[UIKeyboardAnimationDurationUserInfoKey];
  
//  [UIView animateWithDuration:duration.doubleValue animations:^{
    [_conversationLayout showKeyboard: bottomDistance withDuration:duration.floatValue];
//  }];
  
  
//  let keyboardValue = dic.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
//  let bottomDistance = UIScreen.main.bounds.size.height - keyboardValue.cgRectValue.origin.y
//  let duration = Double(dic.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
//  
//  UIView.animate(withDuration: duration, animations: {
//    self.messageInputView.moreView?.snp.updateConstraints({ (make) -> Void in
//      make.height.equalTo(bottomDistance)
//    })
//    self.view.layoutIfNeeded()
//  }, completion: {
//    (value: Bool) in
//  })
}
- (void)inputKeyboardWillShow:(NSNotification *)notification {
//  CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//  [_conversationLayout showKeyboard: keyBoardFrame.size.height];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {

}

- (void)tapPicture :(NSIndexPath *)index
           tapView :(UIImageView *)tapView
      tableViewCell:(JMUIMessageTableViewCell *)tableViewCell {
  // TODO: get image model
//  JMUIChatModel *model = tableViewCell.model;
//  [_messageDatasource getImageIndex:model];   //获得点击图片所在图片的位置
//  _messageDatasource.imgMsgModelArr;  // 当前会话所有显示的图片 model（JMUIChatModel）
  NSLog(@"tap image content");
}

- (void)tapHeadView:(NSIndexPath *)index
           headView:(UIImageView *)headView
      tableViewCell:(JMUIMessageTableViewCell *)tableViewCell {
  NSLog(@"tap header");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
