//
//  Position.m
//  imadoco
//
//  Created by u1 on 2013/07/09.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "Position.h"

@implementation Position

- (id)initWithDictionary:(NSDictionary *) dict
{
    self = [super init];
    if (self) {
        NSLog(@"dict = %@", dict);
        
        NSLog(@"1");
        self.name = dict[@"name"];
        NSLog(@"2 %@", self.name);
        self.lat = [dict[@"lat"] doubleValue];
        NSLog(@"3");
        self.lng = [dict[@"lng"] doubleValue];
        NSLog(@"4");
        self.message = dict[@"message"];
        NSLog(@"5");
        self.updatedAt = dict[@"created_at"];
    }
    return self;
}

@end
