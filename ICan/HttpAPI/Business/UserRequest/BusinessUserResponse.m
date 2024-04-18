//
//  BusinessUserResponse.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessUserResponse.h"

@implementation BusinessUserResponse

@end

@implementation BusinessPhotoWallList

@end

@implementation BusinessUserInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"businessPhotoWallList":[BusinessPhotoWallList class]};
}

-(NSString *)showDistance{
    double distance = self.distance.doubleValue;
    NSString *show;
    NSDecimalNumber *distanceNumber = [NSDecimalNumber decimalNumberWithString:self.distance.stringValue];
    NSComparisonResult result = [distanceNumber compare:@(0.0)];
    NSComparisonResult tworesult = [distanceNumber compare:@(1.0)];
    if (result == NSOrderedSame) {
        show = @"10m";
    }else if(tworesult == NSOrderedAscending){
        show = [NSString stringWithFormat:@"%.fm",distance*1000];
    }else{
        show = [NSString stringWithFormat:@"%.fkm",distance];
    }
    return show;
}
@end

@implementation BusinessRecommendListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[BusinessUserInfo class]};
}
@end

@implementation BusinessCurrentUserInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"photoWalls":[BusinessPhotoWallList class]};
}

-(NSString *)showDistance{
    double distance = self.distance.doubleValue;
    NSString *show;
    NSDecimalNumber *distanceNumber = [NSDecimalNumber decimalNumberWithString:self.distance.stringValue];
    NSComparisonResult result = [distanceNumber compare:@(0.0)];
    NSComparisonResult tworesult = [distanceNumber compare:@(1.0)];
    if (result == NSOrderedSame) {
        show = @"10m";
    }else if(tworesult == NSOrderedAscending){
        show = [NSString stringWithFormat:@"%.fm",distance*1000];
    }else{
        show = [NSString stringWithFormat:@"%.fkm",distance];
    }
    return show;
}

-(NSString *)showArea{
    if (self.countryId) {
        NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"area" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSArray *currentAllAreaItems = [AreaInfo mj_objectArrayWithKeyValuesArray:string.mj_JSONString];
        NSMutableString *areal = [[NSMutableString alloc]init];
        AreaInfo *countryInfo;
        for (AreaInfo *info in currentAllAreaItems) {
            if (info.areaId == self.countryId) {
                countryInfo = info;
                [areal appendString:countryInfo.areaName];
                break;
            }
        }
        AreaInfo *provinceInfo;
        if (countryInfo) {
            if (self.provinceId) {
                for (AreaInfo *info in countryInfo.areas) {
                    if (info.areaId == self.provinceId) {
                        provinceInfo = info;
                        [areal appendString:@" "];
                        [areal appendString:provinceInfo.areaName];
                        break;
                    }
                }
            }
        }
        AreaInfo *cityInfo;
        if (provinceInfo) {
            if (self.cityId) {
                for (AreaInfo *info in provinceInfo.areas) {
                    if (info.areaId == self.cityId) {
                        cityInfo = info;
                        [areal appendString:@" "];
                        [areal appendString:cityInfo.areaName];
                        break;
                    }
                }
            }
        }
        AreaInfo *areaInfo;
        if (cityInfo) {
            if (self.areaId) {
                for (AreaInfo *info in cityInfo.areas) {
                    if (info.areaId == self.areaId) {
                        areaInfo = info;
                        [areal appendString:@" "];
                        [areal appendString:cityInfo.areaName];
                        break;
                    }
                }
            }
        }
        return areal;
    }
    return nil;
}
@end

@implementation BusinessPhotoWallListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[BusinessPhotoWallList class]};
}
@end

@implementation BusinessTypeInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"businessTypeList":[BusinessTypeInfo class]};
}
@end

