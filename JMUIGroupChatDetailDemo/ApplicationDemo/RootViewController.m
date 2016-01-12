//
//  RootViewController.m
//  JMUIKit
//
//  Created by oshumini on 16/1/6.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "RootViewController.h"
#import <JMessage/JMessage.h>
#import "AppDelegate.h"
//#import "MBProgressHUD.h"
//#import "MBProgressHUD+Add.h"
#import "MyGroupDetailViewController.h"

#define kuserName @"userName"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickToLogin:(id)sender {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
    [self getGroupConversation];
    NSLog(@"huangmin 111111  %@",[[NSUserDefaults standardUserDefaults] objectForKey:kuserName]);
  } else {
    [self registerAccount];
  }
}

- (void)loginUser:(NSString *)userName {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {

    [self getGroupConversation];
  } else {
//    [MBProgressHUD showMessage:@"正在登录" toView:self.view];
    
    [JMSGUser loginWithUsername:userName password:@"111111" completionHandler:^(id resultObject, NSError *error) {
//      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error) {
        NSLog(@" 登录出错");
        return ;
      }
      [self getGroupConversation];
      [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kuserName];
    }];
  }
}

- (void)getGroupConversation {
  NSString *groupId = [[NSUserDefaults standardUserDefaults] objectForKey:@"groupID"];
  if (groupId) {
    JMSGConversation *tmpconversation = [JMSGConversation groupConversationWithGroupId:groupId];
    if (tmpconversation) {
      JMSGConversation *conversation = tmpconversation;
      MyGroupDetailViewController *groupVC = [MyGroupDetailViewController new];
      groupVC.conversation = conversation;
      [self.navigationController pushViewController:groupVC animated:YES];
    }
    
    return;
  } else {
    [JMSGGroup createGroupWithName:@"GroupConversation" desc:nil memberArray:@[] completionHandler:^(id group, NSError *error) {
      if (error) {
        NSLog(@"create Group fail");
        return ;
      }
      
      [JMSGConversation createGroupConversationWithGroupId:((JMSGGroup *)group).gid completionHandler:^(id resultObject, NSError *error) {
        if (error) {
          NSLog(@"create group conversation fail");
          return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:((JMSGGroup *)group).gid forKey:@"groupID"];
        JMSGConversation *conversation = resultObject;
        MyGroupDetailViewController *groupVC = [MyGroupDetailViewController new];
        groupVC.conversation = conversation;
        [self.navigationController pushViewController:groupVC animated:YES];
      }];
    }];
  }
}

- (NSString *)getRegisterUserName {// 随机生成要注册的用户名
  NSString *string = [[NSString alloc]init];
  for (int i = 0; i < 5; i++) {
    int number = arc4random() % 36;
    if (number < 10) {
      int figure = arc4random() % 10;
      NSString *tempString = [NSString stringWithFormat:@"%d", figure];
      string = [string stringByAppendingString:tempString];
    }else {
      int figure = (arc4random() % 26) + 97;
      char character = figure;
      NSString *tempString = [NSString stringWithFormat:@"%c", character];
      string = [string stringByAppendingString:tempString];
    }
  }
  string = [NSString stringWithFormat:@"uikit_demo_%@",string];
  return string;
}

- (void)registerAccount {
  NSString *userNameToRegister = [self getRegisterUserName];
  [JMSGUser registerWithUsername:userNameToRegister password:@"111111" completionHandler:^(id resultObject, NSError *error) {
    if (error) {
      [self registerAccount];
      return ;
    }
    [self loginUser:userNameToRegister];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
