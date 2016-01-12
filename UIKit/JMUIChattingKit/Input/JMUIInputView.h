//
//  JMUIInputView.h
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMUIInputToolbar.h"
#import "JMUIMoreView.h"
@interface JMUIInputView : UIView
@property(strong, nonatomic)JMUIInputToolbar *toolBar;
@property(strong, nonatomic)JMUIMoreView *moreView;

@property(weak, nonatomic)id<JMUIMoreViewDelegate, JMUIToolBarDelegate>delegate;

- (void)hideKeyboard;
@end
