//
//  BusinessUserRequest.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessUserRequest.h"

@implementation BusinessUserRequest

@end

@implementation GetBusinessRecommendListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}

-(NSString *)requestName{
    return @"Get business List";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/business/recommend/page"];
}
@end

@implementation FollowOrUnfollowBusiness
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}

-(NSString *)requestName{
    return @"Follow or unfollow action";
}
@end

@implementation GetBusinessCurrentUserInfoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}

-(NSString *)requestName{
    return @"获取当前用户登录信息";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/business/info"];
}
@end

@implementation GetBusinessUserInfoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}

-(NSString *)requestName{
    return @"Get business User Info";
}
@end

@implementation LikeCancelLikeBusiness
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}

-(NSString *)requestName{
    return @"Like and Cancel like business";
}
@end

@implementation PutBusinessUserInfo
-(NSString *)description{
    return [self mj_JSONString];
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}

-(NSString *)requestName{
    return @"Update business profile info";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/business/setupBusinessInfo"];
}
@end

@implementation DeleteBusinessPhotosWallRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}

-(NSString *)requestName{
    return @"Delete wall photo";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/business/photos"];
}
@end

@implementation GetBusinessPhotosWallListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}

-(NSString *)requestName{
    return @"Get photo wall list";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/business/photos/myPhotoPage"];
}
@end

@implementation AddBusinessPhotosWallRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}

-(NSString *)requestName{
    return @"Add photos to wall";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/business/photos"];
}
@end

@implementation GetBusinessTypeId
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}

-(NSString *)requestName{
    return @"Get business Types By ID";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/businessType/listByPid"];
}
@end
