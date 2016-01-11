//
//  RootViewController.m
//  JMUIKit
//
//  Created by oshumini on 16/1/6.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "RootViewController.h"
//#import "JMUIAlbumViewController.h"
#import <JMUIMultiSelectPhotosKit/JMUIAlbumTableViewCell.h>
//#import "JMUIMultiSelectPhotosViewController.h"
#import <JMUIMultiSelectPhotosKit/JMUIMultiSelectPhotosViewController.h>

@interface RootViewController ()<JMUIMultiSelectPhotosDelegate> {
  UIScrollView *_imgScrollView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  _imgScrollView = [UIScrollView new];
  _imgScrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, 200);
  _imgScrollView.userInteractionEnabled = YES;
  [self.view addSubview:_imgScrollView];
}

- (void)JMUIMultiSelectedPhotoArray:(NSArray *)selected_photo_array {
  for (UIView *imgView in [_imgScrollView subviews]) {
    [imgView removeFromSuperview];
  }
  _imgScrollView.contentSize = CGSizeMake([selected_photo_array count]*200, 200);
  for (NSInteger index = 0; index < [selected_photo_array count]; index++) {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + index *200, 0, 200, 200)];
    imgView.image = selected_photo_array[index];
    [_imgScrollView addSubview:imgView];
  }
}

- (IBAction)clickToLogin:(id)sender {
  ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
  [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    JMUIMultiSelectPhotosViewController *photoPickerVC = [[JMUIMultiSelectPhotosViewController alloc] init];
    photoPickerVC.photoDelegate = self;
    [self presentViewController:photoPickerVC animated:YES completion:NULL];
  } failureBlock:^(NSError *error) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有相册权限" message:@"请到设置页面获取相册权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
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
