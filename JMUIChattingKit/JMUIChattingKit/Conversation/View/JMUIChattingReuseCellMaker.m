//
//  JMUIMessageCellMaker.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIChattingReuseCellMaker.h"

static NSString *identify = nil;

@implementation JMUIChattingReuseCellMaker
+ (JMUIMessageTableViewCell *)messageCellInTable:(UITableView *)tableView {
  identify = @"JMUIMessageTableViewCell";
  JMUIMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {

    [tableView registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  NSLog(@"message tableview cell is %@",cell);
  return (JMUIMessageTableViewCell *)cell;
}

+ (JMUILoadMessageTableViewCell *)LoadingCellInTable:(UITableView *)tableView {
  identify = @"JMUILoadMessageTableViewCell";
  JMUILoadMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    
    [tableView registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  NSLog(@"message tableview load cell is %@",cell);
  return (JMUILoadMessageTableViewCell *)cell;
}

+ (JMUIShowTimeCell *)timeCellInTable:(UITableView *)tableView {
  identify = @"JMUIShowTimeCell";
  JMUIShowTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    [tableView registerNib:[UINib nibWithNibName:identify bundle:[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"JMUIChattingKitResource" withExtension:@"bundle"]]] forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  NSLog(@"message tableview show time cell is %@",cell);
  return (JMUIShowTimeCell *)cell;
}
@end
