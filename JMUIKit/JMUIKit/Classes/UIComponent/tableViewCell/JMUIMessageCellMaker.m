//
//  JMUIMessageCellMaker.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIMessageCellMaker.h"

@implementation JMUIMessageCellMaker
+ (JMUIMessageTableViewCell *)messageCellInTable:(UITableView *)tableView {
  static NSString *identify = @"JMUIMessageTableViewCell";
  JMUIMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {

    [tableView registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUIMessageTableViewCell *)cell;
}

+ (JMUILoadMessageTableViewCell *)LoadingCellInTable:(UITableView *)tableView {
  static NSString *identify = @"JMUILoadMessageTableViewCell";
  JMUILoadMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    
    [tableView registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUILoadMessageTableViewCell *)cell;
}

+ (JMUIShowTimeCell *)timeCellInTable:(UITableView *)tableView {
  static NSString *identify = @"JMUIShowTimeCell";
  JMUIShowTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    [tableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUIShowTimeCell *)cell;
}

@end
