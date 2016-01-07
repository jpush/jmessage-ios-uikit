//
//  JCHATGroupMemberCollectionViewCell.h
//  JChat
//
//  Created by HuminiOS on 15/11/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
 
@interface JMUIGroupMemberCollectionViewCell : UICollectionViewCell

- (void)setDataWithUser:(JMSGUser *)user withEditStatus:(BOOL)isInEdit;
- (void)setDeleteMember;
- (void)setAddMember;
@end
