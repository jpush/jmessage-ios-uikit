//
//  RootViewController.m
//  JMUIKit
//
//  Created by oshumini on 16/1/6.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "RootViewController.h"
//#import "JMUIChattingViewController.h"
#import <JMUIChattingKit/JMUIChattingViewController.h>
#import <JMessage/JMessage.h>
#import "AppDelegate.h"

#import "MyConversationViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickToLogin:(id)sender {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
    NSLog(@"huangmin  123456  %@",[[NSUserDefaults standardUserDefaults] objectForKey:kuserName]);
    [self getSingleConversation];
  } else {
    [self registerAccount];
  }
}

- (void)loginUser:(NSString *)userName {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
    [self getSingleConversation];
  } else {
//    [MBProgressHUD showMessage:@"正在登录" toView:self.view];
    
    [JMSGUser loginWithUsername:userName password:@"111111" completionHandler:^(id resultObject, NSError *error) {
//      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error) {
        NSLog(@" 登录出错");
        return ;
      }
      [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kuserName];
      [self getSingleConversation];
    }];
  }
}


- (void)getSingleConversation {
  JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:@"5558"];
  if (conversation == nil) {
//    [MBProgressHUD showMessage:@"获取会话" toView:self.view];
    
    [JMSGConversation createSingleConversationWithUsername:@"5558" completionHandler:^(id resultObject, NSError *error) {
//      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
