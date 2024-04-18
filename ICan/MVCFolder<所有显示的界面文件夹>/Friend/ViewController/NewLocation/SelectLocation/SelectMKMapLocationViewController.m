//
//  SelectMKMapLoactionViewController.m
//  ICan
//
//  Created by Rohan Jayasekara on 2022-10-25.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "SelectMKMapLocationViewController.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "OSSWrapper.h"
#import "MkMapView.h"
#import "PlaceInfoModel.h"
#import "PlaceInfoTableViewCell.h"
#import "LocationSearchTableViewController.h"
#import <objc/runtime.h>

#define DEFAULTSPAN 100
#define CellIdntifier @"placeInfoCellIdentifier"

@interface SelectMKMapLocationViewController() {
    BOOL haveGetUserLocation; //Whether to get the user's location
    CLGeocoder *geocoder;
    NSMutableArray *infoArray;
    UIImageView *imgView;
    BOOL spanBool;
    BOOL pinchBool;
    NSString *searchText;
}

@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, retain) MKMapItem *selectMKPoiInfo;
@property(nonatomic, strong) UISearchController *resultSearchController;
@end

@implementation SelectMKMapLocationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    spanBool = NO;
    pinchBool = NO;
    [self.tableView registerNib: [UINib nibWithNibName:@"PlaceInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdntifier];
    geocoder = [[CLGeocoder alloc] init];
    infoArray = [NSMutableArray array];
    haveGetUserLocation = NO;
    [self createNavigationBar];
    [self createSearchBar];
    [self getCurrentLocation];
}

- (void)getCurrentLocation {
    // request location service
    self.locationManager = [[CLLocationManager alloc] init];
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    for (UIView *view in self.mapView.subviews) {
        NSString *viewName = NSStringFromClass([view class]);
        if ([viewName isEqualToString:@"_MKMapContentView"]) {
            UIView *contentView = view;
            for (UIGestureRecognizer *gestureRecognizer in contentView.gestureRecognizers) {
                if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewSpanGesture:)];
                }
                if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewPinchGesture:)];
                }
            }
        }
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self resetTableHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    NSLog(@"mapViewWillStartLocatingUser");
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    NSLog(@"mapViewDidStopLocatingUser");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"userLocation:longitude:%f---latitude:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    if (!haveGetUserLocation) {
        if (self.mapView.userLocationVisible) {
            haveGetUserLocation = YES;
            [self getAddressByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            [self addCenterLocationViewWithCenterPoint:self.mapView.center];
            [self render: userLocation.location];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"didFailToLocateUserWithError:%@",error.localizedDescription);
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"regionDidChangeAnimated");
    if (imgView && (spanBool||pinchBool)) {
        CGPoint mapCenter = self.mapView.center;
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:mapCenter toCoordinateFromView:self.mapView];
        [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self getAroundInfoMationWithCoordinate:coordinate];
        [self resetTableHeadView];
        imgView.center = CGPointMake(mapCenter.x, mapCenter.y-15);
        [UIView animateWithDuration:0.2 animations:^{
            self->imgView.center = mapCenter;
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    self->imgView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            self->imgView.transform = CGAffineTransformIdentity;
                        }completion:^(BOOL finished){
                            if (finished) {
                                self->spanBool = NO;
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)createNavigationBar {
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".icanlocalized style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send".icanlocalized style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)cancelAction {
    !self.backAction?: self.backAction();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropPinZoomIn:(MKPlacemark*) placemark searchText:(NSString*)searchBarText {
    searchText = searchBarText;
    haveGetUserLocation = YES;
    [self getAddressByLatitude:placemark.coordinate.latitude longitude:placemark.coordinate.longitude];
    [self render: self.currentLocation];
}

- (void)sendAction {
    if (infoArray.count > 0) {
        [self cutMapImg];
    }
}

- (void)createSearchBar {
    LocationSearchTableViewController *locationSearchTable = [[LocationSearchTableViewController alloc] init];
    self.resultSearchController = [[UISearchController alloc] initWithSearchResultsController:locationSearchTable];
    self.resultSearchController.searchResultsUpdater = (id)locationSearchTable;
    UISearchBar *searchBar = self.resultSearchController.searchBar;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO];
    searchBar.placeholder = @"Search for places";
    self.navigationItem.titleView = self.resultSearchController.searchBar;
    self.resultSearchController.hidesNavigationBarDuringPresentation = false;
    self.resultSearchController.dimsBackgroundDuringPresentation = true;
    self.definesPresentationContext = YES;
    locationSearchTable.mapView = self.mapView;
    locationSearchTable.handleMapSearchDelegate = (id)self;
}

- (void)cutMapImg {
    UIImage *seleImage = [self.mapView qmui_snapshotLayerImage];
    NSData *smallAlbumData = [UIImage compressImageSize:seleImage toByte:1024*50];
    LocationMessageInfo *locationMessageInfo = [LocationMessageInfo new];
    [QMUITipsTool showLoadingWihtMessage: NSLocalizedString(@"Sending",发送中) inView:self.mapView];
    __block OSSWrapper *osswr = [[OSSWrapper alloc]init];
    @weakify(self);
    [osswr setUserHeadImageWithImage:smallAlbumData type:@"1" success:^(NSString * _Nonnull url) {
        @strongify(self);
        locationMessageInfo.mapUrl = url;
        locationMessageInfo.latitude = self.currentLocation.coordinate.latitude;
        locationMessageInfo.longitude = self.currentLocation.coordinate.longitude;
        PlaceInfoModel *model = self->infoArray[0];
        locationMessageInfo.name = model.name;
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        
        [geoCoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!placemarks) {
                locationMessageInfo.address = @"Not place name";
            }
            if(placemarks && placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                if([placemark thoroughfare] && [placemark locality] && [placemark administrativeArea]) {
                    locationMessageInfo.address = [NSString stringWithFormat:@"%@, %@, %@",[placemark thoroughfare]?[placemark thoroughfare]:@"",[placemark locality]?[placemark locality]:@"", [placemark administrativeArea]?[placemark administrativeArea]:@""];
                }else if((![placemark thoroughfare] && [placemark locality] && [placemark administrativeArea]) || ([placemark thoroughfare] && ![placemark locality] && [placemark administrativeArea]) || ([placemark thoroughfare] && [placemark locality] && ![placemark administrativeArea])) {
                    locationMessageInfo.address = [NSString stringWithFormat:@"%@, %@",[placemark thoroughfare]?[placemark thoroughfare]:[placemark locality], [placemark administrativeArea]?[placemark administrativeArea]:[placemark locality]];
                }else if((![placemark thoroughfare] && ![placemark locality] && [placemark administrativeArea]) || ([placemark thoroughfare] && ![placemark locality] && ![placemark administrativeArea]) || (![placemark thoroughfare] && [placemark locality] && ![placemark administrativeArea])) {
                    locationMessageInfo.address = [placemark thoroughfare]?[placemark thoroughfare]:[placemark locality]?[placemark locality]:[placemark administrativeArea];
                }else {
                    locationMessageInfo.address = @"";
                }
            }
            osswr = nil;
            !self.locationSelectBlock?: self.locationSelectBlock(locationMessageInfo);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } failure:^(NSError * _Nonnull error) {
        @strongify(self);
        [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"FailedToSend",发送失败) inView:self.mapView];
        osswr=nil;
    }];
}

#pragma mark - Private Methods
- (void)resetTableHeadView {
    if (infoArray.count>0) {
        self.tableView.tableHeaderView = nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0)];
        view.backgroundColor = self.tableView.backgroundColor;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = view.center;
        [indicatorView startAnimating];
        [view addSubview:indicatorView];
        self.tableView.tableHeaderView = view;
    }
}

- (void)addCenterLocationViewWithCenterPoint:(CGPoint)point {
    if (!imgView) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100, 18, 38)];
        imgView.center = point;
        imgView.image = [UIImage imageNamed:@"map_location"];
        imgView.center = self.mapView.center;
        [self.view addSubview:imgView];
    }
}

- (void)getAroundInfoMationWithCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, DEFAULTSPAN, DEFAULTSPAN);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.region = region;
    if (@available(iOS 13.0, *)) {
        request.resultTypes = MKLocalSearchResultTypePointOfInterest;
    }
    if(searchText == nil) {
        request.naturalLanguageQuery = @"Restaurants";
    }else {
        request.naturalLanguageQuery = searchText;;
    }
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error) {
            [self getAroundInfomation:response.mapItems];
        }else{
            self->haveGetUserLocation = NO;
            NSLog(@"Quest around Error:%@",error.localizedDescription);
        }
    }];
    searchText = nil;
}

- (void)getAroundInfomation:(NSArray *)array {
    if(infoArray.count > 0) {
        [infoArray removeAllObjects];
    }
    for (MKMapItem *item in array) {
        MKPlacemark *placemark = item.placemark;
        PlaceInfoModel *model = [[PlaceInfoModel alloc]init];
        model.name = placemark.name;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        [infoArray addObject:model];
    }
    [self.tableView reloadData];
}


#pragma mark Get place names based on coordinates
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    
    // reverse geocoding
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initialData:placemarks];
                [self getAroundInfoMationWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
                [self.tableView reloadData];
                [self resetTableHeadView];
            });
        }else{
            self->haveGetUserLocation = NO;
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
    self.currentLocation = location;
}

- (void)render:(CLLocation *)location {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
    [self addCenterLocationViewWithCenterPoint:self.mapView.center];
    
}


#pragma mark - Initial Data
- (void)initialData:(NSArray *)places {
    if(places.count > 0) {
        if(infoArray.count > 0) {
            [infoArray removeAllObjects];
        }
        for (CLPlacemark *placemark in places) {
            PlaceInfoModel *model = [[PlaceInfoModel alloc]init];
            model.name = placemark.name;
            model.thoroughfare = placemark.thoroughfare;
            model.subThoroughfare = placemark.subThoroughfare;
            model.city = placemark.locality;
            model.coordinate = placemark.location.coordinate;
            [infoArray insertObject:model atIndex:0];
        }
    }
}

#pragma mark － TableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdntifier forIndexPath:indexPath];
    PlaceInfoModel *model = [infoArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.name;
    cell.subTitleLabel.text = model.thoroughfare;
    return cell;
}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceInfoModel *model = [infoArray objectAtIndex:indexPath.row];
    haveGetUserLocation = YES;
    [self getAddressByLatitude:model.coordinate.latitude longitude:model.coordinate.longitude];
    [self render: self.currentLocation];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - touchs
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"moved");
    spanBool = YES;
    haveGetUserLocation = YES;
}

//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//}

#pragma mark - MapView Gesture
- (void)mapViewSpanGesture:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"SpanGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
             NSLog(@"SpanGesture Changed");
            spanBool = YES;
        }
            break;
        case UIGestureRecognizerStateCancelled:{
             NSLog(@"SpanGesture Cancelled");
        }
            break;
        case UIGestureRecognizerStateEnded:{
             NSLog(@"SpanGesture Ended");
        }
            break;
        default:
            break;
    }
}

- (void)mapViewPinchGesture:(UIGestureRecognizer*)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"PinchGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"PinchGesture Changed");
            pinchBool = YES;
        }
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"PinchGesture Cancelled");
        }
            break;
        case UIGestureRecognizerStateEnded:{
            pinchBool = NO;
            NSLog(@"PinchGesture Ended");
        }
            break;
        default:
            break;
    }
}

@end
