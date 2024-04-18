//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 18/9/2019
- File name:  ChatSetting+WCTTableCoding.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "ChatSetting.h"
#import <WCDB/WCDB.h>

@interface ChatSetting (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(chatId)
WCDB_PROPERTY(isStick)
WCDB_PROPERTY(isNoDisturbing)
WCDB_PROPERTY(destoryTime)
WCDB_PROPERTY(isSaveInContact)
WCDB_PROPERTY(isSecret)
WCDB_PROPERTY(isShowNickName)
WCDB_PROPERTY(isOpenTaskScreenNotice)
WCDB_PROPERTY(isStrongNotice)
WCDB_PROPERTY(chatBackgroundImage)
WCDB_PROPERTY(towardsisOpenTaskScreenNotice)
WCDB_PROPERTY(chatType)
WCDB_PROPERTY(showUserInfo)
WCDB_PROPERTY(allShutUp)
WCDB_PROPERTY(authorityType)
WCDB_PROPERTY(translateLanguage)
WCDB_PROPERTY(translateLanguageCode)
@end
