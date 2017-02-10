//
//  JMUIConversationDatasource.h
//  JMUIKit
//
//  Created by oshumini on 16/1/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMUIChatModel.h"

@interface JMUIChattingDatasource : NSObject
@property (strong, nonatomic)JMSGConversation *conversation;

@property (strong, nonatomic)NSMutableArray *allMessageIdArr;
@property (strong, nonatomic)NSMutableDictionary *allMessageDic;

@property (nonatomic, readonly)NSInteger messageLimit;     //每页刷新获取消息的条数
@property (nonatomic, readonly)NSInteger messagefristPageNumber; //获取消息第一页的消息数量

//NSMutableArray *_imgDataArr;
@property (strong, nonatomic)NSMutableArray *imgMsgModelArr; //消息列表的所有图片消息

@property (nonatomic, readonly)NSInteger showTimeInterval; //两条消息相隔多久显示一条时间戳

- (instancetype)initWithConversation:(JMSGConversation*)session
                    showTimeInterval:(NSTimeInterval)timeInterval
                  fristPageMsgNumber:(NSInteger)pageNumber
                               limit:(NSInteger)limit;

/**
 *  清除所有的消息缓存
 */
- (void)cleanCache;

/**
 *  把消息拼接到消息列表的最后
 */
- (void)appendMessage:(JMUIChatModel *)model;

/**
 *  拼接时间消息到消息列表最后一行
 */
- (void)appendTimeData:(NSTimeInterval)timeInterVal;

/**
 *  插入消息到消息列表的指定行
 */
- (void)addmessage:(JMUIChatModel *)model toIndex:(NSInteger)index;

/**
 *  分页获取历史消息
 */
- (void)getPageMessage;

/**
 *  分页获取历史消息
 */
- (void)getMoreMessage;

/**
 *  分页获取历史消息
 */
- (NSInteger)getImageIndex:(JMUIChatModel *)model;

/**
 *  返回消息数量
 */
- (NSInteger)messageCount;

/**
 *  用于标识还有没更多历史消息
 */
- (BOOL)noMoreHistoryMessage;

/**
 *  通过index 获取置顶消息model
 */
- (JMUIChatModel *)getMessageWithIndex:(NSInteger)index;

/**
 *  通过msgId 获取指定消息model
 */
- (JMUIChatModel *)getMessageWithMsgId:(NSString *)messageId;

/**
 *  返回最后一条消息
 */
- (JMUIChatModel *)lastMessage;

/**
 *  返回 指定message 的位置
 */
- (NSIndexPath *)tableIndexPathWithMessageId:(NSString *)messageId;

@end
