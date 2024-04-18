//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyInfo.mm
- Description:
- Function List:
*/
        

#import "GroupApplyInfo+WCTTableCoding.h"
#import "GroupApplyInfo.h"
#import <WCDB/WCDB.h>

@implementation GroupApplyInfo

WCDB_IMPLEMENTATION(GroupApplyInfo)
WCDB_SYNTHESIZE(GroupApplyInfo, addGroupMode)
WCDB_SYNTHESIZE(GroupApplyInfo, groupId)
WCDB_SYNTHESIZE(GroupApplyInfo, inviterId)
WCDB_SYNTHESIZE(GroupApplyInfo, userId)
WCDB_SYNTHESIZE(GroupApplyInfo, messageId)
WCDB_SYNTHESIZE(GroupApplyInfo,messageTime)

WCDB_SYNTHESIZE(GroupApplyInfo,joinType)
//唯一主键
WCDB_PRIMARY(GroupApplyInfo,messageId)

//设置一个默认值
WCDB_SYNTHESIZE_DEFAULT(GroupApplyInfo, isRead, NO)
WCDB_SYNTHESIZE_DEFAULT(GroupApplyInfo, isAgree, NO)

@end
