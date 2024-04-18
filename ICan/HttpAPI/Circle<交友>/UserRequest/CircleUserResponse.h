//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleUserResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"
@class UploadImgModel;
@class AreaInfo;
NS_ASSUME_NONNULL_BEGIN

@interface CircleUserResponse : BaseResponse

@end
/**
 获取全部的标签
 */
@interface HobbyTagsInfo:NSObject
@property (nonatomic, assign) BOOL commonlyUsed;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger hobbyTagId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger useNumber;
@property(nonatomic, assign) BOOL select;
@property(nonatomic, copy) NSString *nameEn;
@property(nonatomic, copy) NSString *showName;
@end
/**
 职业不定期国际化 TODO国际化
 */
@interface ProfessionInfo : NSObject
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger professionId;
@property (nonatomic, copy) NSString * professionName;
@property(nonatomic, copy)  NSString *professionNameEn;
@property(nonatomic, copy) NSString *showProfessionName;
@end

/** 省市区返回 */
@interface AreaInfo : NSObject
@property(nonatomic, assign) NSInteger areaId;
@property(nonatomic, copy) NSString * areaName;
@property(nonatomic, copy) NSString *areaNameEn;
@property(nonatomic, copy) NSString *areaNum;
@property(nonatomic, strong) NSArray<AreaInfo*> * areas;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, assign) NSInteger parentId;
@property(nonatomic, copy) NSString *pinyinName;
@property(nonatomic, assign) BOOL select;
@end
//{
//    "likeMe": 0,
//    "meLike": 0
//}
@interface LikeMeOrMeLikeCountInfo:NSObject
@property(nonatomic, assign) NSInteger likeMe;
@property(nonatomic, assign) NSInteger meLike;
@end
@interface CircleRecommendListInfo:CircleListInfo
@end
@interface CircleILikeListInfo : CircleListInfo

@end
/**
 点赞个数
 */
@interface UserGoodInfo : NSObject
@property(nonatomic, assign) NSInteger goodCount;
@property(nonatomic, assign) BOOL isGood;
@end
/**
 是否在线复制接口复制文档复制地址
 GET
 /api/users/online/{icanId}
 */
@interface UsersonlineInfo:NSObject
@property(nonatomic, assign) BOOL online;
@property(nonatomic, copy) NSString* lastOnlineTime;
@end
@interface PackagesTitleInfo:NSObject
/**
 套餐名称
 */
@property (nonatomic, strong) NSString * packageName;
/**
 套餐名称 英文
 */
@property(nonatomic, copy) NSString *packageNameEn;
@property(nonatomic, copy) NSString *showLocalPackageName;
/** 套餐副标题 */
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *titleEn;
@property(nonatomic, copy) NSString *showLocaltitle;
@end
/**
获取套餐
 */
@interface PackagesInfo : PackagesTitleInfo
@property (nonatomic, assign) NSInteger commissionRate;
@property (nonatomic, strong) NSString * createTime;
/**
 是否删除
 */
@property (nonatomic, assign) BOOL deleted;
/**
 是否启用
 */
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString* packageId;

/**
 套餐类型,可用值:Time,Count
 */
@property (nonatomic, strong) NSString * packageType;
/**
 单价
 */
@property (nonatomic, assign) float price;
/**
 总次数
 */
@property (nonatomic, assign) NSInteger totalCount;
/**
 总时长(天)
 */
@property (nonatomic, assign) NSInteger totalTime;
/**
 金额单位
 */
@property (nonatomic, strong) NSString * unit;
@property (nonatomic, strong) NSString * updateTime;
/**
 权重，数字越大，越靠前
 */
@property (nonatomic, assign) NSInteger weights;

@property(nonatomic, assign) BOOL select;

@end

@interface MyPackagesInfo : PackagesInfo
@property (nonatomic, assign) BOOL available;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, copy) NSString* myPackageId;
@property (nonatomic, strong) NSString * payStatus;
@property (nonatomic, strong) NSString * payTime;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, assign) NSInteger useCount;
@property (nonatomic, assign) NSInteger userId;
@property(nonatomic, copy) NSString *logo;
@end
@interface MyPackagesListInfo : CircleListInfo

@end
/**
 myPackages/check
 */
@interface CheckMyPackagesInfo : NSObject
//是否需要购买  yes不需要购买
@property (nonatomic, assign) BOOL available;
@property(nonatomic, strong) MyPackagesInfo *myPackage;
///是否需要弹框
@property(nonatomic, assign) BOOL needToUse;
@end


@interface ConsumptionRecordsInfo : PackagesTitleInfo
@property (nonatomic, assign) NSInteger myPackageId;
@property (nonatomic, assign) NSInteger myPackageItemId;
@property (nonatomic, strong) NSString * packageType;
@property (nonatomic, strong) NSString * targetUserAvatar;
@property (nonatomic, strong) NSString * targetUserGender;
@property (nonatomic, copy)   NSString* targetUserId;
@property (nonatomic, strong) NSString * targetUserNickname;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, copy) NSString* userId;
@end
@interface ConsumptionRecordsListInfo : CircleListInfo

@end
@interface PayMyPackagesInfo : NSObject
@property (nonatomic, assign) BOOL available;
@property (nonatomic, assign) NSInteger commissionRate;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, assign) NSInteger myPackageId;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * packageName;
@property (nonatomic, strong) NSString * packageType;
@property (nonatomic, strong) NSString * payStatus;
@property (nonatomic, strong) NSString * payTime;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, strong) NSString * transactionId;
@property (nonatomic, strong) NSString * unit;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, assign) NSInteger useCount;
@property (nonatomic, assign) NSInteger userId;
/**
 英文标题
 */
@property(nonatomic, copy) NSString *titleEn;
@end
@interface GetCircleDislikeMeInfo : NSObject
@property(nonatomic, assign) BOOL dislikeMe;
@end
@interface PostCircleReleaseBuyInfo:NSObject
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *payTime;
@property(nonatomic, copy) NSString *releaseOrderId;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *transactionId;

@end
@interface PostReleaseMoneyInfo : NSObject
@property(nonatomic, assign) float money;
@end

@interface PhotoWallInfo : NSObject
@property(nonatomic, copy) NSString* createTime;
@property(nonatomic, copy) NSString* photoWallId;
@property(nonatomic, copy) NSString* url;
@property(nonatomic, copy) NSString* userId;
@property(nonatomic, assign) NSInteger weights;
@property(nonatomic, assign) BOOL select;
@property(nonatomic, strong) UIImage *image;
@end
@interface PhotoWallListInfo : CircleListInfo

@end
NS_ASSUME_NONNULL_END

