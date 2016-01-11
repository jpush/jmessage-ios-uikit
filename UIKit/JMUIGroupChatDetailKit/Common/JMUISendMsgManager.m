//
//  JCHATSendMsgManager.m
//  JChat
//
//  Created by HuminiOS on 15/10/30.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUISendMsgManager.h"
#import "JMUISendMsgController.h"
#import "JMUIStringUtils.h"

@implementation JMUISendMsgManager
+ (JMUISendMsgManager *)ins {
  static JMUISendMsgManager *sendMsgManage = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sendMsgManage = [[JMUISendMsgManager alloc] init];
  });
  return sendMsgManage;
}

- (id)init {
  self = [super init];
  if (self) {
    _sendMsgListDic  = @{}.mutableCopy;
    _textDraftDic = @{}.mutableCopy;
  }
  return self;
}

- (void)addMessage:(JMSGMessage *)imgMsg withConversation:(JMSGConversation *)conversation {
  NSString *key = nil;
  if (conversation.conversationType == kJMSGConversationTypeSingle) {
    key = ((JMSGUser *)conversation.target).username;
  } else {
    key = ((JMSGGroup *)conversation.target).gid;
  }
  
  if (_sendMsgListDic[key] == nil) {
    JMUISendMsgController *sendMsgCtl = [[JMUISendMsgController alloc] init];
    sendMsgCtl.msgConversation = conversation;
    [sendMsgCtl addDelegateForConversation:conversation];
    [sendMsgCtl prepareImageMessage:imgMsg];
    _sendMsgListDic[key] = sendMsgCtl;
  } else {
    JMUISendMsgController *sendMsgCtl = _sendMsgListDic[key];
    [sendMsgCtl prepareImageMessage:imgMsg];
  }
}

- (void)updateConversation:(JMSGConversation *)conversation withDraft:(NSString *)draftString {
  NSString *key = nil;
  key = [JMUIStringUtils conversationIdWithConversation:conversation];
  _textDraftDic[key] = draftString;
}

- (NSString *)draftStringWithConversation:(JMSGConversation *)conversation {
  NSString *key = nil;
  key = [JMUIStringUtils conversationIdWithConversation:conversation];
  return _textDraftDic[key] ? _textDraftDic[key] : @"";
}
@end
