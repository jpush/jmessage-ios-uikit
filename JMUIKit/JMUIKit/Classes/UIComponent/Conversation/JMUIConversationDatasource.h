//
//  JMUIConversationDatasource.h
//  JMUIKit
//
//  Created by oshumini on 16/1/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMUIChatModel.h"

@interface JMUIConversationDatasource : NSObject
@property (strong, nonatomic)JMSGConversation *conversation;

@property (strong, nonatomic)NSMutableArray *allMessageIdArr;
@property (strong, nonatomic)NSMutableDictionary *allMessageDic;

@property (nonatomic, readonly)NSInteger messageLimit;     //每页刷新获取消息的条数
@property (nonatomic, readonly)NSInteger messagefristPageNumber; //获取消息第一页的消息数量

@property (nonatomic, readonly)NSInteger showTimeInterval; //两条消息相隔多久显示一条时间戳

- (instancetype)initWithConversation:(JMSGConversation*)session
                    showTimeInterval:(NSTimeInterval)timeInterval
                  fristPageMsgNumber:(NSInteger)pageNumber
                               limit:(NSInteger)limit;

- (void)cleanCache;
- (void)addMessage:(JMUIChatModel *)model;
- (void)getPageMessage;
@end
