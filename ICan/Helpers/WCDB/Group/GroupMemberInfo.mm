//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- Modifier: Rohan Jayasekara on 2022-09-19
- File name:  GroupMemberInfo.mm
- Description:
- Function List:
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "GroupMemberInfo+WCTTableCoding.h"
#import "GroupMemberInfo.h"
#import <WCDB/WCDB.h>

@implementation GroupMemberInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId":@"id"};
}

WCDB_IMPLEMENTATION(GroupMemberInfo)
WCDB_SYNTHESIZE(GroupMemberInfo, userId)
WCDB_SYNTHESIZE(GroupMemberInfo, gender)
WCDB_SYNTHESIZE(GroupMemberInfo, numberId)
WCDB_SYNTHESIZE(GroupMemberInfo, nickname)
WCDB_SYNTHESIZE(GroupMemberInfo, username)
WCDB_SYNTHESIZE(GroupMemberInfo, headImgUrl)
WCDB_SYNTHESIZE(GroupMemberInfo, groupRemark)
WCDB_SYNTHESIZE(GroupMemberInfo, groupId)
WCDB_SYNTHESIZE(GroupMemberInfo, role)
WCDB_SYNTHESIZE(GroupMemberInfo, joinType)
WCDB_SYNTHESIZE(GroupMemberInfo, vip)
WCDB_SYNTHESIZE(GroupMemberInfo, vipMoney)

WCDB_SYNTHESIZE(GroupMemberInfo, invitedBy)
WCDB_SYNTHESIZE(GroupMemberInfo, mutedByAdmin)
WCDB_MULTI_UNIQUE(GroupMemberInfo, "_oxfff", userId)
WCDB_MULTI_UNIQUE(GroupMemberInfo, "_oxfff", groupId)

-(NSString *)description{
    return [self mj_JSONString];
}

@end

