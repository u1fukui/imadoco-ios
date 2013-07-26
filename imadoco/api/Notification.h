//
//  Notification.h
//  imadoco
//
//  Created by u1 on 2013/07/13.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (assign, nonatomic) int id;

@property (strong, nonatomic) NSString *name;

@property (assign, nonatomic) double lat;

@property (assign, nonatomic) double lng;

@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) NSString *createdAt;


- (id)initWithDictionary:(NSDictionary *) dict;

@end
