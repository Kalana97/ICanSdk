//
//  LocationSearchTableViewController.h
//  ICan
//
//  Created by MAC on 2022-12-05.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "SelectMKMapLocationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationSearchTableViewController : UITableViewController
@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong, nonnull) id<HandleMapSearchDelegate> handleMapSearchDelegate;
@end

NS_ASSUME_NONNULL_END
