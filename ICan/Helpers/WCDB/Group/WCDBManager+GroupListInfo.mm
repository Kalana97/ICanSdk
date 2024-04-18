//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 25/9/2019
 - File name:  WCDBManager+GroupListInfo.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "WCDBManager+GroupListInfo.h"
#import "GroupListInfo+WCTTableCoding.h"

@implementation WCDBManager (GroupListInfo)
-(void)deleteGroupListInfoWithGroupId:(NSString *)groupId{
   [self.wctDatabase deleteObjectsFromTable:KWCGroupListInfoTable where:GroupListInfo.groupId==groupId];

}
-(void)insertOrUpdateGroupListInfoWithArray:(NSArray<GroupListInfo*>*)array{
    [self.wctDatabase insertOrReplaceObjects:array into:KWCGroupListInfoTable];
}
-(GroupListInfo *)fetchOneGroupListInfoWithGroupId:(NSString *)groupId{
    return  [self.wctDatabase getOneObjectOfClass:[GroupListInfo class] fromTable:KWCGroupListInfoTable where:GroupListInfo.groupId==groupId];
}
-(NSArray *)getAllGroupListInfo{
   return  [self.wctDatabase getAllObjectsOfClass:[GroupListInfo class] fromTable:KWCGroupListInfoTable];
}
-(void)fetchOneGroupListInfoWithGroupId:(NSString *)groupId successBlock:(nonnull void (^)(GroupListInfo * _Nonnull))successBlock{
   GroupListInfo*info= [self.wctDatabase getOneObjectOfClass:[GroupListInfo class] fromTable:KWCGroupListInfoTable where:GroupListInfo.groupId==groupId];
    if (info) {
        successBlock(info);
    }else{
        [self fetchGroupWithGroupId:groupId successBlock:successBlock];
    }
}
-(void)fetchGroupWithGroupId:(NSString *)groupId successBlock:(nonnull void (^)(GroupListInfo * _Nonnull))successBlock{
    if (groupId) {
        GetGroupDetailRequest*request=[GetGroupDetailRequest request];
        request.pathUrlString = [NSString stringWithFormat:@"%@/group/%@",request.baseUrlString,groupId];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[GroupListInfo class] contentClass:[GroupListInfo class] success:^(GroupListInfo * response) {
            [self insertOrUpdateGroupListInfoWithArray:@[response]];
            successBlock(response);
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
        
    }
    
}
-(void)updateGroupNameWithGroupId:(NSString *)groupId groupName:(nonnull NSString *)grouName{
    if (grouName) {
        [self.wctDatabase updateRowsInTable:KWCGroupListInfoTable onProperty:{GroupListInfo.name} withValue:grouName where:GroupListInfo.groupId==groupId];
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateGroupMessageNotification object:nil userInfo:nil];
    }
    
}
-(void)updateGroupShowUserInfoGroupId:(NSString *)groupId  showUserInfo:(BOOL)showUserInfo{
    [self.wctDatabase updateRowsInTable:KWCGroupListInfoTable onProperty:{GroupListInfo.showUserInfo} withValue:@(showUserInfo) where:GroupListInfo.groupId==groupId];
}
-(void)deleteAllGroupList{
  BOOL succe=  [self.wctDatabase deleteAllObjectsFromTable:KWCGroupListInfoTable];
    NSLog(@"succe=%d",succe);
}
@end
