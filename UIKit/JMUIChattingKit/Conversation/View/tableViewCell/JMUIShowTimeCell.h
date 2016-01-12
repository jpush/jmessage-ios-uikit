//
//  JCHATShowTimeCell.h
//  JPush IM
//
//  Created by Apple on 15/1/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMUIChatModel.h"

@interface JMUIShowTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (strong, nonatomic)  JMUIChatModel *model;

- (void)setCellData:(JMUIChatModel *)model;
- (void)layoutModel:(JMUIChatModel *)model;
- (void)layoutErrorMessage;
@end
