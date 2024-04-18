//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 17/9/2019
- File name:  ChatModel+WCTTableCoding.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "ChatModel.h"
#import <WCDB/WCDB.h>

@interface ChatModel (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(body)
WCDB_PROPERTY(isOutGoing)
WCDB_PROPERTY(messageTime)
WCDB_PROPERTY(sendState)
WCDB_PROPERTY(messageContent)
WCDB_PROPERTY(messageType)
WCDB_PROPERTY(gamificationStatus)
WCDB_PROPERTY(isPin)
WCDB_PROPERTY(pinAudiance)
WCDB_PROPERTY(uploadState)
WCDB_PROPERTY(messageID)
WCDB_PROPERTY(hasRead)
WCDB_PROPERTY(chatMode)
WCDB_PROPERTY(voiceHasRead)
WCDB_PROPERTY(receiptStatus)
WCDB_PROPERTY(showRedState)
WCDB_PROPERTY(isShowOpenRedView)
WCDB_PROPERTY(redPacketState)
WCDB_PROPERTY(destoryTime)
WCDB_PROPERTY(showFileName)
WCDB_PROPERTY(fileCacheName)
WCDB_PROPERTY(fileServiceUrl)
WCDB_PROPERTY(translateMsg)
WCDB_PROPERTY(translateStatus)
WCDB_PROPERTY(redId)
WCDB_PROPERTY(totalUnitCount)
WCDB_PROPERTY(downloadState)
WCDB_PROPERTY(mediaSeconds)
WCDB_PROPERTY(videoFirstFrameUrl)
WCDB_PROPERTY(messageTo)
WCDB_PROPERTY(messageFrom)
WCDB_PROPERTY(chatType)
WCDB_PROPERTY(chatID)
WCDB_PROPERTY(isOrignal)
WCDB_PROPERTY(isGif)
WCDB_PROPERTY(message)
WCDB_PROPERTY(showMessage)
WCDB_PROPERTY(redPacketAmount)
WCDB_PROPERTY(extra)
WCDB_PROPERTY(layoutWidth)
WCDB_PROPERTY(layoutHeight)
WCDB_PROPERTY(hasReadUserIdItems)
WCDB_PROPERTY(platform)
WCDB_PROPERTY(hasReadUserInfoItems)
WCDB_PROPERTY(videoAlbumUrl)
WCDB_PROPERTY(localIdentifier)
WCDB_PROPERTY(authorityType)
WCDB_PROPERTY(circleUserId)
WCDB_PROPERTY(exportState)
WCDB_PROPERTY(c2cUserId)
WCDB_PROPERTY(c2cOrderId)
WCDB_PROPERTY(c2cExtra)
WCDB_PROPERTY(thumbnailImageurlofTextUrl)
WCDB_PROPERTY(thumbnailTitleofTextUrl)
WCDB_PROPERTY(translateLanguage)
WCDB_PROPERTY(translateLanguageCode)
WCDB_PROPERTY(translateModeOnOff)
WCDB_PROPERTY(isReacted)
WCDB_PROPERTY(selfReaction)
WCDB_PROPERTY(reactions)
WCDB_PROPERTY(merchantId)
@end
