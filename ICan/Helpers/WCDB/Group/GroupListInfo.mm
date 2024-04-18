//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  GroupListInfo.mm
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "GroupListInfo+WCTTableCoding.h"
#import "GroupListInfo.h"
#import <WCDB/WCDB.h>

@implementation GroupListInfo

WCDB_IMPLEMENTATION(GroupListInfo)
WCDB_SYNTHESIZE(GroupListInfo, groupId)
WCDB_SYNTHESIZE(GroupListInfo, name)
WCDB_SYNTHESIZE(GroupListInfo, headImgUrl)
WCDB_SYNTHESIZE(GroupListInfo, announce)
WCDB_SYNTHESIZE(GroupListInfo, Description)
WCDB_SYNTHESIZE(GroupListInfo, groupQrcode)
WCDB_SYNTHESIZE(GroupListInfo, destructionTime)

WCDB_SYNTHESIZE(GroupListInfo, createTime)
WCDB_SYNTHESIZE(GroupListInfo, locked)
WCDB_SYNTHESIZE(GroupListInfo, deleted)
WCDB_SYNTHESIZE(GroupListInfo, channel)
WCDB_SYNTHESIZE(GroupListInfo, inviteType)
WCDB_SYNTHESIZE(GroupListInfo, userCount)
WCDB_SYNTHESIZE(GroupListInfo, isInGroup)
WCDB_SYNTHESIZE(GroupListInfo, groupRemark)
WCDB_SYNTHESIZE(GroupListInfo, messageNotDisturb)
WCDB_SYNTHESIZE(GroupListInfo, screenCaptureNotice)
WCDB_SYNTHESIZE(GroupListInfo, topChat)
WCDB_SYNTHESIZE(GroupListInfo, allShutUp)
WCDB_SYNTHESIZE(GroupListInfo, groupNumberId)

WCDB_SYNTHESIZE(GroupListInfo, maxMoney)
WCDB_SYNTHESIZE(GroupListInfo, showUserInfo)
WCDB_SYNTHESIZE(GroupListInfo, displaysGroupUserNicknames)

WCDB_SYNTHESIZE(GroupListInfo, role)
WCDB_SYNTHESIZE(GroupListInfo, businessType)
WCDB_SYNTHESIZE(GroupListInfo, joinGroupReview)
WCDB_SYNTHESIZE(GroupListInfo, mutedByAdmin)
//唯一主键
WCDB_PRIMARY(GroupListInfo,groupId)
-(NSString *)description{
    return [self mj_JSONString];
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}
  
@end
