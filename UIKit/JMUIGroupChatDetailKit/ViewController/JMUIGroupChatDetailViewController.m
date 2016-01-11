//
//  JCHATGroupDetailViewController.m
//  JChat
//
//  Created by HuminiOS on 15/11/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JMUIGroupChatDetailViewController.h"
#import "JMUIGroupMemberCollectionViewCell.h"
#import "JMUIGroupInfoFooterReusableView.h"
#import "JMUIFootTableCollectionReusableView.h"
#import "JMUIFootTableViewCell.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "JMUIConstants.h"
#import "JMUIReuseCellMaker.h"

@interface JMUIGroupChatDetailViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate> {
  BOOL _isInEditToDeleteMember;
}

@property (strong, nonatomic)UICollectionView *groupMemberGrip;

@end

@implementation JMUIGroupChatDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  _isInEditToDeleteMember = NO;
  [self setupNavigationBar];
  [self setupGroupMemberGrip];
  [self getAllMember];
}

- (void)refreshMemberGrid {
  [self getAllMember];
  [_groupMemberGrip reloadData];
}

- (void)setupNavigationBar {
  self.title=@"群详情";
  self.navigationController.navigationBar.translucent = NO;
}

- (void)setupGroupMemberGrip {
  UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  
  _groupMemberGrip = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
  _groupMemberGrip.backgroundColor = [UIColor whiteColor];
  _groupMemberGrip.delegate = self;
  _groupMemberGrip.dataSource = self;
  [self.view addSubview:_groupMemberGrip];
  _groupMemberGrip.minimumZoomScale = 0;
  _groupMemberGrip.backgroundColor = [UIColor whiteColor];
  [_groupMemberGrip registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JMUIGroupMemberCollectionViewCell" bundle:nil]
     forCellWithReuseIdentifier:@"JMUIGroupMemberCollectionViewCell"];
  
  [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JMUIFootTableCollectionReusableView" bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:@"JMUIFootTableCollectionReusableView"];
  _groupMemberGrip.backgroundColor = [UIColor clearColor];
  _groupMemberGrip.backgroundView = [UIView new];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGripMember:)];
  [_groupMemberGrip.backgroundView addGestureRecognizer:tap];
}

- (void)tapGripMember:(id)sender {
  [self removeEditStatus];
}

- (void)removeEditStatus {
  _isInEditToDeleteMember = NO;
  [_groupMemberGrip reloadData];
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)getAllMember {
  _memberArr = [NSMutableArray arrayWithArray:[((JMSGGroup *)(_conversation.target)) memberArray]];
  [_groupMemberGrip reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (section != 0) {
    return 0;
  }
  
  JMSGGroup *group = (JMSGGroup *)_conversation.target;
  if ([group.owner isEqualToString:[JMSGUser myInfo].username]) {
    return _memberArr.count + 2;
  } else {
    return _memberArr.count +1;
  }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return CGSizeMake(52, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
  return CGSizeMake(kApplicationWidth, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"JMUIGroupMemberCollectionViewCell";
  JMUIGroupMemberCollectionViewCell *cell = (JMUIGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  if (indexPath.item == _memberArr.count) {
    [cell setAddMember];
    return cell;
  }
  
  if (indexPath.item == _memberArr.count + 1) {
    [cell setDeleteMember];
    return cell;
  }

  JMSGGroup *group = _conversation.target;
  JMSGUser *user = _memberArr[indexPath.item];
  if ([group.owner isEqualToString:user.username]) {
    [cell setDataWithUser:user withEditStatus:NO];
  } else {
    [cell setDataWithUser:user withEditStatus:_isInEditToDeleteMember];
  }
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  JMUIFootTableCollectionReusableView *footTable = nil;
  static NSString *footerIdentifier = @"JMUIFootTableCollectionReusableView";
  footTable = [_groupMemberGrip dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                    withReuseIdentifier:footerIdentifier
                                                                                           forIndexPath:indexPath];
  footTable.footTableView.delegate = self;
  footTable.footTableView.dataSource =self;
  [footTable.footTableView reloadData];
  return footTable;
}
#pragma -mark UIAlertView Delegate
- (void)tapToEditGroupName {
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"输入群名称"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
  alerView.tag = kAlertViewTagRenameGroup;
  [alerView show];
  [self removeEditStatus];
}

- (void)tapToClearChatRecord {
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"清空聊天记录"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.tag = kAlertViewTagClearChatRecord;
  [alerView show];
  [self removeEditStatus];
}

- (void)quitGroup:(UIButton *)btn
{
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"退出群聊"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.tag = kAlertViewTagQuitGroup;
  [alerView show];
  [self removeEditStatus];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)return;

  switch (alertView.tag) {
    case kAlertViewTagClearChatRecord:
    {
      if (buttonIndex ==1) {
        [self.conversation deleteAllMessages];

      }
    }
      break;
    case kAlertViewTagAddMember:
    {
      
      if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
        return;
      }

        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showMessage:@"获取成员信息" toView:self.view];
        [((JMSGGroup *)(self.conversation.target)) addMembersWithUsernameArray:@[[alertView textFieldAtIndex:0].text] completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
          if (error == nil) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf refreshMemberGrid];
          } else {
            NSLog(@"addMembersFromUsernameArray fail with error %@",error);
            [MBProgressHUD showMessage:@"添加成员失败" view:weakSelf.view];
          }
        }];
    }
      break;
    case kAlertViewTagQuitGroup:
    {
      if (buttonIndex ==1) {
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showMessage:@"正在推出群组！" toView:self.view];
        JMSGGroup *deletedGroup = ((JMSGGroup *)(self.conversation.target));
        
        [deletedGroup exit:^(id resultObject, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
          if (error == nil) {
            NSLog(@"推出群组成功");
            [MBProgressHUD showMessage:@"推出群组成功" view:weakSelf.view];
            [JMSGConversation deleteGroupConversationWithGroupId:deletedGroup.gid];
          } else {
            NSLog(@"推出群组失败");
            [MBProgressHUD showMessage:@"推出群组失败" view:weakSelf.view];
          }
        }];
      }
    }
      break;
    default:
      [MBProgressHUD showMessage:@"更新群组名称" toView:self.view];
      JMSGGroup *needUpdateGroup = (JMSGGroup *)(self.conversation.target);
      
      [JMSGGroup updateGroupInfoWithGroupId:needUpdateGroup.gid
                                       name:[alertView textFieldAtIndex:0].text
                                       desc:needUpdateGroup.desc
                          completionHandler:^(id resultObject, NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            if (error == nil) {
                              [MBProgressHUD showMessage:@"更新群组名称成功" view:self.view];
                              [self refreshMemberGrid];
                            } else {
                              [MBProgressHUD showMessage:@"更新群组名称失败" view:self.view];
                            }
                          }];
      break;
  }
  return;
}

- (void)collectionView:(UICollectionView * _Nonnull)collectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
  if (indexPath.item == _memberArr.count) {// 添加群成员
    _isInEditToDeleteMember = NO;
    [_groupMemberGrip reloadData];
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友进群"
                                                      message:@"输入好友用户名!"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alerView.tag = kAlertViewTagAddMember;
    [alerView show];
    return;
  }
  
  if (indexPath.item == _memberArr.count + 1) {// 删除群成员
    _isInEditToDeleteMember = !_isInEditToDeleteMember;
    [_groupMemberGrip reloadData];
    return;
  }

//  点击群成员头像
  JMSGUser *user = _memberArr[indexPath.item];
  JMSGGroup *group = _conversation.target;
  if (_isInEditToDeleteMember) {
    if ([user.username isEqualToString:group.owner]) {
      return;
    }
    JMSGUser *userToDelete = _memberArr[indexPath.item];
    [self deleteMemberWithUserName:userToDelete.username];
  } else {

    }
  return ;
}

- (void)deleteMemberWithUserName:(NSString *)userName {
  if ([_memberArr count] == 1) {
    return;
  }
  
  [MBProgressHUD showMessage:@"正在删除好友！" toView:self.view];
  [((JMSGGroup *)(self.conversation.target)) removeMembersWithUsernameArray:@[userName] completionHandler:^(id resultObject, NSError *error) {
    
    if (error == nil) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      [MBProgressHUD showMessage:@"删除成员成功！" view:self.view];
      [self refreshMemberGrid];
    } else {
      NSLog(@"JCHATGroupSettingCtl fail to removeMembersFromUsernameArrary");
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      [MBProgressHUD showMessage:@"删除成员错误！" view:self.view];
    }
  }];
}

- (void)quitGroup {
  UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"退出群聊"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
  alerView.tag = 400;
  [alerView show];
  [self removeEditStatus];
}

#pragma -mark FootTableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  JMUIFootTableViewCell *cell = (JMUIFootTableViewCell *)[JMUIReuseCellMaker footTableCell:tableView];
  switch (indexPath.row) {
    case 0:
      [cell setDataWithGroupName:((JMSGGroup *)_conversation.target).displayName];
      break;
    case 1:
      [cell layoutToClearChatRecord];
      break;
    case 2:
      cell.delegate = self;
      [cell layoutToQuitGroup];
      break;

    default:
      break;
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  switch (indexPath.row) {
    case 0:
      [self tapToEditGroupName];
      break;
    case 1:
      [self tapToClearChatRecord];
      break;
    case 2:
      break;
    default:
      break;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
