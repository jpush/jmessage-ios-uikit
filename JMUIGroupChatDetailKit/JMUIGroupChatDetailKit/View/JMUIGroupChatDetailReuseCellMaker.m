//
//  JMUIMessageCellMaker.m
//  JMUIKit
//
//  Created by oshumini on 15/12/28.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIGroupChatDetailReuseCellMaker.h"

static NSString *identify = nil;

@implementation JMUIGroupChatDetailReuseCellMaker

+ (JMUIFootTableViewCell *)footTableCell:(UITableView *)tableView {
  identify = @"JMUIGroupChatDetailKit.framework/JMUIFootTableViewCell";
  JMUIFootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    [tableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUIFootTableViewCell *)cell;
}

+ (JMUIGroupMemberCollectionViewCell *)groupMemberCellInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  identify = @"JMUIGroupChatDetailKit.framework/JMUIGroupMemberCollectionViewCell";
    JMUIGroupMemberCollectionViewCell *cell = (JMUIGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
  if (!cell) {
    [collectionView registerNib:[UINib nibWithNibName:@"JMUIGroupChatDetailKit.framework/JCHATFootTableCollectionReusableView" bundle:nil]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:@"JMUIGroupChatDetailKit.framework/JCHATFootTableCollectionReusableView"];
    cell = (JMUIGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
  }
  return (JMUIGroupMemberCollectionViewCell *)cell;
}

+ (JMUIFootTableCollectionReusableView *)footTableSuplementInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  identify = @"JMUIGroupChatDetailKit.framework/JCHATGroupMemberCollectionViewCell";
  JMUIFootTableCollectionReusableView *footTable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                   withReuseIdentifier:identify
                                                          forIndexPath:indexPath];
  if (!footTable) {
    [collectionView registerNib:[UINib nibWithNibName:@"JMUIGroupChatDetailKit.framework/JCHATFootTableCollectionReusableView" bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:@"JMUIGroupChatDetailKit.framework/JCHATFootTableCollectionReusableView"];
    footTable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                   withReuseIdentifier:identify
                                                          forIndexPath:indexPath];
  }
  return (JMUIFootTableCollectionReusableView *)footTable;
}
@end
