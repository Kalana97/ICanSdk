#import "ChatModel.h"
#import "ChatModel+WCTTableCoding.h"
#import <WCDB/WCDB.h>

@implementation ChatModel
WCDB_IMPLEMENTATION(ChatModel)
WCDB_PRIMARY(ChatModel,messageID)
WCDB_SYNTHESIZE(ChatModel, message)
WCDB_SYNTHESIZE(ChatModel, isOutGoing)
WCDB_SYNTHESIZE(ChatModel, gamificationStatus)
WCDB_SYNTHESIZE_DEFAULT(ChatModel, isPin, NO)
WCDB_SYNTHESIZE_DEFAULT(ChatModel, pinAudiance, nil)
WCDB_SYNTHESIZE(ChatModel, messageTime)
WCDB_SYNTHESIZE(ChatModel, sendState)
WCDB_SYNTHESIZE(ChatModel, messageContent)
WCDB_SYNTHESIZE(ChatModel, messageType)
WCDB_SYNTHESIZE(ChatModel, messageID)
WCDB_SYNTHESIZE(ChatModel, hasRead)
WCDB_SYNTHESIZE(ChatModel, redId)
WCDB_SYNTHESIZE(ChatModel, platform)
WCDB_SYNTHESIZE(ChatModel, voiceHasRead)
WCDB_SYNTHESIZE(ChatModel, receiptStatus)
WCDB_SYNTHESIZE(ChatModel, showRedState)
WCDB_SYNTHESIZE(ChatModel, isShowOpenRedView)
WCDB_SYNTHESIZE(ChatModel, redPacketState)
WCDB_SYNTHESIZE(ChatModel, destoryTime)
WCDB_SYNTHESIZE(ChatModel, fileServiceUrl)
WCDB_SYNTHESIZE(ChatModel, translateMsg)
WCDB_SYNTHESIZE(ChatModel, translateStatus)
WCDB_SYNTHESIZE(ChatModel, redPacketAmount)
WCDB_SYNTHESIZE(ChatModel, videoAlbumUrl)
WCDB_SYNTHESIZE(ChatModel, localIdentifier)
WCDB_SYNTHESIZE(ChatModel, circleUserId)
WCDB_SYNTHESIZE(ChatModel, showFileName)
WCDB_SYNTHESIZE(ChatModel, fileCacheName)
WCDB_SYNTHESIZE(ChatModel, totalUnitCount)
WCDB_SYNTHESIZE(ChatModel, mediaSeconds)
WCDB_SYNTHESIZE(ChatModel, messageTo)
WCDB_SYNTHESIZE(ChatModel, messageFrom)
WCDB_SYNTHESIZE(ChatModel, chatType)
WCDB_SYNTHESIZE(ChatModel, chatID)
WCDB_SYNTHESIZE(ChatModel, isOrignal)
WCDB_SYNTHESIZE(ChatModel, isGif)
WCDB_SYNTHESIZE(ChatModel, extra)
WCDB_SYNTHESIZE(ChatModel, hasReadUserIdItems)
WCDB_SYNTHESIZE(ChatModel, showMessage)
WCDB_SYNTHESIZE(ChatModel, layoutWidth)
WCDB_SYNTHESIZE(ChatModel, layoutHeight)
WCDB_SYNTHESIZE(ChatModel, hasReadUserInfoItems)
WCDB_SYNTHESIZE(ChatModel, thumbnailImageurlofTextUrl)
WCDB_SYNTHESIZE(ChatModel, thumbnailTitleofTextUrl)
WCDB_SYNTHESIZE(ChatModel, c2cUserId)
WCDB_SYNTHESIZE(ChatModel, chatMode)
WCDB_SYNTHESIZE(ChatModel, c2cOrderId)
WCDB_SYNTHESIZE(ChatModel, c2cExtra)
WCDB_SYNTHESIZE_DEFAULT(ChatModel, exportState, 3)
WCDB_SYNTHESIZE_DEFAULT(ChatModel, downloadState, 3)
WCDB_SYNTHESIZE_DEFAULT(ChatModel, uploadState, 3)
WCDB_SYNTHESIZE(ChatModel, translateLanguage)
WCDB_SYNTHESIZE(ChatModel, translateLanguageCode)
WCDB_SYNTHESIZE(ChatModel, translateModeOnOff)
WCDB_SYNTHESIZE(ChatModel, isReacted)
WCDB_SYNTHESIZE(ChatModel, selfReaction)
WCDB_SYNTHESIZE(ChatModel, reactions)
WCDB_SYNTHESIZE(ChatModel, headerImgUrl)
WCDB_SYNTHESIZE(ChatModel, messageData)
WCDB_SYNTHESIZE(ChatModel, onclickFunction)
WCDB_SYNTHESIZE(ChatModel, onclickData)
WCDB_SYNTHESIZE(ChatModel, merchantId)
WCDB_SYNTHESIZE(ChatModel, sender)
WCDB_SYNTHESIZE(ChatModel, senderImgUrl)
WCDB_SYNTHESIZE(ChatModel, title)
WCDB_SYNTHESIZE(ChatModel, languageCode)
WCDB_SYNTHESIZE(ChatModel, dataList)
//设置一个默认值
WCDB_SYNTHESIZE_DEFAULT(ChatModel, authorityType, AuthorityType_friend)

- (NSString *)description {
    return [self mj_JSONString];
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    ChatModel *copy = [[[self class] allocWithZone:zone] init];
    copy.chatID = [self.chatID mutableCopy];
    copy.chatMode = [self.chatMode mutableCopy];
    copy.message = [self.message mutableCopy];
    copy.messageContent = [self.messageContent mutableCopy];
    copy.showMessage = [self.showMessage mutableCopy];
    copy.translateMsg = [self.translateMsg mutableCopy];
    copy.messageFrom = [self.messageFrom mutableCopy];
    copy.messageTo = [self.messageTo mutableCopy];
    copy.platform = [self.platform mutableCopy];
    copy.messageTime = [self.messageTime mutableCopy];
    copy.messageType = [self.messageType mutableCopy];
    copy.messageID = [self.messageID mutableCopy];
    copy.chatType = [self.chatType mutableCopy];
    copy.authorityType = [self.authorityType mutableCopy];
    copy.c2cUserId = [self.c2cUserId mutableCopy];
    copy.c2cOrderId = [self.c2cOrderId mutableCopy];
    copy.merchantId = [self.merchantId mutableCopy];
    return copy;
}
@end
