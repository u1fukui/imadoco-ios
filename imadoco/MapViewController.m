//
//  MapViewController.m
//  imadoco
//
//  Created by u1 on 2013/07/13.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Notification.h"
#import "FlatUIKit.h"
#import "InfoPlistProperty.h"

CLLocationCoordinate2D center;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageSubLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageBgView;

@property (strong, nonatomic) Notification *notification;

@property (strong, nonatomic) NADView *nadView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // タイトル
    self.navigationItem.title = @"位置確認";
    
    // 地図
    MKCoordinateRegion cr = self.mapView.region;
    cr.span.latitudeDelta = 0.01;
    cr.span.longitudeDelta = 0.01;
    [self.mapView setRegion:cr animated:NO];
    
    // 受信日時
    self.createdTimeLabel.backgroundColor = [UIColor clearColor];
    self.createdTimeLabel.textColor = [UIColor greenSeaColor];
    
    // 名前
    self.messageSubLabel.backgroundColor = [UIColor clearColor];
    
    // メッセージ
    self.messageLabel.backgroundColor = [UIColor clearColor];
    
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
    
    // 地図の表示場所を設定
    CLLocationCoordinate2D center;
    center.latitude = self.notification.lat;
    center.longitude = self.notification.lng;
    [self.mapView setCenterCoordinate:center animated:NO];
    
    // 相手がいる場所にピンを表示
    MKPointAnnotation* pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = center;
    [self.mapView addAnnotation:pin];
    
    
    // 相手からのメッセージ背景
    self.messageBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"message_bg"]];
    
    // 相手からのメッセージ文言
    self.messageLabel.text = self.notification.message;
    //self.messageLabel.text = @"あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや";
    if (self.messageLabel.text.length == 0) {
        self.messageLabel.text = @"メッセージなし";
    }
    
    self.messageSubLabel.text = [NSString stringWithFormat:@"%@さんからのメッセージ", self.notification.name];
    
    self.createdTimeLabel.text = self.notification.createdAt;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nadView pause];
}

#pragma mark - 

- (void)showNotification:(Notification *)notification
{
    self.notification = notification;
}

@end
