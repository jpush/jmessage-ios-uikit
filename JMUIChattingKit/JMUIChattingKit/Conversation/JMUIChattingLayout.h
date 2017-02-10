//
//  JMUIConversationLayout.h
//  JMUIKit
//
//  Created by oshumini on 16/1/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JMUIInputView.h"

@interface JMUIChattingLayout : NSObject

- (instancetype)initWithInputView:(JMUIInputView *)inputView tableView:(UITableView *)tableview;

/**
 *  插入cells 到Tableview指定的行
 */
- (void)insertTableViewCellAtRows:(NSArray *)addIndexs;

/**
 *  添加cells 拼接到Tableview最后
 */
- (void)appendTableViewCellAtLastIndex:(NSInteger)index;

/**
 *  滚动TableView到最后一行
 */
- (void)messageTableScrollToBottom:(BOOL)animation;

/**
 *  滚动TableView 到指定的一行的底部
 */
- (void)messageTableScrollToIndeCell:(NSInteger)index;


/**
 *  隐藏keyboard
 */
- (void)hideKeyboard;

/**
 *  显示弹出moreView
 */
- (void)showMoreView;

- (void)showKeyboard:(CGFloat)keybordHeight;

- (void)showKeyboard:(CGFloat)keybordHeight withDuration:(CGFloat)duration;
/**
 *  隐藏弹出moreView
 */
- (void)hideMoreView;
@end
