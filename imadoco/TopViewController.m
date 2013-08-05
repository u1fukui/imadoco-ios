//
//  TopViewController.m
//  imadoco
//
//  Created by u1 on 2013/07/09.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "TopViewController.h"
#import "HistoryViewController.h"
#import "ImadocoNetworkEngine.h"
#import "AppDelegate.h"
#import "Notification.h"
#import "FlatUIKit.h"
#import "UIColor+Hex.h"
#import "NSString+Validation.h"
#import "InfoPlistProperty.h"
#import "SVProgressHUD.h"

const int kAlertInputName = 1;
const int kAlertLaunchMailer = 2;

@interface TopViewController ()

@property (weak, nonatomic) IBOutlet FUIButton *sendMailButton;

@property (weak, nonatomic) IBOutlet FUIButton *showHistoryButton;

@property (strong, nonatomic) NSString *mailSubject;
@property (strong, nonatomic) NSString *mailBody;
@property (weak, nonatomic) IBOutlet UIView *descriptionBgTopView;
@property (weak, nonatomic) IBOutlet UIView *descriptionBgBottomView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@property (strong, nonatomic) NADView *nadView;

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 画面中央に表示
    CGRect frame = self.mainView.frame;
    CGFloat diff = [[UIScreen mainScreen] bounds].size.height - 480;
    if (diff != 0) {
        frame.origin.y =  diff / 2;
    }
    self.mainView.frame = frame;
    
    // 背景色
    self.view.backgroundColor = [UIColor colorWithHex:@"#F6F6F6"];
    
    // ナビゲーション
    self.navigationItem.title = @"imadoco?";
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor belizeHoleColor]];
    
    // メールを送る
    self.sendMailButton.buttonColor = [UIColor tangerineColor];
    self.sendMailButton.shadowColor = [UIColor carrotColor];
    self.sendMailButton.shadowHeight = 3.0f;
    self.sendMailButton.cornerRadius = 6.0f;
    self.sendMailButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.sendMailButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.sendMailButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.sendMailButton addTarget:self
                            action:@selector(onClickButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    // 通知履歴を見る
    self.showHistoryButton.buttonColor = [UIColor turquoiseColor];
    self.showHistoryButton.shadowColor = [UIColor greenSeaColor];
    self.showHistoryButton.shadowHeight = 3.0f;
    self.showHistoryButton.cornerRadius = 6.0f;
    self.showHistoryButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.showHistoryButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.showHistoryButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.showHistoryButton addTarget:self
                               action:@selector(onClickButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    // 説明枠
    self.descriptionBgTopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"description_bg_top"]];
    self.descriptionBgBottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"description_bg_bottom"]];
    
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
    [self.nadView resume];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nadView pause];
}

#pragma mark - イベント

- (void)onClickButton:(UIButton *)button
{
    NSLog(@"%s", __func__);
    
    if (button == self.sendMailButton) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"名前の登録"
                                                        message:@"まずは現在地を知りたい相手の名前を入力して下さい"
                                                       delegate:self
                                              cancelButtonTitle:@"キャンセル"
                                              otherButtonTitles:@"OK", nil];
    
        alert.tag = kAlertInputName;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
        [alert textFieldAtIndex:0].delegate = self;
        [alert show];
        
    } else if (self.showHistoryButton) {
        // レスポンスに対する処理
        NotificationsResponseBlock responseBlock = ^(NSMutableArray *notificationArray) {
            // ダイアログ非表示
            [SVProgressHUD dismiss];
            
            // 通知履歴画面に繊維
            HistoryViewController *controller = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
            [controller showNotificationArray:notificationArray];
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        };
        
        // エラー処理
        MKNKErrorBlock errorBlock =  ^(NSError *error) {
            // ダイアログ非表示
            [SVProgressHUD dismiss];
        
            // エラーメッセージ
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"エラー" message:@"サーバとの通信に失敗しました"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        };
        
        // ダイアログ表示
        [SVProgressHUD show];
        
        // 通信実行
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [[ImadocoNetworkEngine sharedEngine] requestGetNotificationArray:appDelegate.userId
                                                               sessionId:appDelegate.sessionId
                                                       completionHandler:responseBlock
                                                            errorHandler:errorBlock];
    }
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    int length = [inputText length];
    if(length >= 1 && length <= 10 && ![NSString isBlank:inputText]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - UIAlerViewDelegate

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%s", __func__);
    
    switch (alertView.tag) {
        case kAlertInputName:
            [self requestGetMailText:[[alertView textFieldAtIndex:0] text]];
            break;
            
        case kAlertLaunchMailer:
            [self launchMailer:self.mailSubject body:self.mailBody];
            break;
    }
}



#pragma mark - メールを送る

- (void)requestGetMailText:(NSString *)mapName
{
    
    if (mapName.length == 0) {
        return;
    }
    
    // レスポンスに対する処理
    MailResponseBlock responseBlock = ^(NSString *subject, NSString *body) {
        // ダイアログ非表示
        [SVProgressHUD dismiss];
        
        // メール情報設定
        self.mailSubject = subject;
        self.mailBody = body;
        
        // アラート
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登録完了"
                                                        message:@"マップのURLを取得しました。メーラーを起動します"
                                                       delegate:self
                                              cancelButtonTitle:@"確認" otherButtonTitles:nil];
        alert.tag = kAlertLaunchMailer;
        [alert show];
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        // ダイアログ非表示
        [SVProgressHUD dismiss];
        
        // アラート
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"サーバとの通信に失敗しました。"
                                                       delegate:self
                                              cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];

    };
    
    // ダイアログ表示
    [SVProgressHUD show];
    
    // 通信実行
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[ImadocoNetworkEngine sharedEngine] requestCreateMailText:appDelegate.userId
                                                     sessionId:appDelegate.sessionId
                                                          name:mapName
                                             completionHandler:responseBlock
                                                  errorHandler:errorBlock];
}

- (void)launchMailer:(NSString *)subject body:(NSString *)body
{
    
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?Subject=%@&body=%@",
                           [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
    self.mailSubject = nil;
    self.mailBody = nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 最大文字数制限
    int maxInputLength = 10;
    NSMutableString *str = [textField.text mutableCopy];
    [str replaceCharactersInRange:range withString:string];
    if ([str length] > maxInputLength) {
        return NO;
    }
    
    // 絵文字はNG
    if ([NSString isEmoji:string]) {
        return NO;
    }
    
    return YES;
}

@end
