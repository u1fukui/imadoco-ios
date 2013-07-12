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
#import "Position.h"

const int kAlertInputName = 1;
const int kAlertLaunchMailer = 2;

@interface TopViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;

@property (weak, nonatomic) IBOutlet UIButton *showHistoryButton;

@property (strong, nonatomic) NSString *mailSubject;
@property (strong, nonatomic) NSString *mailBody;

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
    
    self.navigationItem.title = @"Top";
    
    [self.sendMailButton addTarget:self
                            action:@selector(onClickButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.showHistoryButton addTarget:self
                               action:@selector(onClickButton:)
                     forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - イベント

- (void)onClickButton:(UIButton *)button
{
    NSLog(@"%s", __func__);
    
    if (button == self.sendMailButton) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"名前の登録"
                                                        message:@"送り先の名前を入力して下さい"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    
        alert.tag = kAlertInputName;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
        [alert show];
        
    } else if (self.showHistoryButton) {
        // レスポンスに対する処理
        ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
            NSLog(@"success!!");
            
            NSLog(@"%@", op.responseJSON);
            
            // レスポンス解析
            NSMutableArray *positionArray = [NSMutableArray array];
            NSArray *array = op.responseJSON;
            for (NSDictionary *dict in array) {
                Position *pos = [[Position alloc] initWithDictionary:dict];
                [positionArray addObject:pos];
            }
            
            HistoryViewController *controller = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
            [controller showHistoryArray:positionArray];
            [self.navigationController pushViewController:controller
                                                 animated:YES];
        };
        
        // エラー処理
        MKNKErrorBlock errorBlock =  ^(NSError *error) {
            NSLog(@"failed!!");
        };
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [[ImadocoNetworkEngine sharedEngine] requestGetNotificationArray:appDelegate.userId
                                                       completionHandler:responseBlock
                                                            errorHandler:errorBlock];
    }
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if([inputText length] >= 1) {
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
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        NSLog(@"success!!");
        
        // レスポンス解析
        NSDictionary *dict = op.responseJSON;
        self.mailSubject = dict[@"mail_subject"];
        self.mailBody = dict[@"mail_body"];
        
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
        NSLog(@"failed!!");
    };
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[ImadocoNetworkEngine sharedEngine] requestGetMailText:appDelegate.userId
                                                       name:mapName
                                          completionHandler:responseBlock
                                               errorHandler:errorBlock];
}

- (void)launchMailer:(NSString *)subject body:(NSString *)body
{
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?Subject=%@&body=%@", subject, body]]];
    
    self.mailSubject = nil;
    self.mailBody = nil;
}

@end
