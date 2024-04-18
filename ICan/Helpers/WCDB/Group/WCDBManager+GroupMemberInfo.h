//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 26/9/2019
- File name:  WCDBManager+GroupMemberInfo.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        




#import "WCDBManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (GroupMemberInfo)
-(void)deleteAllGroupMemberByGroupId:(NSString*)groupId;
/// 插入或跟新某个群成员
/// @param array array description
-(void)insertOrReplaceGroupMemberInfoWithArray:(NSArray<GroupMemberInfo*>*)array;
-(NSArray*)getAllGroupMemberByGroupId:(NSString*)groupId;
/// 获取某个群成员在某个群的信息
/// @param groupId groupId description
/// @param userId userId description
/// @param successBlock successBlock description
-(void)fetchGroupMemberInfoWihtGroupId:(NSString*)groupId userId:(NSString*)userId successBlock:(void (^)(GroupMemberInfo*memberInfo))successBlock;

/// 更新某个群的某个成员的备注
/// @param groupId groupId description
/// @param userId userId description
-(void)updateGroupMemberInfoWihtGroupId:(NSString*)groupId userId:(NSString*)userId groupNickname:(NSString*)groupNickname;

/// 更新某个群成员的头像地址
/// @param userId userId description
/// @param headImg headImg description
-(void)updateGroupMemberHeadImageUrlWithUserId:(NSString*)userId headImg:(NSString*)headImg;
-(NSArray<GroupMemberInfo*>*)fetctGroupMemnberBySearchText:(NSString*)searchText;
@end


NS_ASSUME_NONNULL_END
