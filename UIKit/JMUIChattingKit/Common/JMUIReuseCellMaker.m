//
//  JMUIMessageCellMaker.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIReuseCellMaker.h"

static NSString *identify = nil;

@implementation JMUIReuseCellMaker
+ (JMUIMessageTableViewCell *)messageCellInTable:(UITableView *)tableView {
  identify = @"JMUIMessageTableViewCell";
  JMUIMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {

    [tableView registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUIMessageTableViewCell *)cell;
}

+ (JMUILoadMessageTableViewCell *)LoadingCellInTable:(UITableView *)tableView {
  identify = @"JMUILoadMessageTableViewCell";
  JMUILoadMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    
    [tableView registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUILoadMessageTableViewCell *)cell;
}

+ (JMUIShowTimeCell *)timeCellInTable:(UITableView *)tableView {
  identify = @"JMUIShowTimeCell";
  JMUIShowTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    [tableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUIShowTimeCell *)cell;
}
@end
