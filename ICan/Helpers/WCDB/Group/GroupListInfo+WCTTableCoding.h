//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  GroupListInfo+WCTTableCoding.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "GroupListInfo.h"
#import <WCDB/WCDB.h>

@interface GroupListInfo (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(groupId)
WCDB_PROPERTY(name)
WCDB_PROPERTY(headImgUrl)
WCDB_PROPERTY(announce)
WCDB_PROPERTY(Description)
WCDB_PROPERTY(groupQrcode)
WCDB_PROPERTY(destructionTime)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(locked)
WCDB_PROPERTY(deleted)
WCDB_PROPERTY(channel)
WCDB_PROPERTY(inviteType)
WCDB_PROPERTY(userCount)
WCDB_PROPERTY(isInGroup)
WCDB_PROPERTY(messageNotDisturb)
WCDB_PROPERTY(screenCaptureNotice)
WCDB_PROPERTY(topChat)
WCDB_PROPERTY(allShutUp)
WCDB_PROPERTY(showUserInfo)
WCDB_PROPERTY(displaysGroupUserNicknames)
WCDB_PROPERTY(role)
WCDB_PROPERTY(groupRemark)
WCDB_PROPERTY(maxMoney)
WCDB_PROPERTY(groupNumberId)
WCDB_PROPERTY(businessType)
WCDB_PROPERTY(joinGroupReview)
WCDB_PROPERTY(mutedByAdmin)
@end
