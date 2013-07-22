//
//  Notification.m
//  imadoco
//
//  Created by u1 on 2013/07/13.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (id)initWithDictionary:(NSDictionary *) dict
{
    self = [super init];
    if (self) {
        self.id = [dict[@"id"] intValue];
        self.name = dict[@"name"];
        self.lat = [dict[@"lat"] doubleValue];
        self.lng = [dict[@"lng"] doubleValue];
        self.message = dict[@"message"];
        
        self.updatedAt = [self formatDateString:dict[@"created_at"]];
        
        NSLog(@"updatedAt = %@", self.updatedAt);
    }
    return self;
}


// 日付の書式変換
- (NSString *)formatDateString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    return [dateFormatter stringFromDate:date];
}


@end
