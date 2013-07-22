//
//  AppDelegate.m
//  imadoco
//
//  Created by u1 on 2013/07/06.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "AppDelegate.h"

#import "TopViewController.h"
#import "ImadocoNetworkEngine.h"
#import "NotificationManager.h"

@implementation AppDelegate


void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"%@", exception.name);
    NSLog(@"%@", exception.reason);
    NSLog(@"%@", exception.callStackSymbols);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[TopViewController alloc] initWithNibName:@"TopViewController" bundle:nil];
    self.rootController = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];
    
    // PUSH通知登録
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    // 通知の確認状態を確認
    [[NotificationManager sharedManager] load];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - PUSH通知

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%s", __func__);
    
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        NSLog(@"success!!");
        
        // レスポンスの解析
        NSDictionary *dict = op.responseJSON;
        self.userId = [dict[@"user_id"] intValue];
        
        NSLog(@"userId = %d", self.userId);
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        NSLog(@"failed!!");
        NSLog(@"%@", error);
    };
    
    [[ImadocoNetworkEngine sharedEngine] registerDeviceId:[NSString stringWithFormat:@"%@", deviceToken]
                                        completionHandler:responseBlock
                                             errorHandler:errorBlock];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", error.localizedDescription);
    NSLog(@"%@", error.localizedFailureReason);
}

@end
