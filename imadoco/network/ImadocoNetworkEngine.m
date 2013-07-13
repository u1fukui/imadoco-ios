//
//  ImadocoNetworkEngine.m
//  imadoco
//
//  Created by u1 on 2013/07/08.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "ImadocoNetworkEngine.h"

@implementation ImadocoNetworkEngine

static ImadocoNetworkEngine *_sharedInstance = nil;

+ (ImadocoNetworkEngine *)sharedEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *host = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ServerHostName"];
        NSLog(@"%s create engine: %@", __func__, host);
        _sharedInstance = [[ImadocoNetworkEngine alloc] initWithHostName:host];
    });
    return _sharedInstance;
}

// 連想の登録
-(MKNetworkOperation*) registerDeviceId:(NSString *) deviceId
                completionHandler:(ResponseBlock) completionBlock
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
         completionBlock(completedOperation);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// 連想の登録
-(MKNetworkOperation*) requestGetMailText:(int)userId
                                     name:(NSString *)name
                        completionHandler:(ResponseBlock) completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock
{
    NSLog(@"%s", __func__);
    
    // Body
    NSDictionary *params = @{
                             @"user_id" : [NSString stringWithFormat:@"%d", userId],
                             @"name" : name
                             };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"mail.json"
                                              params:params
                                          httpMethod:@"POST"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock(completedOperation);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// 通知履歴の取得
-(MKNetworkOperation*) requestGetNotificationArray:(int)userId
                                 completionHandler:(ResponseBlock) completionBlock
                                      errorHandler:(MKNKErrorBlock) errorBlock
{
    NSLog(@"%s", __func__);
    
    NSLog(@"userId = %d", userId);
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"notifications/%d", userId]
                                              params:nil
                                          httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock(completedOperation);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end
