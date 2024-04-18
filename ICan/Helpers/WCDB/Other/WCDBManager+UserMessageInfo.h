//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 26/9/2019
- File name:  WCDBManager+UserMessageInfo.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        


#import "WCDBManager.h"
#import "UserMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (UserMessageInfo)

-(void)insertUserMessageInfoWithArray:(NSArray<UserMessageInfo*>*)array;

/// 插入好友用户数据
/// @param userMessageInfo userMessageInfo description
-(void)insertUserMessageInfo:(UserMessageInfo*)userMessageInfo;


/// 更新是否是好友
/// @param userId userId description
/// @param isFriend isFriend description
-(void)updateFriendRelationWithUserId:(NSString*)userId isFriend:(BOOL)isFriend;

/// 更新好友备注
/// @param userId userId description
/// @param remark remark description
-(void)updateFriendRemarkNameWithUserId:(NSString*)userId remark:(NSString*)remark;
-(UserMessageInfo*)fetchUserMessageInfoWithUserId:(NSString*)userId;
/**  查询本地是否存在某个用户记录  */
-(void)fetchUserMessageInfoWithUserId:(NSString*)userId successBlock:(void(^)(UserMessageInfo*info))successBlock;

-(NSArray<UserMessageInfo*>*)fetchFriendList;

-(void)judgeIsFriendWithUserId:(NSString*)userId successBlock:(void(^)(BOOL isFriend))successBlock;

-(void)updateUserHeadImgWith:(NSString*)headImgUrl chatId:(NSString*)chatId;
-(void)deleteUserMessageInfoWithUserId:(NSString*)userId;

-(void)updateUserReadReceipt:(BOOL)readReceipt chatId:(NSString*)chatId;

/**  查询本地是否存在某个用户记录  */
-(void)fetchUserMessageInfoWithNumberId:(NSString*)numberId successBlock:(void(^)(UserMessageInfo*info))successBlock;
@end

NS_ASSUME_NONNULL_END
