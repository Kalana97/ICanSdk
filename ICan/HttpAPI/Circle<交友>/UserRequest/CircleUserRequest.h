//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleUserRequest.h
- Description:
- Function List:
*/
        

#import "CircleBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface
CircleUserRequest : CircleBaseRequest

@end
///api/users/info 获取当前用户登录信息
@interface GetCircleCurrenUserInfoRequest : CircleBaseRequest

@end
///api/users/info 设置用户信息
@interface PutCircleUserInfoRequest : CircleBaseRequest
@property (nonatomic, copy,nullable) NSString * avatar;
@property (nonatomic, strong,nullable) NSNumber* bodyHeight;
@property (nonatomic ,strong,nullable) NSNumber* bodyWeight;
@property (nonatomic, strong,nullable) NSString * constellation;
@property (nonatomic, strong,nullable) NSString * dateOfBirth;
@property (nonatomic, strong,nullable) NSString * education;
/** 性别,可用值:Male,Female,Unknown */
@property (nonatomic, copy,nullable) NSString * gender;
@property (nonatomic, copy,nullable) NSString * nickname;
@property (nonatomic, strong,nullable) NSArray * photos;
@property (nonatomic, copy,nullable) NSString * poiAddress;
@property (nonatomic, copy,nullable) NSString * signature;
@property (nonatomic, strong,nullable) NSArray * hobbyIdList;
@property (nonatomic, strong,nullable) NSNumber* cityId;
@property (nonatomic, strong,nullable) NSNumber* countryId;;
@property (nonatomic, strong,nullable) NSNumber* provinceId;
@property (nonatomic, strong,nullable) NSNumber* areaId;
@property (nonatomic, strong,nullable) NSNumber* latitude;
@property (nonatomic, strong,nullable) NSNumber* longitude;
@property (nonatomic, strong,nullable) NSNumber* professionId;
/** 背景图片 */
@property(nonatomic, copy,nullable) NSString *background;
/** 是否约 */
@property(nonatomic, strong,nullable) NSNumber *yue;

@end
////api/users/first  初次设置用户信息
@interface PutCircleUserInfoFirstRequest : CircleBaseRequest

@property (nonatomic, copy,nullable) NSString * avatar;
@property (nonatomic, strong,nullable) NSNumber* bodyHeight;
@property (nonatomic ,strong,nullable) NSNumber* bodyWeight;
@property (nonatomic, strong,nullable) NSString * constellation;
@property (nonatomic, strong,nullable) NSString * dateOfBirth;
@property (nonatomic, strong,nullable) NSString * education;
/** 性别,可用值:Male,Female,Unknown */
@property (nonatomic, copy,nullable) NSString * gender;
@property (nonatomic, copy,nullable) NSString * nickname;
@property (nonatomic, strong,nullable) NSArray * photos;
@property (nonatomic, copy,nullable) NSString * poiAddress;
@property (nonatomic, copy,nullable) NSString * signature;
@property (nonatomic, strong,nullable) NSArray * hobbyIdList;
@property (nonatomic, strong,nullable) NSNumber* cityId;
@property (nonatomic, strong,nullable) NSNumber* countryId;;
@property (nonatomic, strong,nullable) NSNumber* provinceId;
@property (nonatomic, strong,nullable) NSNumber* areaId;
@property (nonatomic, strong,nullable) NSNumber* latitude;
@property (nonatomic, strong,nullable) NSNumber* longitude;
@property (nonatomic, strong,nullable) NSNumber* professionId;

@end
///api/users/poi 设置用户经纬度
@interface PutCircleUserPOIRequest :CircleBaseRequest
//小数点6位小数
@property (nonatomic, strong) NSString* latitude;
@property (nonatomic, strong) NSString* longitude;
@property (nonatomic, copy,nullable) NSString * poiAddress;
@end
/**
 获取全部的标签
 /api/hobbyTags
 */
@interface GetHobbyTagsRequest : CircleBaseRequest

@end
/**
 添加标签
 /api/hobbyTags
 */
@interface PostHobbyTagsRequest : CircleBaseRequest
@property(nonatomic, copy) NSString *name;
@end
/**
 /api/professions
 获取职业
 */
@interface GetProfessionsRequest : CircleBaseRequest

@end
/**
 /api/users/likeMeOrMeLikeCount
 喜欢我的和我喜欢的数量
 */
@interface GetLikeMeOrMeLikeCountRequest : CircleBaseRequest

@end
/**
 /api/users/online/{icanId}
 用户是否在线
 */
@interface GetUsersOnlineRequest : CircleBaseRequest

@end
///api/users/info/{id} 获取用户信息
@interface GetCircleUserInfoRequest : CircleBaseRequest

@end
/**
 /api/users/recommend/page
 推荐列表
 */
@interface GetCircleRecommendListRequest:CircleListRequest
/**
 
 */
@property(nonatomic, strong, nullable) NSNumber *areaId;
/**
 
 */
@property(nonatomic, strong, nullable) NSNumber *cityId;
/**
 
 */
@property(nonatomic, strong, nullable) NSNumber *countryId;
/**
 
 */
@property(nonatomic, strong, nullable) NSNumber *provinceId;
/**
 
 */
@property(nonatomic, copy, nullable) NSString *gender;
/**
 最大年龄
 */
@property(nonatomic, strong, nullable) NSNumber *maxAge;
/**
 最小年龄    
 */
@property(nonatomic, strong, nullable) NSNumber *minAge;
/** 萌新
 */
@property(nonatomic, strong, nullable) NSNumber* isNewUser;

@end
/**
 /api/dislikeUsers
 添加不喜欢的人
 */
@interface PostDislikeUsersRequest : CircleBaseRequest
@property(nonatomic, copy) NSString* dislikeUserId;
@end
/**
 /api/dislikeUsers/page
 获取我不喜欢的人
 */
@interface GetDislikeUsersListRequest : CircleListRequest

@end
/**
 删除不喜欢的人记录复制接口复制文档复制地址
 PUT
 /api/dislikeUsers/remove
 */
@interface PUTDislikeUsersRequest : CircleBaseRequest
@property(nonatomic, copy) NSString* dislikeUserId;
@end

/**
 添加喜欢的人复制接口复制文档复制地址
 POST
 /api/likeUsers
 */
@interface PostLikeUsersRequest : CircleBaseRequest
@property(nonatomic, copy) NSString* likeUserId;
@end
/**
 获取我喜欢的人复制接口复制文档复制地址
 GET
 /api/likeUsers/page
 */
@interface GetLikeUsersListRequest : CircleListRequest

@property(nonatomic, assign) bool likeMe;
@end
/**
 删除喜欢的人记录复制接口复制文档复制地址
 PUT
 /api/likeUsers/remove
 请求数据类型application/json
 */
@interface PUTLikeUsersRequest : CircleBaseRequest
@property(nonatomic, copy) NSString* likeUserId;
@end
/**
 点赞个数
 GET
 /api/users/good/{id}
 */
@interface GetUserGoodRequest : CircleBaseRequest

@end
/**
 点赞-取消点赞
 POST
 /api/users/good/{id}
 */
@interface PostUserGoodRequest : CircleBaseRequest

@end
/**
 /api/packages
 获取可以购买的套餐
 */
@interface GetPackagesRequest : CircleBaseRequest

@end
/**
 我的套餐复制接口复制文档复制地址
 GET
 /api/myPackages/page
 */
@interface GetMyPackagesListRequest : CircleListRequest

@end
/**
 购买套餐
 POST
 /api/myPackages/pay
 */
@interface PostMyPackagesRequest : CircleBaseRequest
@property(nonatomic, copy) NSString *packageId;
@end
/**
 检查套餐
 GET
 /api/myPackages/checkPackage
 */
@interface CheckMyPackagesRequest : CircleBaseRequest
/**1 会话列表 2 个人中心 */
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, copy) NSString *targetUserId;

@end
/**
 我的套餐消费记录详情
 GET
 /api/myPackages/item/page
 */
@interface ConsumptionRecordsListRequest : CircleListRequest
@property(nonatomic, copy,nullable) NSString *myPackageId;
@end
/**
 投诉复制接口复制文档复制地址
 POST
 /api/complaints
 */
@interface PostComplaintsRequest : CircleListRequest
@property(nonatomic, copy,nullable) NSString *content;
@property(nonatomic, copy,nullable) NSArray *images;
@property(nonatomic, copy) NSString *targetUserId;
@end
/**
 通过icanId获取用户信息
 /api/users/infoByIcanId
 */
@interface GetUserInfoByIcanIdRequest : CircleBaseRequest
@property(nonatomic, copy) NSString *icanId;
@end

/**
 购买套餐检查是否支付成功
 GET
 /api/myPackages/pay/{transactionId}
 */
@interface CheckMyPackagesPaySuccessRequest : CircleBaseRequest

@end

@interface DeleteCircleUserRequest : CircleBaseRequest

@end
/**
 使用套餐
 GET
 /api/myPackages/usePackage
 */
@interface UsePackageRequest : CircleBaseRequest
/**1 会话列表 2 个人中心 */
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, copy) NSString *targetUserId;
@end
/**
 userId 是否不喜欢我
 GET
 /api/dislikeUsers/dislikeMe/{userId}
 */
@interface GetCircleDislikeMeRequest : CircleBaseRequest

@end
/**
 购买发布
 POST
 /api/release/buy
 */
@interface PostCircleReleaseBuyRequest : CircleBaseRequest


@end
/**
 发布要多少钱
 POST
 /api/release/money
 */
@interface PostReleaseMoneyRequest:CircleBaseRequest

@end
/**
 根据用户ID获取喜欢我的和我喜欢的数量复制接口复制文档复制地址
 GET
 /api/users/likeMeOrMeLikeCount/{uid}
 */
@interface GetOtherlikeMeOrMeLikeCountRequest:CircleBaseRequest

@end
/**
 添加照片
 /api/photos
 */
@interface AddPhotosWallRequest:CircleBaseRequest
@property(nonatomic, strong) NSArray *urls;
@end
/**
 添加照片
 /api/photos
 */
@interface DeletePhotosWallRequest:CircleBaseRequest
@property(nonatomic, strong) NSArray *ids;
@end
/**
 获取照片墙
 GET
 /api/photos/page
 */
@interface GetPhotosWallListRequest:CircleListRequest

@end
NS_ASSUME_NONNULL_END
