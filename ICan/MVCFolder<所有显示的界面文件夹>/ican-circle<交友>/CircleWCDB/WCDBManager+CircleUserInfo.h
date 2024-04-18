//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 9/6/2021
- File name:  WCDBManager+CircleCacheUserInfo.h
- Description:
- Function List:
*/
        

#import "WCDBManager.h"
@class CircleUserInfo;
NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (CircleUserInfo)
-(void)insertCircleUserInfoWithArray:(NSArray<CircleUserInfo *> *)array;
-(CircleUserInfo*)fetchCircleUserInfoWithIcanId:(NSString*)icanId;
/**  查询本地是否存在某个用户记录  */
-(void)fetchCircleCacheUserInfoWithIcanId:(NSString*)icanId successBlock:(void(^)(CircleUserInfo*info))successBlock;


-(CircleUserInfo*)fetchCircleUserInfoWithCircleUserId:(NSString*)circleUserId;
/**  查询本地是否存在某个用户记录  */
-(void)fetchCircleCacheUserInfoWithCircleUserId:(NSString*)circleUserId successBlock:(void(^)(CircleUserInfo*info))successBlock;
@end

NS_ASSUME_NONNULL_END

