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

NSString * const kParamSessionId = @"api_session";

static ImadocoNetworkEngine *_sharedInstance = nil;

+ (ImadocoNetworkEngine *)sharedEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *host = [[[NSBundle mainBundle] infoDictionary] objectForKey:kServerHostName];
        NSLog(@"%s create engine: %@", __func__, host);
        _sharedInstance = [[ImadocoNetworkEngine alloc] initWithHostName:host];
    });
    return _sharedInstance;
}

// デバイスIDの登録
-(MKNetworkOperation*) registerDeviceId:(NSString *) deviceId
                completionHandler:(RegisterResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock
{
    // Body
    NSDictionary *params = @{
                             @"device_id": deviceId,
                             @"device_type" : @"0",
                            };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"device.json"
                                              params:params
                                          httpMethod:@"POST"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // レスポンス解析
         NSDictionary *dict = completedOperation.responseJSON;
         int userId = [dict[@"user_id"] intValue];
         NSString *sessionId = dict[@"api_session"];
         
         completionBlock(userId, sessionId);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         NSLog(@"failed!!");
         NSLog(@"%@", error);
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// マップURLの生成
-(MKNetworkOperation*) requestGetMailText:(int)userId
                                sessionId:(NSString *)sessionId
                                     name:(NSString *)name
                        completionHandler:(MailResponseBlock) completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock
{
    NSLog(@"%s", __func__);
    
    // Body
    NSDictionary *params = @{
                             @"user_id" : [NSString stringWithFormat:@"%d", userId],
                             @"name" : name,
                             kParamSessionId : sessionId
                             };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"mail.json"
                                              params:params
                                          httpMethod:@"POST"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSDictionary *dict = completedOperation.responseJSON;
         NSString *subject = dict[@"mail_subject"];
         NSString *body = dict[@"mail_body"];
         completionBlock(subject, body);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         NSLog(@"failed!!");
         NSLog(@"%@", error);
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}


// 通知履歴の取得
-(MKNetworkOperation*) requestGetNotificationArray:(int)userId
                                         sessionId:(NSString *)sessionId
                                 completionHandler:(NotificationsResponseBlock) completionBlock
                                      errorHandler:(MKNKErrorBlock) errorBlock
{
    NSLog(@"%s", __func__);
    
    NSLog(@"userId = %d", userId);
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"notifications/%d", userId]
                                              params:@{ kParamSessionId: sessionId }
                                          httpMethod:@"GET"];
    
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
         NSLog(@"failed!!");
         NSLog(@"%@", error);
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end
