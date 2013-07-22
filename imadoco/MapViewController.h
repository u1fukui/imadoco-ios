//
//  MapViewController.h
//  imadoco
//
//  Created by u1 on 2013/07/13.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@class Notification;

@interface MapViewController : UIViewController<NADViewDelegate>

- (void)showNotification:(Notification *)notification;

@end
