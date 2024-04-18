//
//  SelectMKMapLoactionViewController.h
//  ICan
//
//  Created by MAC on 2022-10-25.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HandleMapSearchDelegate <NSObject>

- (void)dropPinZoomIn:(MKPlacemark*)placemark searchText:(NSString*)searchBarText;

@end

@interface SelectMKMapLocationViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
typedef void(^locationSelectBlock)(LocationMessageInfo *locationInfo);
@property(copy, nonatomic) void(^backAction)(void);
@property (copy, nonatomic) locationSelectBlock locationSelectBlock;
@end

NS_ASSUME_NONNULL_END
