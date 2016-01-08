//
//  JMUIMessageCellMaker.h
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMUIMessageTableViewCell.h"
#import "JMUILoadMessageTableViewCell.h"
#import "JMUIShowTimeCell.h"

@interface JMUIReuseCellMaker : NSObject
+ (JMUIMessageTableViewCell *)messageCellInTable:(UITableView *)tableView;

+ (JMUILoadMessageTableViewCell *)LoadingCellInTable:(UITableView *)tableView;

+ (JMUIShowTimeCell *)timeCellInTable:(UITableView *)tableView;

@end
