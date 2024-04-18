//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleUserRequest.m
- Description:
- Function List:
*/
        

#import "CircleUserRequest.h"

@implementation CircleUserRequest

@end
@implementation GetCircleCurrenUserInfoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取当前用户登录信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/users/info"];
}
@end
@implementation PutCircleUserInfoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置当前用户登录信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/users/info"];
}
@end
@implementation PutCircleUserInfoFirstRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"初次设置当前用户登录信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/users/first"];
}
@end
@implementation PutCircleUserPOIRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置用户经纬度";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/users/poi"];
}
@end
@implementation GetHobbyTagsRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取全部的标签";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/hobbyTags"];
}
@end
@implementation PostHobbyTagsRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"添加标签";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/hobbyTags"];
}
@end

@implementation GetProfessionsRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取全部的职业";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/professions"];
}
@end
@implementation GetLikeMeOrMeLikeCountRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"喜欢我的和我喜欢的数量";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/users/likeMeOrMeLikeCount"];
}
@end
@implementation GetUsersOnlineRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"用户是否在线";
}
@end
@implementation GetCircleUserInfoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取用户信息";
}
@end

/**
 /api/users/recommend/page
 推荐列表
 */
@implementation GetCircleRecommendListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"推荐列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/users/recommend/page"];
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"isNewUser":@"newsUser"};
}
@end
/**
 /api/dislikeUsers
 添加不喜欢的人
 */
@implementation PostDislikeUsersRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"添加不喜欢的人";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/dislikeUsers"];
}
@end
/**
 /api/dislikeUsers/page
 获取我不喜欢的人
 */
@implementation GetDislikeUsersListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取我不喜欢的人";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/dislikeUsers/page"];
}
@end
/**
 删除不喜欢的人
 PUT
 /api/dislikeUsers/remove
 */
@implementation PUTDislikeUsersRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"删除不喜欢的人";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/dislikeUsers/remove"];
}
@end
/**
 添加喜欢的人复制接口复制文档复制地址
 POST
 /api/likeUsers
 */
@implementation PostLikeUsersRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"添加喜欢的人喜欢的人";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/likeUsers"];
}
@end
/**
 获取我喜欢的人复制接口复制文档复制地址
 GET
 /api/likeUsers/page
 */
@implementation GetLikeUsersListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取我喜欢的人";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/likeUsers/page"];
}
@end
/**
 删除喜欢的人记录复制接口复制文档复制地址
 PUT
 /api/likeUsers/remove
 请求数据类型application/json
 */
@implementation PUTLikeUsersRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"删除喜欢的人记录";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/likeUsers/remove"];
}
@end
/**
 点赞个数复制接口复制文档复制地址
 GET
 /api/users/good/{id}
 */
@implementation GetUserGoodRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"点赞个数";
}

@end
/**
 点赞-取消点赞复制接口复制文档复制地址
 POST
 /api/users/good/{id}
 */
@implementation PostUserGoodRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"点赞-取消点赞";
}

@end
/**
 /api/packages
 获取可以购买的套餐
 */
@implementation GetPackagesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取可以购买的套餐";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/packages"];
}
@end
/**
 我的套餐
 GET
 /api/myPackages/page
 */
@implementation GetMyPackagesListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"我的套餐";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/myPackages/page"];
}
@end
/**
 POST
 /api/myPackages/pay
 */
@implementation PostMyPackagesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"购买我的套餐";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/myPackages/pay"];
}
@end
/**
 检查套餐
 GET
 /api/myPackages/check
 */
@implementation CheckMyPackagesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"检查套餐";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/myPackages/checkPackage"];
}
@end
/**
 我的套餐消费记录详情
 GET
 /api/myPackages/item/page
 */
@implementation ConsumptionRecordsListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"购买我的套餐";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/myPackages/item/page"];
}
@end
/**
 投诉复制接口复制文档复制地址
 POST
 /api/complaints
 */

@implementation PostComplaintsRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"投诉";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/complaints"];
}
@end
/**
 通过icanId获取用户信息
 /api/users/infoByIcanId
 */
@implementation GetUserInfoByIcanIdRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取用户信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/users/infoByIcanId"];
}
@end
@implementation CheckMyPackagesPaySuccessRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"购买套餐检查是否支付成功";
}
@end
@implementation DeleteCircleUserRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"注销用户";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/users"];
}
@end
@implementation UsePackageRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"使用套餐";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/myPackages/usePackage"];
}
@end
/**
 userId 是否不喜欢我
 GET
 /api/dislikeUsers/dislikeMe/{circleUserId}
 */

@implementation GetCircleDislikeMeRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"是否不喜欢我";
}
@end
/**
 购买发布
 POST
 /api/release/buy
 */
@implementation PostCircleReleaseBuyRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"购买发布";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/release/buy"];
}
@end
@implementation PostReleaseMoneyRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"发布要多少钱";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/release/money"];
}
@end
@implementation GetOtherlikeMeOrMeLikeCountRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"根据用户ID获取喜欢我的和我喜欢的数量";
}

@end


@implementation AddPhotosWallRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"添加照片";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/photos"];
}
@end
@implementation DeletePhotosWallRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除照片";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/photos"];
}
@end
@implementation GetPhotosWallListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @" 获取照片墙";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/photos/page"];
}
@end
