//
//  AppDelegate.m
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "JMUIConversationViewController.h"
#import <JMessage/JMessage.h>
#import "JMUIConstants.h"
#import "JMUIGroupDetailViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [JMessage setupJMessage:launchOptions
                   appKey:JMSSAGE_APPKEY
                  channel:CHANNEL apsForProduction:NO
                 category:nil];
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
  } else {
    //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
  }
  [self registerJPushStatusNotification];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  UIViewController *rootVC = [UIViewController new];
  rootVC.view.backgroundColor = [UIColor whiteColor];
  UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
  [MBProgressHUD showMessage:@"正在登录" toView:rootVC.view];
  self.window.rootViewController = NVC;
  [self.window makeKeyAndVisible];
  
  [self performSelector:@selector(loginUser) withObject:Nil afterDelay:6];
  return YES;
}

- (void)loginUser {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
    JMUIConversationViewController *rootVC = [JMUIConversationViewController new];
    UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = NVC;
  } else {
    [JMSGUser loginWithUsername:@"6661" password:@"111111" completionHandler:^(id resultObject, NSError *error) {
      if (error) {
        NSLog(@" 登录出错");
        return ;
      }
      [[NSUserDefaults standardUserDefaults] setObject:@"6661" forKey:kuserName];
      JMUIConversationViewController *rootVC = [JMUIConversationViewController new];

      UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
      self.window.rootViewController = NVC;
    }];
  }
}

- (void)registerJPushStatusNotification {
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidSetup:)
                        name:kJPFNetworkDidSetupNotification
                      object:nil];
  [defaultCenter addObserver:self
                    selector:@selector(networkIsConnecting:)
                        name:kJPFNetworkIsConnectingNotification
                      object:nil];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidClose:)
                        name:kJPFNetworkDidCloseNotification
                      object:nil];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidRegister:)
                        name:kJPFNetworkDidRegisterNotification
                      object:nil];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidLogin:)
                        name:kJPFNetworkDidLoginNotification
                      object:nil];
  
  [defaultCenter addObserver:self
                    selector:@selector(receivePushMessage:)
                        name:kJPFNetworkDidReceiveMessageNotification
                      object:nil];
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  // Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  
  // Required - 处理收到的通知
  [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  
  // IOS 7 Support Required
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

// notification from JPush
- (void)networkDidSetup:(NSNotification *)notification {
  NSLog(@"Event - networkDidSetup");
}

// notification from JPush
- (void)networkIsConnecting:(NSNotification *)notification {
  NSLog(@"Event - networkIsConnecting");
}

// notification from JPush
- (void)networkDidClose:(NSNotification *)notification {
  NSLog(@"Event - networkDidClose");
}

// notification from JPush
- (void)networkDidRegister:(NSNotification *)notification {
  NSLog(@"Event - networkDidRegister");
}

// notification from JPush
- (void)networkDidLogin:(NSNotification *)notification {
  NSLog(@"Event - networkDidLogin");
}

// notification from JPush
- (void)receivePushMessage:(NSNotification *)notification {
  NSLog(@"Event - receivePushMessage");
  
  NSDictionary *info = notification.userInfo;
  if (info) {
    NSLog(@"The message - %@", info);
  } else {
    NSLog(@"Unexpected - no user info in jpush mesasge");
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
