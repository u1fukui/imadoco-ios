//
//  ImadocoNetworkEngine.h
//  imadoco
//
//  Created by u1 on 2013/07/08.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface ImadocoNetworkEngine : MKNetworkEngine

typedef void (^RegisterUserResponseBlock)(NSString *userId, NSString *sessionId);
typedef void (^RegisterDeviceResponseBlock)();
typedef void (^MailResponseBlock)(NSString *subject, NSString *body);
typedef void (^NotificationsResponseBlock)(NSMutableArray *notificationArray);

// シングルトンインスタンス取得
+ (ImadocoNetworkEngine *)sharedEngine;

// ユーザ登録
-(MKNetworkOperation*) registerUserId:(NSString *) userId
                    completionHandler:(RegisterUserResponseBlock)completionBlock
                         errorHandler:(MKNKErrorBlock)errorBlock;

// deviceIDの登録
-(MKNetworkOperation*) registerDeviceId:(NSString *)userId
                              sessionId:(NSString *)sessionId
                               deviceId:(NSString *)deviceId
                      completionHandler:(RegisterDeviceResponseBlock)completionBlock
                           errorHandler:(MKNKErrorBlock)errorBlock;

// メール本文の取得
-(MKNetworkOperation*) requestCreateMailText:(NSString *)userId
                                   sessionId:(NSString *)sessionId
                                        name:(NSString *)name
                           completionHandler:(MailResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock)errorBlock;

// 通知履歴を取得
-(MKNetworkOperation*) requestGetNotificationArray:(NSString *)userId
                                         sessionId:(NSString *)sessionId
                                 completionHandler:(NotificationsResponseBlock)completionBlock
                                      errorHandler:(MKNKErrorBlock)errorBlock;

@end
