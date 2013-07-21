//
//  NotificationManager.h
//  imadoco
//
//  Created by u1 on 2013/07/21.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

+ (NotificationManager *)sharedManager;

// 指定したidの通知を既読状態にする
- (void)readNotification:(int)notificationId;

// 指定したidの通知が既読状態か？
- (BOOL)isRead:(int)notificationId;


- (void)load;

@end
