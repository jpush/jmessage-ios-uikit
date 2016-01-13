//
//  JMUIMessageCellMaker.h
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMUIGroupMemberCollectionViewCell.h"
#import "JMUIFootTableCollectionReusableView.h"
#import "JMUIFootTableViewCell.h"

@interface JMUIGroupChatDetailReuseCellMaker : NSObject

+ (JMUIFootTableViewCell *)footTableCell:(UITableView *)tableView;

+ (JMUIGroupMemberCollectionViewCell *)groupMemberCellInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

+ (JMUIFootTableCollectionReusableView *)footTableSuplementInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
