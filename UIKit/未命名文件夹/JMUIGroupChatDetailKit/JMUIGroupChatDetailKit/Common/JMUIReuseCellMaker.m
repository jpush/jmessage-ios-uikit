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
    [collectionView registerNib:[UINib nibWithNibName:identify bundle:nil]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:identify];
    cell = (JMUIGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
  }
  return (JMUIGroupMemberCollectionViewCell *)cell;
}

+ (JMUIFootTableCollectionReusableView *)footTableSuplementInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  identify = @"JMUIGroupChatDetailKit.framework/JMUIFootTableCollectionReusableView";
  JMUIFootTableCollectionReusableView *footTable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                   withReuseIdentifier:identify
                                                          forIndexPath:indexPath];
  if (!footTable) {
    [collectionView registerNib:[UINib nibWithNibName:identify bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:identify];
    footTable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                   withReuseIdentifier:identify
                                                          forIndexPath:indexPath];
  }
  return (JMUIFootTableCollectionReusableView *)footTable;
}
@end
