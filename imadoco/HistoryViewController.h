//
//  HistoryViewController.h
//  imadoco
//
//  Created by u1 on 2013/07/09.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "NADView.h"

@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, NADViewDelegate>

- (void)showNotificationArray:(NSMutableArray *)array;

@end
