//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- Modifier: Rohan Jayasekara on 2022-09-19
- File name:  GroupMemberInfo+WCTTableCoding.h
- Description:
- Function List:
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "GroupMemberInfo.h"
#import <WCDB/WCDB.h>

@interface GroupMemberInfo (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(headImgUrl)
WCDB_PROPERTY(groupRemark)
WCDB_PROPERTY(groupId)
WCDB_PROPERTY(userId)
WCDB_PROPERTY(gender)
WCDB_PROPERTY(numberId)
WCDB_PROPERTY(nickname)
WCDB_PROPERTY(username)
WCDB_PROPERTY(role)
WCDB_PROPERTY(invitedBy)
WCDB_PROPERTY(mutedByAdmin)
WCDB_PROPERTY(vip)
WCDB_PROPERTY(vipMoney)


@end
