//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/9/16
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  WCDBManager+ChatList.m
 - Description:
 - Function List:
 - History:
 */
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatSetting.h"
#import "WCDBManager+ChatModel.h"
#import "ChatModel+WCTTableCoding.h"
#import "ChatListModel+WCTTableCoding.h"
#import "ChatSetting.h"
@implementation WCDBManager (ChatList)
-(ChatListModel*)creatChatListModel:(ChatModel *)chatModel{
    NSString*messageContent;
    NSString* messageType=chatModel.messageType;
    if ([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:AIMessageType]||[messageType isEqualToString:AIMessageQuestionType]||[messageType isEqualToString:AtAllMessageType]||[messageType isEqualToString:AtSingleMessageType]) {
        messageContent = chatModel.showMessage;
    } else if ([messageType isEqualToString:GamifyMessageType]){
        messageContent = @"GameTips".icanlocalized;
    } else if([messageType isEqualToString:URLMessageType]){
        messageContent = [NSString stringWithFormat:@"[%@]",@"showReceiveUrlTip".icanlocalized];
    } else if ([messageType isEqualToString:ImageMessageType]){
        messageContent = @"ImageTips".icanlocalized;
    } else if ([messageType isEqualToString:VoiceMessageType]) {
        messageContent = @"VoiceTips".icanlocalized;
    } else if ([messageType isEqualToString:VideoMessageType]) {
        messageContent = @"VideoTips".icanlocalized;
    } else if ([messageType isEqualToString:FileMessageType]){
        messageContent = [NSString stringWithFormat:@"%@ %@",@"FileTips".icanlocalized,chatModel.showFileName];
    }else if ([messageType isEqualToString:LocationMessageType]){
        messageContent = @"LocationTips".icanlocalized;
    }
    else if ([messageType isEqualToString:TransFerMessageType]) {
        messageContent = [NSString stringWithFormat:@"%@ %@",@"TransferTips".icanlocalized,chatModel.showMessage];
    } else if ([messageType isEqualToString:UserCardMessageType]) {
        messageContent = @"ContactCardTips".icanlocalized;
    }else if ([messageType isEqualToString:SendSingleRedPacketType]) {
        messageContent = [NSString stringWithFormat:@"[%@]%@",@"chatView.function.redPacket".icanlocalized,chatModel.showMessage];
    }else if ([messageType isEqualToString:SendRoomRedPacketType]){
        messageContent = [NSString stringWithFormat:@"[%@]%@",@"chatView.function.redPacket".icanlocalized,chatModel.showMessage];
    }else if ([messageType isEqualToString:kChatOtherShareType]){
        messageContent = [NSString stringWithFormat:@"%@",@"Commodity sharing".icanlocalized];
    }else if ([messageType isEqualToString:kChat_PostShare]){
        messageContent = [NSString stringWithFormat:@"%@",@"ChatViewController.replyText".icanlocalized];
    }else if ([chatModel.chatType isEqualToString:C2CHelperMessageType]){
        messageContent = chatModel.messageContent;
    }
    else if ([messageType isEqualToString:Notice_QuitGroupMessageType]||[messageType isEqualToString:Notice_AddGroupMessageType]
             ||[messageType isEqualToString:Notice_SubjectMessageType]||[messageType isEqualToString:Notice_DeleteFriendMessageType]
             ||[messageType isEqualToString:Notice_AddFriendMessageType]||[messageType isEqualToString:Notice_DestroyTimeType]
             ||[messageType isEqualToString:Notice_ScreencastType]||[messageType isEqualToString:GrabRoomRedPacketTypeType]
             ||[messageType isEqualToString:GrabSingleRedPacketType]||[messageType isEqualToString:Notice_RemoveChatType]||[messageType isEqualToString:Add_friend_successType]||[messageType isEqualToString:Notice_TransferGroupOwnerType]||[messageType isEqualToString:Notice_GroupRoleUpdateType]||[messageType isEqualToString:kNotice_JoinGroupReviewUpdate]||[messageType isEqualToString:Notice_JoinGroupApplyType]){
        messageContent = chatModel.showMessage;
    }else if ([messageType containsString:WithdrawMessageType]){
        //如果是自子发送的撤回消息 那么直接显示为  你撤回了一条消息
        //如果是收到别人撤回了一条消息 的消息类型 那么 需要显示成 ”xxx“撤回了一条消息
        if (chatModel.isOutGoing) {
            messageContent = NSLocalizedString(@"YouHaveWithdrawnAMessage",你撤回了一条消息);
        }else{
            messageContent = chatModel.showMessage;
        }
    }else if ([messageType isEqualToString:ChatCallMessageType]){
        messageContent = chatModel.showMessage;
    }else if ([messageType isEqualToString:PayHelperMessageType]||[messageType isEqualToString:SystemHelperMessageType]){
        messageContent=chatModel.messageContent;
    }else if([messageType isEqualToString:AnnouncementHelperMessageType]){
        messageContent=chatModel.messageContent;
    }else if ([messageType isEqualToString:ShopHelperMessageType]){
        messageContent=chatModel.messageContent;
    }
    ChatListModel *chatListModel = [[ChatListModel alloc]init];
    if([chatModel.messageType isEqual:DynamicMessageType]){
        chatListModel.chatID = chatModel.merchantId;
    }else {
        chatListModel.chatID = chatModel.chatID;
    }
    chatListModel.chatType = chatModel.chatType;
    chatListModel.messageType = chatModel.messageType;
    chatListModel.chatMode = chatModel.chatMode;
    chatListModel.isOutGoing = chatModel.isOutGoing;
    chatListModel.messageTo = chatModel.messageTo;
    chatListModel.messageFrom = chatModel.messageFrom?:chatModel.messageType;
    chatListModel.lastMessageTime = chatModel. messageTime;
    chatListModel.messageContent= messageContent;
    chatListModel.authorityType = chatModel.authorityType;
    chatListModel.circleUserId= chatModel.circleUserId;
    chatListModel.c2cOrderId = chatModel.c2cOrderId;
    chatListModel.c2cUserId = chatModel.c2cUserId;
    if ([messageType isEqualToString:AtSingleMessageType]) {
        AtSingleMessageInfo*info=[AtSingleMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
        if ([info.atIds containsObject:[UserInfoManager sharedManager].userId]) {
            chatListModel.isShowAt=YES;
        }
    }else if ([messageType isEqualToString:AtAllMessageType]){
        chatListModel.isShowAt=YES;
    }
    return chatListModel;
}
-(ChatModel*)insertC2CHelperMessageWithChatModel:(ChatModel*)chatModel{
    chatModel.chatID = C2CHelperMessageType;
    chatModel.chatType = C2CHelperMessageType;
    chatModel.authorityType = AuthorityType_friend;
    if ([chatModel.messageType isEqualToString:C2COrderMessageType]) {
        chatModel.messageID = [self generateMessageID];
    }else{
        chatModel.messageID = chatModel.messageID;
    }
    [self insertChatModel:chatModel];
    ChatListModel* model = [self creatChatListModel:chatModel];
    model.chatType = C2CHelperMessageType;
    model.chatID = C2CHelperMessageType;
    model.authorityType = AuthorityType_friend;
    model.messageType = chatModel.messageType;
    ChatListModel*existModel=[self.wctDatabase getOneObjectOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.chatID==model.chatID&&ChatListModel.chatType==model.chatType&&ChatListModel.authorityType==model.authorityType}];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = model.chatID;
    config.chatType = model.chatType;
    ChatSetting*setting=[[WCDBManager sharedManager]fetchChatSettingWith:config];
    if (!existModel) {
        model.isNoDisturbing=setting.isNoDisturbing;
        model.isStick=setting.isStick;
        model.unReadMessageCount=1;
        model.messageContent = chatModel.messageContent;
        [self.wctDatabase insertObject:model into:KWCChatListModelTable];
    }else{
        if ([WebSocketManager.sharedManager.currentChatID isEqualToString:model.chatID]) {
            UIApplicationState state=[UIApplication sharedApplication].applicationState;
            if (state==UIApplicationStateBackground) {
                model.unReadMessageCount=(existModel.unReadMessageCount+1);
            }else{
                model.unReadMessageCount=0;;
            }
        }else{
            model.unReadMessageCount=(existModel.unReadMessageCount+1);
        }
        model.messageContent = chatModel.messageContent;
        model.isStick=setting.isStick;
        if (model.messageContent) {
            
            [self.wctDatabase updateRowsInTable:KWCChatListModelTable
                                   onProperties:{ChatListModel.messageContent,ChatListModel.unReadMessageCount,
                ChatListModel.lastMessageTime,ChatListModel.isShowAt,
                ChatListModel.messageType,ChatListModel.messageFrom,
                ChatListModel.chatType,ChatListModel.isStick} withObject:model where:ChatListModel.chatID==model.chatID&&ChatListModel.chatType==model.chatType&&ChatListModel.authorityType==model.authorityType];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    return chatModel;
}

- (ChatModel*)insertNoticeOTPMessageWithChatModel:(ChatModel*)chatModel {
    chatModel.chatID = NoticeOTPMessageType;
    chatModel.chatType = NoticeOTPMessageType;
    chatModel.authorityType = AuthorityType_friend;
    chatModel.messageID = chatModel.messageID;
    [self insertChatModel:chatModel];
    ChatListModel *model = [self creatChatListModel:chatModel];
    model.chatType = NoticeOTPMessageType;
    model.chatID = NoticeOTPMessageType;
    model.authorityType = AuthorityType_friend;
    model.messageType = chatModel.messageType;
    ChatListModel *existModel = [self.wctDatabase getOneObjectOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.chatID == model.chatID && ChatListModel.chatType == model.chatType && ChatListModel.authorityType == model.authorityType}];
    ChatModel *config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = model.chatID;
    config.chatType = model.chatType;
    ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
    if(!existModel) {
        model.isNoDisturbing = setting.isNoDisturbing;
        model.isStick = setting.isStick;
        model.unReadMessageCount = 1;
        model.messageContent = chatModel.messageContent;
        [self.wctDatabase insertObject:model into:KWCChatListModelTable];
    }else {
        if([WebSocketManager.sharedManager.currentChatID isEqualToString:model.chatID]) {
            UIApplicationState state = [UIApplication sharedApplication].applicationState;
            if(state == UIApplicationStateBackground) {
                model.unReadMessageCount = (existModel.unReadMessageCount + 1);
            }else{
                model.unReadMessageCount = 0;
            }
        }else{
            model.unReadMessageCount=(existModel.unReadMessageCount + 1);
        }
        model.messageContent = chatModel.messageContent;
        model.isStick = setting.isStick;
        if (model.messageContent) {
            [self.wctDatabase updateRowsInTable:KWCChatListModelTable
                                   onProperties:{ChatListModel.messageContent,ChatListModel.unReadMessageCount,
                ChatListModel.lastMessageTime,ChatListModel.isShowAt,
                ChatListModel.messageType,ChatListModel.messageFrom,
                ChatListModel.chatType,ChatListModel.isStick} withObject:model where:ChatListModel.chatID == model.chatID && ChatListModel.chatType == model.chatType && ChatListModel.authorityType == model.authorityType];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    return chatModel;
}

-(void)saveChatListModelWithChatModel:(ChatModel *)chatModel{
    ChatListModel* chatListModel = [self creatChatListModel:chatModel];
    [self insertOrUpdateChatListWithChatListModel:chatListModel];
}
-(void)insertOrUpdateChatListWithChatListModel:(ChatListModel*)model {
    BOOL shouldAdd =  [self chatListModelShuoldAddUnReadMessageCount:model];
    ChatListModel*existModel;
    NSString* chatId = model.chatID;
    WCTCondition condtion;
    WCTPropertyList  propertyList;
    if ([model.authorityType isEqualToString:AuthorityType_c2c]) {
        existModel=[self.wctDatabase getOneObjectOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.chatType==UserChat&&ChatListModel.authorityType==AuthorityType_c2c&&ChatListModel.c2cOrderId==model.c2cOrderId}];
        chatId = model.c2cOrderId;
        condtion = ChatListModel.chatID==model.chatID&&ChatListModel.chatType==model.chatType&&ChatListModel.authorityType==model.authorityType&&ChatListModel.c2cOrderId==model.c2cOrderId&&ChatListModel.c2cUserId==model.c2cUserId;
        propertyList=  {ChatListModel.messageContent,ChatListModel.unReadMessageCount,ChatListModel.lastMessageTime,ChatListModel.messageType,ChatListModel.messageFrom,
            ChatListModel.isOutGoing,ChatListModel.chatType};
    }else if ([model.authorityType isEqualToString:AuthorityType_circle]) {
        existModel=[self.wctDatabase getOneObjectOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.chatID==model.chatID&&ChatListModel.chatType==model.chatType&&ChatListModel.authorityType==AuthorityType_circle&&ChatListModel.circleUserId==model.circleUserId}];
        condtion =ChatListModel.chatID==model.chatID&&ChatListModel.chatType==model.chatType&&ChatListModel.authorityType==model.authorityType&&ChatListModel.circleUserId==model.circleUserId;
        propertyList = {ChatListModel.messageContent,ChatListModel.unReadMessageCount,
            ChatListModel.lastMessageTime,
            ChatListModel.messageType,ChatListModel.messageFrom,
            ChatListModel.isOutGoing,ChatListModel.chatType};
    }else{
        existModel=[self.wctDatabase getOneObjectOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.chatID==model.chatID&&ChatListModel.chatType==model.chatType&&ChatListModel.authorityType==model.authorityType}];
        condtion =  ChatListModel.chatID==model.chatID&&ChatListModel.chatType==model.chatType&&ChatListModel.authorityType==model.authorityType;
        propertyList ={ChatListModel.messageContent,ChatListModel.unReadMessageCount,
            ChatListModel.lastMessageTime,ChatListModel.isShowAt,
            ChatListModel.messageType,ChatListModel.messageFrom,
            ChatListModel.isOutGoing,ChatListModel.chatType,ChatListModel.chatMode};
        if (!model.isShowAt) {
            model.isShowAt = existModel.isShowAt;
        }
    }
    if (!existModel) {
        if (shouldAdd) {
            model.unReadMessageCount = 1;
        }
        [self.wctDatabase insertObject:model into:KWCChatListModelTable];
    }else{
        if (shouldAdd) {
            if ([[WebSocketManager sharedManager].currentChatID isEqualToString:chatId]) {
                UIApplicationState state=[UIApplication sharedApplication].applicationState;
                if (state==UIApplicationStateBackground) {
                    model.unReadMessageCount=(existModel.unReadMessageCount+1);
                }else{
                    model.unReadMessageCount=0;;
                }
            }else{
                model.unReadMessageCount=(existModel.unReadMessageCount+1);
            }
        }else {
            model.unReadMessageCount=(existModel.unReadMessageCount);
        }
        if (model.messageContent) {
            [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperties:propertyList withObject:model where:condtion];
        }
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    if([model.authorityType isEqualToString:AuthorityType_c2c]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kC2COrderNotification object:nil];
    }
}


-(void)deleteChatListModelWithAuthorityType:(NSString*)authorityType{
    [self.wctDatabase deleteObjectsFromTable:KWCChatListModelTable where:ChatListModel.authorityType==authorityType];
}
-(void)deleteOneChatListWithChatModel:(ChatModel*)config{
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        [self.wctDatabase deleteObjectsFromTable:KWCChatListModelTable where:{ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType&&ChatListModel.circleUserId==config.circleUserId}];
    }else{
        [self.wctDatabase deleteObjectsFromTable:KWCChatListModelTable where:{ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType}];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
}
-(void)resetChatListModelUnReadMessageCountWithChatModel:(ChatModel*)config{
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:ChatListModel.unReadMessageCount withValue:@(0) where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==AuthorityType_circle&&ChatListModel.circleUserId==config.circleUserId];
    }else if ([config.authorityType isEqualToString:AuthorityType_c2c]){
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:ChatListModel.unReadMessageCount withValue:@(0) where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==AuthorityType_c2c&&ChatListModel.c2cUserId==config.c2cUserId&&ChatListModel.c2cOrderId==config.c2cOrderId];
    }else{
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:ChatListModel.unReadMessageCount withValue:@(0) where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
}


-(void)updateShowLastModelWithConfig:(ChatModel*)config{
    ChatModel*chatModel;
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        chatModel =  [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType&&ChatModel.circleUserId==config.circleUserId} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
    }else{
        chatModel = [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
    }
    if (chatModel) {///
        ChatListModel *chatListModel = [self creatChatListModel:chatModel];
        if ([chatModel.authorityType isEqualToString:AuthorityType_c2c]) {
            if (chatModel.messageContent) {
                [self.wctDatabase updateRowsInTable:KWCChatListModelTable
                                       onProperties:{ChatListModel.messageContent,
                    ChatListModel.lastMessageTime,
                    ChatListModel.messageType,ChatListModel.messageFrom,
                    ChatListModel.isOutGoing} withObject:chatListModel where:ChatListModel.chatID==chatModel.chatID&&ChatListModel.chatType==chatModel.chatType&&ChatListModel.authorityType==chatModel.authorityType&&ChatListModel.c2cOrderId==chatModel.c2cOrderId&&ChatListModel.c2cUserId==chatModel.c2cUserId];
            }
        }else if ([chatModel.authorityType isEqualToString:AuthorityType_circle]) {
            if (chatModel.messageContent) {
                [self.wctDatabase updateRowsInTable:KWCChatListModelTable
                                       onProperties:{ChatListModel.messageContent,
                    ChatListModel.lastMessageTime,
                    ChatListModel.messageType,ChatListModel.messageFrom,
                    ChatListModel.isOutGoing} withObject:chatListModel where:ChatListModel.chatID==chatListModel.chatID&&ChatListModel.chatType==chatListModel.chatType&&ChatListModel.authorityType==chatListModel.authorityType&&ChatListModel.circleUserId==chatListModel.circleUserId];
            }
        }else{
            if (chatModel.messageContent) {
                [self.wctDatabase updateRowsInTable:KWCChatListModelTable
                                       onProperties:{ChatListModel.messageContent,
                    ChatListModel.lastMessageTime,
                    ChatListModel.messageType,ChatListModel.messageFrom,
                    ChatListModel.isOutGoing} withObject:chatListModel where:ChatListModel.chatID==chatModel.chatID&&ChatListModel.chatType==chatModel.chatType&&ChatListModel.authorityType==chatModel.authorityType];
            }
        }
    }else{
        [self saveChatListModelShowMessageWithText:@"" chatModel:config postNotification:NO];
    }
}
/**
 更新最后一条消息提示
 */
-(void)updateChatListModelLastMessageWithChatModel:(ChatModel*)config {
    ChatModel*model;
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        model =  [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType&&ChatModel.circleUserId==config.circleUserId} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
    }else{
        model = [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
    }
    if (model) {
        [self saveChatListModelWithChatModel:model];
    }else{
        [self saveChatListModelShowMessageWithText:@"" chatModel:config postNotification:YES];
    }
}

-(void)saveChatListModelShowMessageWithText:(NSString *)content chatModel:(ChatModel*)config postNotification:(BOOL)postNotification{
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:{ChatListModel.messageContent} withValue:content where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType&&ChatListModel.circleUserId==config.circleUserId];
    }else{
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:{ChatListModel.messageContent} withValue:content where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType];
    }
    if (postNotification) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    }
    
}
-(void)saveDraftMessage:(NSString*)draftText chatModel:(ChatModel*)config{
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperties:{ChatListModel.draftMessage,ChatListModel.lastMessageTime} withRow:@[draftText,@([[NSDate date]timeIntervalSince1970]*1000)] where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType&&ChatListModel.circleUserId==config.circleUserId];
    }else{
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperties:{ChatListModel.draftMessage,ChatListModel.lastMessageTime} withRow:@[draftText,@([[NSDate date]timeIntervalSince1970]*1000)] where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
}


/**
 判断适合的消息类型，未读消息数量才变化
 */
-(BOOL)chatListModelShuoldAddUnReadMessageCount:(ChatListModel*)model{
    NSString*messageType=model.messageType;
    if (!model.isOutGoing&&([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:VoiceMessageType]||[messageType isEqualToString:GamifyMessageType]||[messageType isEqualToString:URLMessageType]||[messageType isEqualToString:ImageMessageType]||[messageType isEqualToString:LocationMessageType]||[messageType isEqualToString:UserCardMessageType]||[messageType isEqualToString:AtAllMessageType]||[messageType isEqualToString:VoiceMessageType]||[messageType isEqualToString:VideoMessageType]||[messageType isEqualToString:FileMessageType]||[messageType isEqualToString:ChatCallMessageType]||[messageType isEqualToString:TransFerMessageType]||[messageType isEqualToString:SendSingleRedPacketType]||[messageType isEqualToString:SendRoomRedPacketType]||[messageType isEqualToString:kChatOtherShareType]||[messageType isEqualToString:kChat_PostShare]||[messageType isEqualToString:PayHelperMessageType]||[messageType isEqualToString:ShopHelperMessageType]||[messageType isEqualToString:SystemHelperMessageType]||[messageType isEqualToString:C2COrderMessageType]||[messageType isEqualToString:AtSingleMessageType]||[messageType isEqualToString:AnnouncementHelperMessageType])) {
        return YES;
    }
    
    return NO;
}
-(void)updateIsStick:(BOOL)isStick chatId:(NSString *)chatId chatType:(nonnull NSString *)chatType{
    [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:{ChatListModel.isStick} withValue:@(isStick) where:ChatListModel.chatID==chatId&&ChatListModel.chatType==chatType];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    
}
-(void)updateIsNoDisturbing:(BOOL)isNoDisturbing chatId:(NSString *)chatId chatType:(nonnull NSString *)chatType{
    [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:{ChatListModel.isNoDisturbing} withValue:@(isNoDisturbing) where:ChatListModel.chatID==chatId&&ChatListModel.chatType==chatType];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
}
-(void)updateShowName:(NSString *)showName chatId:(NSString *)chatId chatType:(NSString*)chatType{
    if (showName) {
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:ChatListModel.showName withValue:showName where:ChatListModel.chatID==chatId&&ChatListModel.chatType==chatType];
    }
    
    
}

-(void)updateNoShowAt:(ChatModel *)config{
    if ([config.authorityType isEqualToString:AuthorityType_friend]){
        [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:ChatListModel.isShowAt withValue:@(0) where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType];
        [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
    }
}

-(void)updateGroupAllShutUp:(NSString*)chatId allShutUp:(BOOL)allShutUp{
    [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:{ChatListModel.allShutUp} withValue:@(allShutUp) where:ChatListModel.chatID==chatId&&ChatListModel.chatType==GroupChat];
}

-(void)updateIsService:(BOOL)IsService userId:(NSString*)userId{
    [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:{ChatListModel.isService} withValue:@(IsService) where:ChatListModel.chatID==userId&&ChatListModel.chatType==UserChat];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
}
-(void)updateIsBlock:(BOOL)block chatId:(NSString*)chatId{
    [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:{ChatListModel.block} withValue:@(block) where:ChatListModel.chatID==chatId&&ChatListModel.chatType==UserChat];
}
/// 更新自己是否被拉黑 自己被拉黑还可以显示在聊天列表
/// @param block 是否被拉黑
/// @param chatId chatId description
-(void)updateIsbeBlock:(BOOL)beBlock chatId:(NSString*)chatId{
    [self.wctDatabase updateRowsInTable:KWCChatListModelTable onProperty:ChatListModel.beBlock withValue:@(beBlock) where:ChatListModel.chatID==chatId&&ChatListModel.chatType==UserChat];
}
-(NSArray<ChatListModel*>*)getAllIcanChatListModel{
    NSArray*allarray= [self.wctDatabase getObjectsOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.block==NO&&ChatListModel.authorityType==AuthorityType_friend} orderBy:{ChatListModel.isStick.order(WCTOrderedDescending),ChatListModel.lastMessageTime.order(WCTOrderedDescending)}];
    
    return allarray;
}
-(NSArray<ChatListModel*>*)getSecretChatListModel{
    NSArray*allarray=[self.wctDatabase getObjectsOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.block==NO&&ChatListModel.authorityType==AuthorityType_secret }orderBy:{ChatListModel.lastMessageTime.order(WCTOrderedDescending)}];
    return allarray;
}
-(NSArray<ChatListModel*>*)getAllCircleChatListModel{
    NSArray*allarray=[self.wctDatabase getObjectsOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.authorityType==AuthorityType_circle&&ChatListModel.block==NO }orderBy:{ChatListModel.lastMessageTime.order(WCTOrderedDescending)}];
    return allarray;
}
-(NSArray<ChatListModel *> *)getCanTranspondAllChatListModel{
    NSArray*allarray= [self.wctDatabase getObjectsOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:{ChatListModel.block==NO&&(ChatListModel.messageType!=PayHelperMessageType&&ChatListModel.messageType!=ShopHelperMessageType&&ChatListModel.messageType!=SystemHelperMessageType&&ChatListModel.authorityType==AuthorityType_friend)} orderBy:{ChatListModel.isStick.order(WCTOrderedDescending),ChatListModel.lastMessageTime.order(WCTOrderedDescending)}];
    return allarray;
}
-(NSNumber*)fetchAllUnReadNumberCount{
    NSNumber*number= [self.wctDatabase getOneValueOnResult:ChatListModel.unReadMessageCount.sum() fromTable:KWCChatListModelTable where:{ChatListModel.isNoDisturbing==0&&ChatListModel.block==NO&&ChatListModel.authorityType==AuthorityType_friend}];
    return number;
}
-(NSNumber*)fetchAllSecretUnReadNumberCount{
    NSNumber*number= [self.wctDatabase getOneValueOnResult:ChatListModel.unReadMessageCount.sum() fromTable:KWCChatListModelTable where:{ChatListModel.authorityType==AuthorityType_secret}];
    return number;
}
-(NSNumber*)fetchAllCircleUnReadNumberCount{
    NSNumber*number= [self.wctDatabase getOneValueOnResult:ChatListModel.unReadMessageCount.sum() fromTable:KWCChatListModelTable where:{ChatListModel.authorityType==AuthorityType_circle&&ChatListModel.block==NO}];
    return number;
}
-(NSNumber*)fetchC2COrderUnReadMessageCountWith:(NSString*)c2cUserId c2cOrderId:(NSString*)c2cOrderId icanUserId:(NSString*)icanUserId{
    NSNumber*number= [self.wctDatabase getOneValueOnResult:ChatListModel.unReadMessageCount.sum() fromTable:KWCChatListModelTable where:{ChatListModel.authorityType==AuthorityType_c2c&&ChatListModel.c2cOrderId==c2cOrderId&&ChatListModel.chatID==icanUserId}];
    return number;
}


-(ChatListModel*)fetchOneChatListModelWithChatModel:(ChatModel*)config{
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        return [self.wctDatabase getOneObjectOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType&&ChatListModel.circleUserId==config.circleUserId];
    }else{
        return [self.wctDatabase getOneObjectOfClass:[ChatListModel class] fromTable:KWCChatListModelTable where:ChatListModel.chatID==config.chatID&&ChatListModel.chatType==config.chatType&&ChatListModel.authorityType==config.authorityType];
    }
}
@end
