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
#import "JMUIGroupMemberCollectionViewCell.h"
#import "JMUIFootTableCollectionReusableView.h"
#import "JMUIFootTableViewCell.h"

@interface JMUIReuseCellMaker : NSObject
+ (JMUIMessageTableViewCell *)messageCellInTable:(UITableView *)tableView;

+ (JMUILoadMessageTableViewCell *)LoadingCellInTable:(UITableView *)tableView;

+ (JMUIShowTimeCell *)timeCellInTable:(UITableView *)tableView;

+ (JMUIFootTableViewCell *)footTableCell:(UITableView *)tableView;

+ (JMUIGroupMemberCollectionViewCell *)groupMemberCellInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

+ (JMUIFootTableCollectionReusableView *)footTableSuplementInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
