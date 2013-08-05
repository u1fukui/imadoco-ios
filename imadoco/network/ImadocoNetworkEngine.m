//
//  ImadocoNetworkEngine.m
//  imadoco
//
//  Created by u1 on 2013/07/08.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "ImadocoNetworkEngine.h"
#import "InfoPlistProperty.h"
#import "Notification.h"

@implementation ImadocoNetworkEngine

// メソッド
NSString * const kMethodGet = @"GET";
NSString * const kMethodPost = @"POST";

// パス
NSString * const kPathRegisterUser = @"user.json";
NSString * const kPathRegisterDevice = @"device.json";
NSString * const kPathCreateMail = @"mail.json";
NSString * const kPathGetNotifications = @"notifications/%@";

// パラメータ名
NSString * const kParamUserId = @"user_id";
NSString * const kParamSessionId = @"api_session";
NSString * const kParamDeviceType = @"device_type";
NSString * const kParamDeviceId = @"device_id";
NSString * const kParamMapName = @"map_name";
NSString * const kParamMailSubject = @"mail_subject";
NSString * const kParamMailBody = @"mail_body";

static ImadocoNetworkEngine *_sharedInstance = nil;

+ (ImadocoNetworkEngine *)sharedEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *host = [[[NSBundle mainBundle] infoDictionary] objectForKey:kServerHostName];
        _sharedInstance = [[ImadocoNetworkEngine alloc] initWithHostName:host];
    });
    return _sharedInstance;
}

// ユーザ登録
-(MKNetworkOperation*) registerUserId:(NSString *)userId
                    completionHandler:(RegisterUserResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock;
{
    // ユーザIDが未設定の場合は0を設定する
    NSString *paramUserId;
    if (userId == nil) {
        paramUserId = @"0";
    } else {
        paramUserId = userId;
    }
    
    // Body
    NSDictionary *params = @{
                             kParamUserId: paramUserId,
                             kParamDeviceType : @"0",
                             };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:kPathRegisterUser
                                              params:params
                                          httpMethod:kMethodPost];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // レスポンス解析
         NSDictionary *dict = completedOperation.responseJSON;
         NSString *userId = dict[kParamUserId];
         NSString *sessionId = dict[kParamSessionId];
         
         completionBlock(userId, sessionId);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         NSLog(@"%@", error);
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// デバイスIDの登録
-(MKNetworkOperation*) registerDeviceId:(NSString *)userId
                              sessionId:(NSString *)sessionId
                               deviceId:(NSString *)deviceId
                      completionHandler:(RegisterDeviceResponseBlock)completionBlock
                           errorHandler:(MKNKErrorBlock)errorBlock;
{
    // Body
    NSDictionary *params = @{
                             kParamUserId: userId,
                             kParamSessionId: sessionId,
                             kParamDeviceId: deviceId,
                            };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:kPathRegisterDevice
                                              params:params
                                          httpMethod:kMethodPost];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock();
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         NSLog(@"%@", error);
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// マップURLの生成
-(MKNetworkOperation*) requestCreateMailText:(NSString *)userId
                                   sessionId:(NSString *)sessionId
                                        name:(NSString *)name
                           completionHandler:(MailResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock
{
    NSLog(@"%s", __func__);
    
    // Body
    NSDictionary *params = @{
                             kParamUserId : userId,
                             kParamMapName : name,
                             kParamSessionId : sessionId
                             };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:kPathCreateMail
                                              params:params
                                          httpMethod:kMethodPost];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSDictionary *dict = completedOperation.responseJSON;
         NSString *subject = dict[kParamMailSubject];
         NSString *body = dict[kParamMailBody];
         completionBlock(subject, body);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         NSLog(@"%@", error);
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}


// 通知履歴の取得
-(MKNetworkOperation*) requestGetNotificationArray:(NSString *)userId
                                         sessionId:(NSString *)sessionId
                                 completionHandler:(NotificationsResponseBlock) completionBlock
                                      errorHandler:(MKNKErrorBlock) errorBlock
{
    NSLog(@"%s", __func__);
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:kPathGetNotifications, userId]
                                              params:@{ kParamSessionId: sessionId }
                                          httpMethod:kMethodGet];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSMutableArray *notificationArray = [NSMutableArray array];
         NSArray *array = completedOperation.responseJSON;
         for (NSDictionary *dict in array) {
             Notification *notification = [[Notification alloc] initWithDictionary:dict];
             [notificationArray addObject:notification];
         }
         completionBlock(notificationArray);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         NSLog(@"%@", error);
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end
