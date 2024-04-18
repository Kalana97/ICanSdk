
//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 26/9/2019
 - File name:  WCDBManager+GroupMemberInfo.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "WCDBManager+GroupMemberInfo.h"
#import "GroupMemberInfo+WCTTableCoding.h"
@implementation WCDBManager (GroupMemberInfo)
-(void)deleteAllGroupMemberByGroupId:(NSString *)groupId{
    [self.wctDatabase deleteObjectsFromTable:KWCGroupMemberInfoTable where:GroupMemberInfo.groupId==groupId];
}
-(void)insertOrReplaceGroupMemberInfoWithArray:(NSArray<GroupMemberInfo *> *)array{
    [self.wctDatabase insertOrReplaceObjects:array into:KWCGroupMemberInfoTable];
}
-(NSArray*)getAllGroupMemberByGroupId:(NSString*)groupId{
    
    return  [self.wctDatabase getObjectsOfClass:[GroupMemberInfo class] fromTable:KWCGroupMemberInfoTable where:GroupMemberInfo.groupId==groupId orderBy:{GroupMemberInfo.role.order(WCTOrderedAscending),GroupMemberInfo.vip.order(WCTOrderedDescending)}];
}
-(void)updateGroupMemberHeadImageUrlWithUserId:(NSString *)userId headImg:(NSString *)headImg{
    if (headImg) {
        [self.wctDatabase updateRowsInTable:KWCGroupMemberInfoTable onProperty:GroupMemberInfo.headImgUrl withValue:headImg where:GroupMemberInfo.userId==userId];
    }
    
}
-(NSArray*)getGroupMemberByGroupId:(NSString*)groupId{
    return  [self.wctDatabase getObjectsOfClass:[GroupMemberInfo class] fromTable:KWCGroupMemberInfoTable where:{GroupMemberInfo.groupId==groupId}];
}
-(void)fetchGroupMemberInfoWihtGroupId:(NSString *)groupId userId:(NSString *)userId successBlock:(void (^)(GroupMemberInfo * _Nonnull))successBlock{
    GroupMemberInfo*info= [self.wctDatabase getOneObjectOfClass:[GroupMemberInfo class] fromTable:KWCGroupMemberInfoTable where:GroupMemberInfo.groupId==groupId&&GroupMemberInfo.userId==userId];
    if (info) {
        successBlock(info);
    }else{
        GetGroupUserListRequest*request=[GetGroupUserListRequest request];
        if (userId) {
            request.groupId=groupId;
            request.ids=@[userId];
            request.parameters=[request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupMemberInfo class] success:^(NSArray<GroupMemberInfo*>* response) {
                successBlock(response.firstObject);
                [self insertOrReplaceGroupMemberInfoWithArray:response];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }
        
    }
}
-(NSArray<GroupMemberInfo*>*)fetctGroupMemnberBySearchText:(NSString*)searchText{
    NSString*sear=[NSString stringWithFormat:@"%%%@%%",searchText];
    NSArray*array=[self.wctDatabase getObjectsOfClass:[GroupMemberInfo class] fromTable:KWCGroupMemberInfoTable where:{GroupMemberInfo.nickname.like(sear)||GroupMemberInfo.numberId.like(sear)||GroupMemberInfo.groupRemark.like(sear)}];
    NSMutableDictionary*rdict=[NSMutableDictionary dictionary];
    for (GroupMemberInfo*menberInfo in array) {
        NSMutableArray*rArray=[NSMutableArray arrayWithArray:[rdict objectForKey:menberInfo.groupId]];
        [rArray addObject:menberInfo];
        [rdict setObject:rArray forKey:menberInfo.groupId];
    }
    return rdict.allValues;
}
-(void)updateGroupMemberInfoWihtGroupId:(NSString *)groupId userId:(NSString *)userId groupNickname:(NSString*)groupNickname{
    if (groupNickname) {
        GroupMemberInfo*info= [self.wctDatabase getOneObjectOfClass:[GroupMemberInfo class] fromTable:KWCGroupMemberInfoTable where:GroupMemberInfo.groupId==groupId&&GroupMemberInfo.userId==userId];
        if (info) {
            [self.wctDatabase updateRowsInTable:KWCGroupMemberInfoTable onProperty:GroupMemberInfo.nickname withValue:groupNickname where:GroupMemberInfo.userId==userId];
        }else{
            GetGroupUserListRequest*request=[GetGroupUserListRequest request];
            request.groupId=groupId;
            if (userId) {
                request.ids=@[userId];
                request.parameters=[request mj_JSONObject];
                [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupMemberInfo class] success:^(NSArray<GroupMemberInfo*>* response) {
                    [self insertOrReplaceGroupMemberInfoWithArray:response];
                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                    
                }];
            }
            
        }
    }
    
}
@end
