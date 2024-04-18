//
//  BusinessUserRequest.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessBaseRequest.h"
#import "BusinessUserResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessUserRequest : BusinessBaseRequest

@end

@interface GetBusinessCurrentUserInfoRequest : BusinessBaseRequest

@end

@interface GetBusinessRecommendListRequest:BusinessListRequest
@property (nonatomic, strong, nullable) NSNumber *areaId;
@property (nonatomic, strong, nullable) NSNumber *cityId;
@property (nonatomic, strong, nullable) NSNumber *countryId;
@property (nonatomic, strong, nullable) NSNumber *provinceId;
@property (nonatomic, strong, nullable) NSNumber *businessTypeId;
@property (nonatomic, strong, nullable) NSNumber *businessSubTypeId;
@end

@interface FollowOrUnfollowBusiness : BusinessBaseRequest
@property (nonatomic, assign) NSUInteger businessId;
@property (nonatomic, assign) BOOL isFollow;
@end

@interface GetBusinessUserInfoRequest : BusinessBaseRequest

@end

@interface LikeCancelLikeBusiness : BusinessBaseRequest

@end

@interface PutBusinessUserInfo : BusinessBaseRequest
@property (nonatomic, copy, nullable)   NSString *address;
@property (nonatomic, strong, nullable) NSNumber *areaId;
@property (nonatomic, copy, nullable)   NSString *avatar;
@property (nonatomic, copy, nullable)   NSString *background;
@property (nonatomic, strong, nullable) NSNumber *businessId;
@property (nonatomic, copy, nullable)   NSString *businessName;
@property (nonatomic, strong, nullable) NSNumber *businessSubType;
@property (nonatomic, strong, nullable) NSNumber *businessType;
@property (nonatomic, strong, nullable) NSNumber *cityId;
@property (nonatomic, strong, nullable) NSNumber *countryId;
@property (nonatomic, copy, nullable)   NSString *Description;
@property (nonatomic, copy, nullable)   NSArray *photos;
@property (nonatomic, strong,nullable) NSNumber *provinceId;
@property (nonatomic, copy, nullable)   NSString *updateTime;
@end

@interface DeleteBusinessPhotosWallRequest:BusinessBaseRequest
@property (nonatomic, strong) NSArray *ids;
@end

@interface GetBusinessPhotosWallListRequest:BusinessListRequest

@end

@interface AddBusinessPhotosWallRequest:BusinessBaseRequest
@property (nonatomic, strong) NSArray *urls;
@end

@interface GetBusinessTypeId:BusinessBaseRequest
@property (nonatomic, strong) NSNumber *pid;
@end
NS_ASSUME_NONNULL_END
