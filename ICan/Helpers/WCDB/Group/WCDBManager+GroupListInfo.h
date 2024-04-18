//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  WCDBManager+GroupListInfo.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
    


#import "WCDBManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (GroupListInfo)
-(void)deleteGroupListInfoWithGroupId:(NSString*)groupId;
-(void)insertOrUpdateGroupListInfoWithArray:(NSArray<GroupListInfo*>*)array;
/**  查询本地是否存在某个群记录  */
-(void)fetchOneGroupListInfoWithGroupId:(NSString*)groupId successBlock:(void(^)(GroupListInfo*info))successBlock;
-(GroupListInfo*)fetchOneGroupListInfoWithGroupId:(NSString*)groupId;
-(void)updateGroupNameWithGroupId:(NSString*)groupId groupName:(NSString*)grouName;
-(NSArray*)getAllGroupListInfo;
-(void)updateGroupShowUserInfoGroupId:(NSString *)groupId  showUserInfo:(BOOL)showUserInfo;
-(void)deleteAllGroupList;
@end

NS_ASSUME_NONNULL_END
