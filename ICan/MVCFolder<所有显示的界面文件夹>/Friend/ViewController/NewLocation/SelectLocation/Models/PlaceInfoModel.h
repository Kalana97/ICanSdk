//
//  PlaceInfoModel.h
//  ICan
//
//  Created by Rohan on 2022-11-10.
//  Copyright © 2022 dzl. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceInfoModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thoroughfare;
@property (nonatomic, strong) NSString *subThoroughfare;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end
