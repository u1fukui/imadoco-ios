//
//  NotificationyCell.h
//  imadoco
//
//  Created by u1 on 2013/07/20.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Notification;

@interface NotificationCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)setNotificationInfo:(Notification *)notification;

@end
