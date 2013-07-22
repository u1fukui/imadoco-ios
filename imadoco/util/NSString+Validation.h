//
//  NSString+Validation.h
//  imadoco
//
//  Created by u1 on 2013/07/21.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

// 引数が絵文字ならYES
+ (BOOL)isEmoji:(NSString *)string;

// 引数が空白ならYES
+ (BOOL)isBlank:(NSString *)string;

@end
