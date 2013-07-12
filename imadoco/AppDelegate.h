//
//  AppDelegate.h
//  imadoco
//
//  Created by u1 on 2013/07/06.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController* rootController;
@property (strong, nonatomic) TopViewController *viewController;

@property (assign, nonatomic) int userId;

@end
