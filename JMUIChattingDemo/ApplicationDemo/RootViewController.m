//
//  RootViewController.m
//  JMUIKit
//
//  Created by oshumini on 16/1/6.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "RootViewController.h"
#import "JMUIChattingViewController.h"
#import <JMessage/JMessage.h>
#import "AppDelegate.h"
#import "JMUIChattingDatasource.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "MyConversationViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickToLogin:(id)sender {
  [self loginUser];
}

- (void)loginUser {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
    [self getSingleConversation];
  } else {
    [MBProgressHUD showMessage:@"正在登录" toView:self.view];
    
    [JMSGUser loginWithUsername:@"6661" password:@"111111" completionHandler:^(id resultObject, NSError *error) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error) {
        NSLog(@" 登录出错");
        return ;
      }
      [[NSUserDefaults standardUserDefaults] setObject:@"6661" forKey:kuserName];
      [self getSingleConversation];
    }];
  }
}


- (void)getSingleConversation {
  JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:@"5558"];
  if (conversation == nil) {
    [MBProgressHUD showMessage:@"获取会话" toView:self.view];
    
    [JMSGConversation createSingleConversationWithUsername:@"5558" completionHandler:^(id resultObject, NSError *error) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error) {
        NSLog(@"创建会话失败");
        return ;
      }
      
      MyConversationViewController *conversationVC = [MyConversationViewController new];
      conversationVC.conversation = (JMSGConversation *)resultObject;
      [self.navigationController pushViewController:conversationVC animated:YES];
    }];
  } else {
    MyConversationViewController *conversationVC = [MyConversationViewController new];
    conversationVC.conversation = conversation;
    [self.navigationController pushViewController:conversationVC animated:YES];
  }
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
