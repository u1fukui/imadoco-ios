//
//  ImadocoNetworkEngine.h
//  imadoco
//
//  Created by u1 on 2013/07/08.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface ImadocoNetworkEngine : MKNetworkEngine

typedef void (^ResponseBlock)(MKNetworkOperation *op);

// シングルトンインスタンス取得
+ (ImadocoNetworkEngine *)sharedEngine;

// deviceIDの登録
-(MKNetworkOperation*) registerDeviceId:(NSString *) deviceId
                      completionHandler:(ResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) requestGetMailText:(int)userId
                                sessionId:(NSString *)sessionId
                                     name:(NSString *)name
                        completionHandler:(ResponseBlock) completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) requestGetNotificationArray:(int)userId
                                         sessionId:(NSString *)sessionId
                                 completionHandler:(ResponseBlock) completionBlock
                                      errorHandler:(MKNKErrorBlock) errorBlock;

@end
