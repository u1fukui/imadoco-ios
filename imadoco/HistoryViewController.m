//
//  HistoryViewController.m
//  imadoco
//
//  Created by u1 on 2013/07/09.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "HistoryViewController.h"
#import "Notification.h"
#import "MapViewController.h"
#import "ImadocoNetworkEngine.h"
#import "AppDelegate.h"
#import "NotificationCell.h"
#import "UIColor+Hex.h"
#import "FlatUIKit.h"
#import "NotificationManager.h"
#import "InfoPlistProperty.h"
#import "Flurry.h"
#import "FlurryEventName.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (strong, nonatomic) NSMutableArray *notificationArray;

@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

@property (assign, nonatomic) BOOL isReloading;

@property (strong, nonatomic) NADView *nadView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isReloading = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ナビゲーション
    self.navigationItem.title = @"通知履歴";
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor colorWithHex:@"125E8B"]
                                  highlightedColor:[UIColor midnightBlueColor]
                                      cornerRadius:3];
    
    // テーブル
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    //self.historyTableView.backgroundColor = [UIColor colorWithHex:@"#FFFFF0"];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F6F6F6"];
    
    // PullToRefresh
    if (self.refreshHeaderView == nil) {
        // 更新ビューのサイズとデリゲートを指定する
		EGORefreshTableHeaderView *view =
        [[EGORefreshTableHeaderView alloc] initWithFrame:
         CGRectMake(
                    0.0f,
                    0.0f - self.historyTableView.bounds.size.height,
                    self.view.frame.size.width,
                    self.historyTableView.bounds.size.height
                    )];
		view.delegate = self;
		[self.historyTableView addSubview:view];
		self.refreshHeaderView = view;
	}
	
    // 最終更新日付を記録
	[self.refreshHeaderView refreshLastUpdatedDate];
    
    // 広告
    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0,0,
                                                             NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height )];
    [self.nadView setIsOutputLog:NO];
    [self.nadView setNendID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendId]
                     spotID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendSpotId]];
    [self.nadView setDelegate:(id)self];
    [self.adView addSubview:self.nadView];
    [self.nadView load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [self.nadView setDelegate:nil];
    self.nadView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 広告
    [self.nadView resume];
    
    // 更新
    [self.historyTableView reloadData];
    
    // バッジを消す
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nadView pause];
}


#pragma mark - public method

- (void)showNotificationArray:(NSMutableArray *)array
{
    self.notificationArray = array;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notificationArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    [cell setNotificationInfo:[self.notificationArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NotificationCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Notification *notification = [self.notificationArray objectAtIndex:indexPath.row];
    if (notification) {
        // Flurry
        [Flurry logEvent:kEventShowMap];
        
        // 地図画面に遷移
        MapViewController *controller = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        [controller showNotification:notification];
        [[NotificationManager sharedManager] readNotification:notification.id];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate

// スクロールされたことをライブラリに伝える
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

// テーブルを下に引っ張ったら、ここが呼ばれる
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	// レスポンスに対する処理
    NotificationsResponseBlock responseBlock = ^(NSMutableArray *notificationArray) {
        // PullToRefresh
        self.isReloading = NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.historyTableView];
        
        // データ更新
        self.notificationArray = notificationArray;
        [self.historyTableView reloadData];
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        self.isReloading = NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.historyTableView];
        
        // エラーメッセージ
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー" message:@"通信に失敗しました"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    };
    
    self.isReloading = YES;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[ImadocoNetworkEngine sharedEngine] requestGetNotificationArray:appDelegate.userId
                                                           sessionId:appDelegate.sessionId
                                                   completionHandler:responseBlock
                                                        errorHandler:errorBlock];
    
}

// 更新状態を返す
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return self.isReloading;
}
// 最終更新日を更新する際の日付の設定
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date];
}

@end
