//
//  NotificationManager.m
//  imadoco
//
//  Created by u1 on 2013/07/21.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "NotificationManager.h"

@interface NotificationManager()

@property (strong, nonatomic) NSMutableSet *readNotificationIdSet;

@end


@implementation NotificationManager

static NotificationManager *_sharedInstance = nil;

+ (NotificationManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NotificationManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.readNotificationIdSet = [NSMutableSet set];
    }
    return self;
}


- (void)readNotification:(int)notificationId
{
    [self.readNotificationIdSet addObject:[NSString stringWithFormat:@"%d", notificationId]];
    
    // 既読状態をディスクに保存
    [self save];
}

- (BOOL)isRead:(int)notificationId
{
    return [self.readNotificationIdSet containsObject:[NSString stringWithFormat:@"%d", notificationId]];
}



#pragma mark - データ永続化

- (void)save
{
    NSString *path = [NotificationManager getFilePath];
    [NSKeyedArchiver archiveRootObject:self.readNotificationIdSet toFile:path];
}

- (void)load
{
    NSString *path = [NotificationManager getFilePath];
    self.readNotificationIdSet = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (self.readNotificationIdSet == nil) {
        self.readNotificationIdSet = [NSMutableSet set];
    }
}

+ (NSString *)getFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:@"NotificationManager.dat"];
}

@end
