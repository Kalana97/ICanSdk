//
//  BusinessUserResponse.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"
#import "BusinessBaseResponse.h"
@class UploadImgModel;
@class AreaInfo;
NS_ASSUME_NONNULL_BEGIN

@interface BusinessUserResponse : BaseResponse

@end

@interface BusinessRecommendListInfo : BusinessListInfo

@end

@interface BusinessPhotoWallList : NSObject
@property (nonatomic, assign) NSInteger businessId;
@property (nonatomic, copy) NSString *checkPhoto;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, assign) NSInteger photoWallId;
@property (nonatomic, assign) BOOL select;
@end

@interface BusinessUserInfo : NSObject
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *areaEn;
@property (nonatomic, copy) NSString *businessDescription;
@property (nonatomic, assign) NSInteger businessId;
@property (nonatomic, copy) NSString *businessLogo;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, copy) NSArray *businessPhotoWallList;
@property (nonatomic, copy) NSString *businessSubType;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, assign) BOOL isFollowedByMe;
@property (nonatomic, copy) NSString *showDistance;
@end

@interface BusinessTypeInfo : NSObject
@property (nonatomic, copy, nullable)   NSString *businessType;
@property (nonatomic, copy, nullable)   NSString *businessTypeEn;
@property (nonatomic, assign) NSInteger businessTypeId;
@property (nonatomic, copy)   NSArray *businessTypeList;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, assign) BOOL exist;
@property (nonatomic, copy) NSString *pinyinName;
@end

@interface BusinessCurrentUserInfo : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *areaEn;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *businessDescription;
@property (nonatomic, assign) NSInteger businessId;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, assign) NSInteger businessSubType;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, copy) NSString *checkAvatar;
@property (nonatomic, copy) NSString *checkBackground;
@property (nonatomic, copy) NSString *checkBusinessDescription;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger countryId;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger icanId;
@property (nonatomic, assign) BOOL isFollowingByMe;
@property (nonatomic, assign) BOOL isLikeByMe;
@property (nonatomic, copy)   NSString *lastLoginTime;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger numberId;
@property (nonatomic, copy)   NSArray *photoWalls;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) BOOL isPublish;
@property (nonatomic, copy)   NSString *token;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, copy) NSString *showDistance;
@property (nonatomic, copy) NSString *showArea;
@property (nonatomic, copy, nullable) NSString *businessTypeName;
@property (nonatomic, copy, nullable) NSString *businessTypeNameEn;
@property (nonatomic, copy, nullable) NSString *businessSubTypeName;
@property (nonatomic, copy, nullable) NSString *businessSubTypeNameEn;
@property (nonatomic, assign) BOOL businessTypeUpdated;
@property (nonatomic, strong) NSArray<AreaInfo *> *currentSelectItems;
@property (nonatomic, strong) NSArray<BusinessTypeInfo *> *currentSelectTypes;
@end

@interface BusinessPhotoWallListInfo : BusinessListInfo

@end

NS_ASSUME_NONNULL_END
