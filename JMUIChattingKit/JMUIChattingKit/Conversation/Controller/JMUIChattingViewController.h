//
//  JMUIConversationViewController.h
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMUIInputToolbar.h"
#import "JMUIMoreView.h"
#import "JMUIInputView.h"
#import <JMessage/JMessage.h>
#import "JMUIAudioPlayerHelper.h"
#import <JMUICommon/JMUICommon.h>
#import "JMUIMessageTableView.h"

@interface JMUIConversationViewController : UIViewController<
UITableViewDataSource,
UITableViewDelegate,
JMUIToolBarDelegate,
JMUIMoreViewDelegate,
JMessageDelegate,
UIImagePickerControllerDelegate
>

@property (strong, nonatomic)JMSGConversation *conversation;
@property (strong, nonatomic)JMUIInputView *jmuiInputView;
@property (strong, nonatomic)JMUIMessageTableView *messageListTable;

/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;

@end
