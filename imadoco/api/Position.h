//
//  Position.h
//  imadoco
//
//  Created by u1 on 2013/07/09.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject

@property (strong, nonatomic) NSString *name;

@property (assign, nonatomic) double lat;

@property (assign, nonatomic) double lng;

@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) NSString *updatedAt;


- (id)initWithDictionary:(NSDictionary *) dict;

@end
