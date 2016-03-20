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
//  identify = @"JMUIShowTimeCell";
//  JMUIShowTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//  if (!cell) {
//    [tableView registerNib:[UINib nibWithNibName:identify bundle:[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"JMUIChattingKitResource" withExtension:@"bundle"]]] forCellReuseIdentifier:identify];
//    cell = [tableView dequeueReusableCellWithIdentifier:identify];
//  }
//  NSLog(@"message tableview show time cell is %@",cell);
//  return (JMUIShowTimeCell *)cell;
  
  identify = @"JMUIFootTableViewCell";
  JMUIFootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    [tableView registerNib:[UINib nibWithNibName:identify bundle:[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"JMUIGroupChatDetailKitResource" withExtension:@"bundle"]]] forCellReuseIdentifier:identify];
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
  }
  return (JMUIFootTableViewCell *)cell;
}

+ (JMUIGroupMemberCollectionViewCell *)groupMemberCellInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  identify = @"JMUIGroupMemberCollectionViewCell";
    JMUIGroupMemberCollectionViewCell *cell = (JMUIGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
  if (!cell) {
    [collectionView registerNib:[UINib nibWithNibName:identify bundle:[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"JMUIGroupChatDetailKitResource" withExtension:@"bundle"]]]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:@"JCHATFootTableCollectionReusableView"];
    cell = (JMUIGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
  }
  return (JMUIGroupMemberCollectionViewCell *)cell;
}

+ (JMUIFootTableCollectionReusableView *)footTableSuplementInCollection:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  identify = @"JCHATGroupMemberCollectionViewCell";
  JMUIFootTableCollectionReusableView *footTable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                   withReuseIdentifier:identify
                                                          forIndexPath:indexPath];
  if (!footTable) {
    [collectionView registerNib:[UINib nibWithNibName:identify bundle:[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"JMUIGroupChatDetailKitResource" withExtension:@"bundle"]]]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:@"JCHATFootTableCollectionReusableView"];
    footTable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                   withReuseIdentifier:identify
                                                          forIndexPath:indexPath];
  }
  return (JMUIFootTableCollectionReusableView *)footTable;
}
@end
