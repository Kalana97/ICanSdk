//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 9/6/2021
- File name:  WCDBManager+CircleUserInfo.m
- Description:
- Function List:
*/
        

#import "WCDBManager+CircleUserInfo.h"
#import "CircleUserInfo+WCTTableCoding.h"

@implementation WCDBManager (CircleUserInfo)

-(void)insertCircleUserInfoWithArray:(NSArray<CircleUserInfo *> *)array{
    [self.wctDatabase insertOrReplaceObjects:array into:KWCCircleUserInfoTable];
}
-(CircleUserInfo*)fetchCircleUserInfoWithIcanId:(NSString*)icanId{
    return  [self.wctDatabase getOneObjectOfClass:[CircleUserInfo class] fromTable:KWCCircleUserInfoTable where:CircleUserInfo.icanId==icanId];
}

-(void)fetchCircleCacheUserInfoWithIcanId:(NSString*)icanId successBlock:(void(^)(CircleUserInfo*info))successBlock{
    CircleUserInfo*info= [self.wctDatabase getOneObjectOfClass:[CircleUserInfo class] fromTable:KWCCircleUserInfoTable where:CircleUserInfo.icanId==icanId];
    if (info) {
        successBlock(info);
    }else{
        [self fetchRemoteUserMessageWithIcanId:icanId successBlock:successBlock];
    }
}
-(void)fetchRemoteUserMessageWithIcanId:(NSString *)icanId successBlock:(void (^)(CircleUserInfo * ))successBlock{
    GetUserInfoByIcanIdRequest*request=[GetUserInfoByIcanIdRequest request];
    request.icanId=icanId;
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
        [self insertCircleUserInfoWithArray:@[response]];
        if (successBlock) {
            successBlock(response);
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
    

}
-(CircleUserInfo*)fetchCircleUserInfoWithCircleUserId:(NSString*)circleUserId{
    return  [self.wctDatabase getOneObjectOfClass:[CircleUserInfo class] fromTable:KWCCircleUserInfoTable where:CircleUserInfo.userId==circleUserId];
}

-(void)fetchCircleCacheUserInfoWithCircleUserId:(NSString*)circleUserId successBlock:(void(^)(CircleUserInfo*info))successBlock{
    CircleUserInfo*info= [self.wctDatabase getOneObjectOfClass:[CircleUserInfo class] fromTable:KWCCircleUserInfoTable where:CircleUserInfo.userId==circleUserId];
    if (info) {
        successBlock(info);
    }else{
        [self fetchRemoteUserMessageWithCircleUserId:circleUserId successBlock:successBlock];
    }
}
-(void)fetchRemoteUserMessageWithCircleUserId:(NSString *)circleUserId successBlock:(void (^)(CircleUserInfo * ))successBlock{
    GetCircleUserInfoRequest*request=[GetCircleUserInfoRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/api/users/info/%@",circleUserId];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
        [self insertCircleUserInfoWithArray:@[response]];
        if (successBlock) {
            successBlock(response);
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
    

}
@end
