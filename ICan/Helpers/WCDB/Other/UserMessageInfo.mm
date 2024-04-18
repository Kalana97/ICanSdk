//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 18/9/2019
- File name:  UserMessage.mm
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "UserMessageInfo+WCTTableCoding.h"
#import "UserMessageInfo.h"
#import <WCDB/WCDB.h>

@implementation UserMessageInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId":@"id"};
}
WCDB_IMPLEMENTATION(UserMessageInfo)
//由于用户数据和好友详情数据返回的信息不一样 所以不能用唯一ID来更新数据 必须要先查再把需要更新的字段写出来 不然会导致数据发生错乱
WCDB_PRIMARY(UserMessageInfo,userId)
WCDB_SYNTHESIZE(UserMessageInfo, userId)
WCDB_SYNTHESIZE(UserMessageInfo, nickname)
WCDB_SYNTHESIZE(UserMessageInfo, username)
WCDB_SYNTHESIZE(UserMessageInfo, remarkName)
WCDB_SYNTHESIZE(UserMessageInfo, gender)
WCDB_SYNTHESIZE(UserMessageInfo, mobile)
WCDB_SYNTHESIZE(UserMessageInfo, realName)
WCDB_SYNTHESIZE(UserMessageInfo, headImgUrl)
WCDB_SYNTHESIZE(UserMessageInfo, cardId)
WCDB_SYNTHESIZE(UserMessageInfo, token)
WCDB_SYNTHESIZE(UserMessageInfo, numberId)
WCDB_SYNTHESIZE(UserMessageInfo, isFriend)
WCDB_SYNTHESIZE(UserMessageInfo,signature)
WCDB_SYNTHESIZE(UserMessageInfo,cs)
WCDB_SYNTHESIZE(UserMessageInfo,beBlock)
WCDB_SYNTHESIZE(UserMessageInfo,block)
WCDB_SYNTHESIZE(UserMessageInfo,shieldTimeLine)
WCDB_SYNTHESIZE(UserMessageInfo,vip)
WCDB_SYNTHESIZE(UserMessageInfo,lastName)
WCDB_SYNTHESIZE(UserMessageInfo,firstName)
WCDB_SYNTHESIZE_DEFAULT(UserMessageInfo, userAuthStatus, @"NotAuth")
WCDB_SYNTHESIZE_DEFAULT(UserMessageInfo, readReceipt, YES)

WCDB_SYNTHESIZE(UserMessageInfo,thirdPartySystemAppId)
-(NSString *)description{
    return [self mj_JSONString];
}
@end
