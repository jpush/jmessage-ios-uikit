//
//  JCHATMessageTableViewCell.h
//  JChat
//
//  Created by HuminiOS on 15/7/13.
//  Copyright (c) 2015年 HXHG. All rights reserved.

#import <UIKit/UIKit.h>
#import "JMUIMessageContentView.h"
#import "JMUIAudioPlayerHelper.h"
#import "JMUIChatModel.h"
@class JMUIMessageTableViewCell;

@protocol playVoiceDelegate <NSObject>
@optional
- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)getContinuePlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)selectHeadView:(JMUIChatModel *)model;

- (void)setMessageIDWithMessage:(JMSGMessage *)message
                      chatModel:(JMUIChatModel * __strong *)chatModel
                          index:(NSInteger)index;
@end

@protocol PictureDelegate <NSObject>
@optional
- (void)tapPicture :(NSIndexPath *)index
           tapView :(UIImageView *)tapView
      tableViewCell:(JMUIMessageTableViewCell *)tableViewCell;

- (void)tapHeadView:(NSIndexPath *)index
           headView:(UIImageView *)headView
      tableViewCell:(JMUIMessageTableViewCell *)tableViewCell;
@end


@interface JMUIMessageTableViewCell : UITableViewCell <XHAudioPlayerHelperDelegate,
playVoiceDelegate,JMSGMessageDelegate>

@property(strong,nonatomic)UIImageView *headView;
@property(strong,nonatomic)JMUIMessageContentView *messageContent;
@property(strong,nonatomic)JMUIChatModel *model;
@property(weak, nonatomic)JMSGConversation *conversation;
@property(weak, nonatomic) id delegate;

@property (strong, nonatomic) UIImageView *sendFailView;
@property (strong, nonatomic) UIActivityIndicatorView *circleView;

//image
@property (strong, nonatomic) UILabel *percentLabel;

//voice
@property(assign, nonatomic)BOOL continuePlayer;
@property(assign, nonatomic)BOOL isPlaying;
@property(assign, nonatomic)NSInteger index;//voice 语音图片的当前显示
@property(strong, nonatomic)NSIndexPath *indexPath;
@property(strong, nonatomic)UIView *readView;
@property(strong, nonatomic)UILabel *voiceTimeLabel;

- (void)playVoice;
- (void)setCellData:(JMUIChatModel *)model
           delegate:(id <playVoiceDelegate>)delegate
          indexPath:(NSIndexPath *)indexPath
;
- (void)layoutAllView;
@end


