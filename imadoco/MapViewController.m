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

CLLocationCoordinate2D center;

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) Notification *notification;

@end

@implementation MapViewController

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
    // Do any additional setup after loading the view from its nib.
    
    MKCoordinateRegion cr = self.mapView.region;
    cr.span.latitudeDelta = 0.01;
    cr.span.longitudeDelta = 0.01;
    [self.mapView setRegion:cr animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // タイトル
    self.navigationItem.title = [NSString stringWithFormat:@"%@さんはここ！", self.notification.name];
    
    // 地図の表示場所を設定
    CLLocationCoordinate2D center;
    center.latitude = self.notification.lat;
    center.longitude = self.notification.lng;
    [self.mapView setCenterCoordinate:center animated:NO];
    
    // 相手がいる場所にピンを表示
    MKPointAnnotation* pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = center;
    [_mapView addAnnotation:pin];
    
    // 相手からのメッセージ
    self.messageLabel.text = self.notification.message;
    if (self.messageLabel.text == nil) {
        self.messageLabel.text = @"メッセージなし";
    }
}


#pragma mark - 

- (void)showNotification:(Notification *)notification
{
    self.notification = notification;
}

@end
