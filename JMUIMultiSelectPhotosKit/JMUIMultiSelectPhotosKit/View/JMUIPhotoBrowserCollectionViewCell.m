//
//  HMPhotoBrowserCollectionViewCell.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/12.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "JMUIPhotoBrowserCollectionViewCell.h"

@interface JMUIPhotoBrowserCollectionViewCell ()<UIScrollViewDelegate>
@property (weak, nonatomic)JMUIPhotoModel *photoModel;
@property (strong, nonatomic)UIImageView *largeImage;
@end

@implementation JMUIPhotoBrowserCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
  _largeImage = [UIImageView new];
  _largeImage.contentMode = UIViewContentModeScaleAspectFit;
  [_imageContent addSubview:_largeImage];
  self.backgroundColor = [UIColor blackColor];
  
  self.userInteractionEnabled = YES;
  _imageContent.userInteractionEnabled = YES;
  _imageContent.delegate = self;
  _imageContent.maximumZoomScale = 2.0;
  _imageContent.minimumZoomScale = 1;
  _imageContent.decelerationRate = UIScrollViewDecelerationRateFast;
  _imageContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _imageContent.scrollEnabled = YES;
  
  _largeImage.userInteractionEnabled = YES;
//  [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinAction:)]];
//  
//  [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoAction:)];
  tap.numberOfTapsRequired = 2;
  [_imageContent addGestureRecognizer:tap];

}

- (void)pinAction:(UIPinchGestureRecognizer *)pin{

}

- (void)tapAction:(UITapGestureRecognizer *)tap{

  
}

- (void)tapPhotoAction:(UITapGestureRecognizer *)tap{
  [UIView animateWithDuration:0.4 animations:^{
    _largeImage.transform = CGAffineTransformIdentity;
    _imageContent.contentSize = _largeImage.frame.size;

    _imageContent.contentOffset = CGPointZero;
  }];
  
}


- (void)setDataWithModel:(JMUIPhotoModel *)model {
  _photoModel = model;
  PHAsset *asset = model.photoAsset;
  _imageContent.frame = self.bounds;
  _imageContent.contentSize = self.frame.size;
  _largeImage.frame = _imageContent.bounds;
  _largeImage.transform = CGAffineTransformIdentity;
  if (model.asset == nil) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(self.frame.size.width * scale, self.frame.size.width * scale);
    [model.cachingManager requestImageForAsset:asset
                                    targetSize:imageSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                   if ([_photoModel.photoAsset.localIdentifier isEqualToString:asset.localIdentifier]) {
                                     _largeImage.image = result;
                                   }
                                 }];
  } else {
    [[[ALAssetsLibrary alloc] init] assetForURL:model.imgURL resultBlock:^(ALAsset *asset)  {
      
      _largeImage.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
      
    }failureBlock:^(NSError *error) {
      NSLog(@"error=%@",error);
    }];
  }
}

#pragma mark - scrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  
  return _largeImage;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
  (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
  CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
  (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
  _largeImage.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                  scrollView.contentSize.height * 0.5 + offsetY);
}

@end
