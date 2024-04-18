//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/9/11
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  WCDBManager.m
 - Description:
 - Function List:
 - History:
 */


#import "WCDBManager.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import "CircleUserInfo.h"
#import "GroupApplyInfo.h"
#import "ChatListModel.h"
#import "FriendSubscriptionInfo.h"
#import "UserMessageInfo.h"
#import "ChatSetting.h"
#import "TimeLineNoticeInfo.h"
#import "TimelinesCommentInfo.h"
@interface WCDBManager()


@end
@implementation WCDBManager
+ (instancetype)sharedManager {
    static WCDBManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[WCDBManager alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:api selector:@selector(applicationWillTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];
    });
    return api;
}
//程序将被杀死的时候会触发
-(void)applicationWillTerminateNotification{
    [self updateSendingMessageSendStateToFail];
}
-(void)initCurrentUserWCDataBase{
    self.wctDatabase=[[WCTDatabase alloc ]initWithPath:MessageCacheWCDB];
    DDLogInfo(@"MessageCacheWCDBPath=%@",MessageCacheWCDB);
    [self.wctDatabase createTableAndIndexesOfName:KWCGroupApplyInfoTable withClass:[GroupApplyInfo class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCChatListModelTable withClass:[ChatListModel class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCChatModelTable withClass:[ChatModel class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCGroupListInfoTable withClass:[GroupListInfo class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCGroupMemberInfoTable withClass:[GroupMemberInfo  class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCFriendSubscriptionInfoTable withClass:[FriendSubscriptionInfo  class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCUserMessageInfoTable withClass:[UserMessageInfo  class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCChatSettingTable withClass:[ChatSetting  class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCTimeLineNoticeInfoTable withClass:[TimeLineNoticeInfo  class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCCircleUserInfoTable withClass:[CircleUserInfo  class]];
    [self.wctDatabase createTableAndIndexesOfName:KWCTimelinesCommentInfoTable withClass:[TimelinesCommentInfo  class]];
}


-(NSString*)generateMessageID{
    NSInteger nowTime=[[NSDate date]timeIntervalSince1970]*1000000;
    NSString * messageid=[NSString stringWithFormat:@"%ld%@",(long)nowTime,[UserInfoManager sharedManager].userId];
    return messageid;
}
-(void)deleteResourceWihtChatId:(NSString *)chatId{
    [DZFileManager removeFileOfPath:MeesageChatIDCache(chatId)];
}
-(void)deleteAllResource{
    [self.wctDatabase deleteAllObjectsFromTable:KWCChatModelTable];
    [self.wctDatabase deleteAllObjectsFromTable:KWCChatListModelTable];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    [DZFileManager removeFileOfPath:MessageCache];
}
-(void)cacheMessageWithChatModel:(ChatModel *)chatModel isNeedSend:(BOOL)isNeedSend{
    if (isNeedSend) {
        [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
    }
    [self calculateChatModelWidthAndHeightWithChatModel:chatModel];
    [self insertChatModel:chatModel];
    [self saveChatListModelWithChatModel:chatModel];
}
@end
