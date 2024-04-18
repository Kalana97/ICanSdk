//
//  ShowAppleMapLocationViewController.m
//  ICan
//
//  Created b D.W.Rohan Jayasekara  MAC on 2022-11-03.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ShowAppleMapLocationViewController.h"
#import <MapKit/MKFoundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKLocalSearch.h>

@interface ShowAppleMapLocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
// View properties
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *locationButton;
@property (nonatomic,strong) UIButton *memuButton;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *addressLabel;
// AppleMapKit properties
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) MKPointAnnotation *mKPointAnnotation;
@property (nonatomic,strong) MKUserLocation *userLocation; // user's current location
// CLLocation properties
@property (nonatomic,strong) CLLocation *mkLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
@property (nonatomic) CLLocationCoordinate2D stopcoordinate;
@end

@implementation ShowAppleMapLocationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.locationMessageInfo) {
        self.stopcoordinate = CLLocationCoordinate2DMake(self.locationMessageInfo.latitude, self.locationMessageInfo.longitude);
    } else if (self.listRespon) {
        double latitude = [self.listRespon.location.latitude doubleValue];
        double longitude = [self.listRespon.location.longitude doubleValue];
        self.stopcoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    } else if (self.collectionResponse) {
        double latitude = [self.collectionResponse.poi.latitude doubleValue];
        double longitude = [self.collectionResponse.poi.longitude doubleValue];
        self.stopcoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    [self setUpView];
    [self render];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations firstObject]) {
        [self.locationManager stopUpdatingLocation];
        self.mkLocation = [locations firstObject];
    }
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)render {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.stopcoordinate.latitude, self.stopcoordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
    MKShape *pin = [[MKPointAnnotation alloc]init];
    pin.coordinate = coordinate;
    [self.mapView addAnnotation:pin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.pinTintColor = UIColor.purpleColor;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

- (void)setUpView {
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@-90);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@90);
        make.left.right.bottom.equalTo(@0);
    }];
    [self.bottomView addSubview:self.memuButton];
    [self.memuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.width.height.equalTo(@50);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.bottomView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-90);
        make.bottom.equalTo(@-25);
    }];
    [self.bottomView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-90);
        make.bottom.equalTo(self.addressLabel.mas_top).offset(-5.5);
    }];
    [self.view addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-30);
        make.width.height.equalTo(@50);
    }];
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.left.equalTo(@15);
        make.top.equalTo(@35);
    }];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *locationImgNor = [UIImage imageNamed:@"location_back"];
        _backButton.tag = 100;
        [_backButton setImage:locationImgNor forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)locationButton {
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *locationImgNor = [UIImage imageNamed:@"location"];
        _locationButton.tag = 102;
        [_locationButton setImage:locationImgNor forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}

- (UIButton *)memuButton {
    if (!_memuButton) {
        _memuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *locationImgNor = [UIImage imageNamed:@"location_menu_btn"];
        _memuButton.tag = 103;
        [_memuButton setImage:locationImgNor forState:UIControlStateNormal];
        [_memuButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _memuButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel leftLabelWithTitle:nil font:20 color:[UIColor blackColor]];
        _nameLabel.text = self.locationMessageInfo.name;
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel leftLabelWithTitle:nil font:12 color:[UIColor blackColor]];
        _addressLabel.text = self.locationMessageInfo.address;
    }
    return _addressLabel;
}

#pragma mark Apple Map (Default)
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
        _mapView.zoomEnabled = YES;
        _mapView.scrollEnabled = YES;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    return _mapView;
}

- (MKPointAnnotation *)mKPointAnnotation {
    if (!_mKPointAnnotation) {
        _mKPointAnnotation = [[MKPointAnnotation alloc]init];
        _mKPointAnnotation.coordinate = self.stopcoordinate;
    }
    return _mKPointAnnotation;
}

- (void)buttonAction:(UIButton*)button {
    switch (button.tag) {
        case 100:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 101:{
        }
            break;
        case 102:{
            [self.mapView setCenterCoordinate:self.startCoordinate animated:YES];
        }
            break;
        case 103:{
            [self showMemus];
        }
            break;
        default:
            break;
    }
}

- (void)showMemus {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Apple map".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self appleMapNaviagation];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Google Maps".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self googleMapNaviagation];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Lazy loading
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startMonitoringSignificantLocationChanges];
        [_locationManager startUpdatingLocation];
    }
    return _locationManager;
}

- (MKUserLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[MKUserLocation alloc] init];
    }
    return _userLocation;
}

- (void)appleMapNaviagation {
    NSString *directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude, self.stopcoordinate.latitude, self.stopcoordinate.longitude];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:options completionHandler:^(BOOL success) {}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:options completionHandler:^(BOOL success) {}];
    }
}

- (void)googleMapNaviagation{
    UIApplication *application = [UIApplication sharedApplication];
    NSString *latlong = [NSString stringWithFormat:@"%f,%f", self.stopcoordinate.latitude, self.stopcoordinate.longitude];
    NSString *encodedString = [latlong stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%@", encodedString];
    NSURL *URL = [NSURL URLWithString:urlString];
    BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]];
    if (canHandle == YES){
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                 NSLog(@"Opened url");
            }
        }];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"Please install Google Map".icanlocalized inView:self.view];
    }
}

@end
