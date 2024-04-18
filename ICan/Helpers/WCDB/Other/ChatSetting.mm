//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 18/9/2019
- File name:  ChatSetting.mm
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "ChatSetting+WCTTableCoding.h"
#import "ChatSetting.h"
#import <WCDB/WCDB.h>

@implementation ChatSetting
WCDB_IMPLEMENTATION(ChatSetting)
WCDB_SYNTHESIZE(ChatSetting, chatId)
WCDB_SYNTHESIZE(ChatSetting, isStick)
WCDB_SYNTHESIZE(ChatSetting, isNoDisturbing)
WCDB_SYNTHESIZE(ChatSetting, destoryTime)
WCDB_SYNTHESIZE(ChatSetting, isSaveInContact)
WCDB_SYNTHESIZE(ChatSetting, isSecret)
WCDB_SYNTHESIZE(ChatSetting, isShowNickName)
WCDB_SYNTHESIZE(ChatSetting, chatMode)
WCDB_SYNTHESIZE(ChatSetting, isOpenTaskScreenNotice)
WCDB_SYNTHESIZE(ChatSetting, isStrongNotice)
WCDB_SYNTHESIZE(ChatSetting, chatBackgroundImage)
WCDB_SYNTHESIZE(ChatSetting, towardsisOpenTaskScreenNotice)
WCDB_SYNTHESIZE(ChatSetting, chatType)
WCDB_SYNTHESIZE_DEFAULT(ChatSetting, authorityType, AuthorityType_friend) //设置一个默认值
WCDB_SYNTHESIZE(ChatSetting, showUserInfo)
WCDB_SYNTHESIZE(ChatSetting, allShutUp)
WCDB_SYNTHESIZE(ChatSetting, translateLanguage)
WCDB_SYNTHESIZE(ChatSetting, translateLanguageCode)
-(NSString *)description{
    return [self mj_JSONString];
}
@end
