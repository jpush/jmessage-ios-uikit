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

@interface JMUIConversationLayout : NSObject

- (instancetype)initWithInputView:(JMUIInputView *)inputView tableView:(UITableView *)tableview;

- (void)insertTableViewCellAtRows:(NSArray *)addIndexs;

- (void)messageTableScrollToBottom:(BOOL)animation;
@end
