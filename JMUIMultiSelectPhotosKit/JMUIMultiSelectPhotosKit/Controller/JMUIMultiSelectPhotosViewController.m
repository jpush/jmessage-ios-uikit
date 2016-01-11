//
//  HMPhotoPickerViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "JMUIMultiSelectPhotosViewController.h"
#import "JMUIAlbumViewController.h"
#import "JMUIPhotoPickerConstants.h"

@interface JMUIMultiSelectPhotosViewController ()
@property(strong, nonatomic)JMUIAlbumViewController *albumVC;
@end

@implementation JMUIMultiSelectPhotosViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
//  _albumVC = [[JMUIAlbumViewController alloc] init];
  _albumVC = [[JMUIAlbumViewController alloc] initWithNibName:FrameworkNibResourcesWithName(@"JMUIAlbumViewController") bundle:nil];
  _albumVC.photoDelegate = _photoDelegate;
  [self pushViewController:_albumVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
