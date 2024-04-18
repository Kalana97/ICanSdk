//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 17/9/2019
 - File name:  WCDBManager+ChatModel.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "WCDBManager+ChatModel.h"
#import "ChatModel+WCTTableCoding.h"
#import "XMFaceManager.h"
@implementation WCDBManager (ChatModel)
-(void)insertChatModels:(NSArray<ChatModel *> *)chatModels{
    [self.wctDatabase insertOrReplaceObjects:chatModels into:KWCChatModelTable];
    
}
-(void)insertChatModel:(ChatModel *)chatModel{
    [self.wctDatabase insertOrReplaceObject:chatModel into:KWCChatModelTable];
    
}

- (NSArray<NSString *> *)getMessageIdsByMessageType:(NSString*)messageType {
    NSArray<WCTValue *> *wctValues = [self.wctDatabase getOneColumnOnResult:ChatModel.messageID fromTable:KWCChatModelTable where:{ChatModel.chatID == messageType && ChatModel.chatType == messageType}];
    NSMutableArray<NSString *> *resultArray = [NSMutableArray array];
    for (WCTValue *value in wctValues) {
        NSString *stringValue = (NSString *)value; // If WCTValue is a subclass of NSString
        [resultArray addObject:stringValue];
    }
    return resultArray;
}

-(void)deleteAllChatModelWith:(ChatModel*)config{
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        [self.wctDatabase deleteObjectsFromTable:KWCChatModelTable where:(ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType&&ChatModel.circleUserId==config.circleUserId)];
    }else{
        [self.wctDatabase deleteObjectsFromTable:KWCChatModelTable where:(ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType)];
    }
}
-(void)deleteAllCircleMessage{
    [self.wctDatabase deleteObjectsFromTable:KWCChatModelTable where:(ChatModel.chatType==UserChat&&ChatModel.authorityType==AuthorityType_circle)];
}
-(void)deleteOneChatModelWithMessageId:(NSString *)messageId{
    [self.wctDatabase deleteObjectsFromTable:KWCChatModelTable where:ChatModel.messageID==messageId];
}
-(ChatModel *)fetchChatModelByMessageId:(ChatModel *)chatModel{
    NSArray *chatArray;
    if ([chatModel.authorityType isEqualToString:AuthorityType_circle]) {
        chatArray=[self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==chatModel.chatID&&ChatModel.chatType==chatModel.chatType&&ChatModel.authorityType==chatModel.authorityType&&ChatModel.circleUserId==chatModel.circleUserId&&ChatModel.messageID==chatModel.messageID}];
        return chatArray[0];
    }
    chatArray=[self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==chatModel.chatID&&ChatModel.chatType==chatModel.chatType&&ChatModel.authorityType==chatModel.authorityType&&ChatModel.messageID==chatModel.messageID}];
    return chatArray[0];
}

- (ChatModel *)getChatModelByMessageId:(NSString *)msgId{
    ChatModel *chatModel;
    chatModel = [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageID == msgId}];
    return chatModel;
}

- (ChatModel *)getDynamicChatModelByMessageId:(NSString *)msgId{
    ChatModel *chatModel;
    chatModel = [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID == msgId}];
    return chatModel;
}

-(NSArray<ChatModel*>*)fetchAllMessageWihtChatModel:(ChatModel *)config{
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType&&ChatModel.circleUserId==config.circleUserId}];
    }
    return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType}];
}
-(NSArray<ChatModel*>*)fetchHistoryMessageWihtChatId:(NSString *)chatID messageTime:(NSString*)messageTime chatType:(NSString*)chatType{
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==chatID&&ChatModel.chatType==chatType&&ChatModel.messageTime>=messageTime} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
    NSArray*newarray= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==chatID&&ChatModel.chatType==chatType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:5 offset:array.count];
    NSMutableArray*sortarray=[NSMutableArray array];
    [sortarray addObjectsFromArray:array];
    [sortarray addObjectsFromArray:newarray];
    return sortarray;
}

-(NSArray<ChatModel*>*)fetchChatModelMessageWihtConfigModel:(ChatModel*)configModel offset:(NSInteger)offset{
    NSString * authorityType = configModel.authorityType;
    if ([authorityType isEqualToString:AuthorityType_circle]) {
        return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID == configModel.chatID && ChatModel.chatType == configModel.chatType && ChatModel.authorityType == authorityType && ChatModel.circleUserId == configModel.circleUserId} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:100 offset:offset];
    }else if ([authorityType isEqualToString:AuthorityType_c2c]) {
        return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID == configModel.chatID && ChatModel.chatType == configModel.chatType && ChatModel.authorityType == AuthorityType_c2c && ChatModel.c2cOrderId == configModel.c2cOrderId && ChatModel.c2cUserId == configModel.c2cUserId} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:100 offset:offset];
    }
    return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID == configModel.chatID && ChatModel.chatType == configModel.chatType && ChatModel.authorityType == authorityType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:100 offset:offset];
}


-(NSArray<ChatModel*>*)fetchMediaChatModelWihtChatId:(NSString *)chatID chatType:(NSString*)chatType{
    
    return   [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==chatID&&ChatModel.messageType==ImageMessageType&&ChatModel.chatType==chatType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
}
-(NSArray<ChatModel*>*)fetchPayHelperMessageTypewithoffset:(NSInteger)offset {
    
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageType==PayHelperMessageType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:5 offset:offset];
    return array;
}
-(NSArray<ChatModel*>*)fetchC2CHelperMessageTypewithoffset:(NSInteger)offset {
    
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatType==C2CHelperMessageType&&ChatModel.chatID==C2CHelperMessageType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:5 offset:offset];
    return array;
}
-(NSArray<ChatModel*>*)fetchSystemHelperMessageTypeWithoffset:(NSInteger)offset {
    
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageType==SystemHelperMessageType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:5 offset:offset];
    return array;
}

-(NSArray<ChatModel*>*)fetchAnnouncementHelperMessageTypeWithoffset:(NSInteger)offset {
    
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageType==AnnouncementHelperMessageType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:5 offset:offset];
    return array;
}
-(NSArray<ChatModel*>*)fetchDynamicHelperMessageTypeWithoffset:(NSInteger)offset chatID:(NSString*)chatId {
    
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageType==DynamicMessageType&&ChatModel.merchantId==chatId} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:5 offset:offset];
    return array;
}

-(NSArray<ChatModel*>*)fetchDynamicHelperMessageTypeWithoutOffset{
    
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageType==DynamicMessageType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
    return array;
}

- (NSArray<ChatModel*>*)fetchNoticeOTPMessageTypeWithoffset:(NSInteger)offset {
    NSArray *array = [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageType == NoticeOTPMessageType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:5 offset:offset];
    return array;
}

-(NSArray<ChatModel*>*)fetchShopHelperMessageTypewithoffset:(NSInteger)offset {
    
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.messageType==ShopHelperMessageType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending) limit:10 offset:10*(offset-1)];
    return array;
}
-(NSArray *)fetchAllSendingMessage{
    return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.isOutGoing==YES&&ChatModel.sendState==2];
}
-(NSArray *)fetchAllSendingFailedMessage{
    return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.isOutGoing==YES&&ChatModel.sendState==0];
}
-(NSArray *)fetchAllSendingMessageWithChatId:(NSString *)chatId{
    return  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.isOutGoing==YES&&ChatModel.sendState==2&&ChatModel.chatID==chatId];
}
-(void)updateSendingMessageSendStateToFail{
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperty:{ChatModel.sendState} withValue:@(0) where:ChatModel.isOutGoing == YES && ChatModel.sendState == 2];
}

-(void)updateGamificationStatusWithChatModel:(ChatModel*)chatModel{
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperty:{ChatModel.gamificationStatus} withValue:@(0) where:ChatModel.messageID == chatModel.messageID];
}

- (void)updateTrueGamificationStatusWithChatModel:(ChatModel*)chatModel {
    ChatModel *model = [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID == chatModel.messageID];
    if (model) {
        model.gamificationStatus = true;
        NSArray *row = @[@(model.gamificationStatus)];
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.gamificationStatus} withRow:row where:ChatModel.messageID == chatModel.messageID];
    }
}

- (void)updatePinStatusWithChatId:(NSString *)messageId isPin:(BOOL)isPin isOther:(BOOL)isOther pinAudiance:(NSString*)pinAudiance {
    ChatModel *model = [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID == messageId];
    if (model) {
        NSArray *row = [[NSArray alloc] initWithObjects:@(isPin),pinAudiance, nil];
        NSArray *pinAudianceRow = [self.wctDatabase getOneColumnOnResult:ChatModel.pinAudiance fromTable:KWCChatModelTable where:ChatModel.messageID == messageId];
        if([pinAudianceRow[0] isKindOfClass:[NSString class]] && [pinAudianceRow[0] isEqualToString:@"Self"] && [pinAudiance isEqualToString:@"All"] && isOther == YES) {
            return;
        }else {
            [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.isPin, ChatModel.pinAudiance} withRow:row where:ChatModel.messageID == messageId];
        }
    }
}

- (NSArray<ChatModel*>*)getPinMessageWithChatModel:(NSString*)chatId {
    NSArray *array = [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID == chatId && ChatModel.isPin == YES} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
    return array;
}

- (void)updateReactionMessageByMessageId:(NSString *)messageId reaction:(NSString *)reaction action:(NSString *)action reactedPerson:(NSString *)reactedPerson selfReaction:(NSString *)selfReaction{
    ChatModel *model = [self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID == messageId];
    if (model) {
        NSMutableDictionary *reactions = [NSMutableDictionary dictionary];
        if (model.reactions && [model.reactions isKindOfClass:[NSMutableDictionary class]]) {
            reactions = [model.reactions mutableCopy];
        }
        if([action isEqualToString:@"addReaction"]){
            if([reactions.allKeys containsObject:reaction]){
                NSMutableArray *arrayForReaction = [reactions[reaction] mutableCopy];
                if(![arrayForReaction containsObject:reactedPerson]){
                    [arrayForReaction addObject:reactedPerson];
                    [reactions setObject:arrayForReaction forKey:reaction];
                }
            }else{
                [reactions setObject:[NSMutableArray arrayWithObject:reactedPerson] forKey:reaction];
            }
        }else{
            NSMutableArray *arrayForReaction = [reactions[reaction] mutableCopy];
            [arrayForReaction removeObject:reactedPerson];
            if(arrayForReaction.count == 0){
                [reactions removeObjectForKey:reaction];
            }else{
                [reactions setObject:arrayForReaction forKey:reaction];
            }
        }if(selfReaction == nil){
            NSArray *row = @[reactions];
            [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.reactions} withRow:row where:ChatModel.messageID == messageId];
        }else{
            NSArray *row = @[reactions,selfReaction];
            [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.reactions,ChatModel.selfReaction} withRow:row where:ChatModel.messageID == messageId];
        }
    }
}

-(void)updateMessageContentByMessageId:(ChatModel*)chatModel{
    ChatModel*model=[self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==chatModel.messageID];
    if (model){
        NSArray * row = @[chatModel.thumbnailTitleofTextUrl,chatModel.thumbnailImageurlofTextUrl];
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.thumbnailTitleofTextUrl,ChatModel.thumbnailImageurlofTextUrl} withRow:row where:ChatModel.messageID==chatModel.messageID];
    }
}
-(BOOL)fetchLocalHaveChatModelWithMessageId:(NSString *)messageId{
    NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==messageId];
    return array.count>0;
}

-(void)updateChatModelIsSuccessSendWithMessageId:(NSString*)messageId{
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperty:{ChatModel.sendState} withValue:@(1) where:ChatModel.messageID==messageId];
}
-(void)updateGroupChatModelReceiptStatus:(BaseMessageInfo*)baseMessageInfo{
    ChatModel*model=[self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==baseMessageInfo.messageId];
    if (model) {
        model.receiptStatus=@"READ";
        NSMutableArray*userIdItems=[NSMutableArray arrayWithArray:model.hasReadUserInfoItems];
        NSDictionary*newdict=@{@"time":baseMessageInfo.sendTime,@"id":baseMessageInfo.fromId};
        BOOL isContain = NO;
        for (NSDictionary*dict in userIdItems) {
            if ([[dict objectForKey:@"id"] isEqualToString:baseMessageInfo.fromId]) {
                isContain=YES;
                break;
            }
        }
        if (!isContain) {
            [userIdItems addObject:newdict];
        }
        model.hasReadUserInfoItems=userIdItems;
        NSArray * row = @[model.receiptStatus,model.hasReadUserInfoItems];
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.receiptStatus,ChatModel.hasReadUserInfoItems} withRow:row where:ChatModel.messageID==baseMessageInfo.messageId];
    }
}
-(void)updateChatModelReceiptStatus:(BaseMessageInfo*)baseMessageInfo{
    ChatModel*model=[self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==baseMessageInfo.messageId];
    if (model&&![model.receiptStatus isEqualToString:@"READ"]) {
        ReceiptMessageInfo*info=[ReceiptMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: baseMessageInfo.msgContent]];
        model.receiptStatus=info.receiptStatus;
        NSMutableArray*userIdItems=[NSMutableArray arrayWithArray:model.hasReadUserInfoItems];
        if ([info.receiptStatus isEqualToString:ReceiptREAD]) {
            NSDictionary*newdict;
            if (baseMessageInfo.fromId.length>0) {
                newdict=@{@"time":baseMessageInfo.sendTime,@"id":baseMessageInfo.fromId};
                BOOL isContain = NO;
                for (NSDictionary*dict in userIdItems) {
                    if ([dict objectForKey:@"id"]) {
                        isContain=YES;
                    }
                }
                if (!isContain) {
                    [userIdItems addObject:newdict];
                }
            }
        }
        model.hasReadUserInfoItems=userIdItems;
        NSArray * row = @[model.receiptStatus,model.hasReadUserInfoItems];
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.receiptStatus,ChatModel.hasReadUserInfoItems} withRow:row where:ChatModel.messageID==baseMessageInfo.messageId];
        
    }
}
-(void)updateMessageIsHasReadWithMessageId:(NSString *)messageId{
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperty:{ChatModel.hasRead} withValue:@(YES) where:ChatModel.messageID==messageId];
}
-(void)updateVoiceMessageHasReadFromMessageId:(NSString *)messageId{
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperty:{ChatModel.voiceHasRead} withValue:@(YES) where:ChatModel.messageID==messageId];
}

-(void)calculateChatModelWidthAndHeightWithChatModel:(ChatModel*)model{
    NSString*msgType=model.messageType;
    if ([msgType isEqualToString:TextMessageType]||[msgType isEqualToString:GamifyMessageType]||[msgType isEqualToString:AIMessageType]||[msgType isEqualToString:AIMessageQuestionType]||[msgType isEqualToString:AtAllMessageType]||[msgType isEqualToString:AtSingleMessageType]) {
        [self setTextlayout:model];
    }else if([msgType isEqualToString:URLMessageType]){
        [self setUrllayout:model];
    }else if ([msgType isEqualToString:ImageMessageType]){
        [self setImageLayout:model];
    }else if ([msgType isEqualToString:VoiceMessageType]){
        [self setVoiceLayout:model];
    }else if ([msgType isEqualToString:VideoMessageType]){
        [self setVideoLayout:model];
    }else if ([msgType isEqualToString:TransFerMessageType]){
        model.layoutHeight =KRedEnvelpoeHeight;
        model.layoutWidth =KRedEnvelopeWidth;
    }else if ([msgType isEqualToString:FileMessageType]){
        model.layoutWidth = KFileButtonWidth;
        model.layoutHeight = KFileButtonHeihgt;
    }else if ([msgType isEqualToString:kChatOtherShareType]){
        model.layoutWidth=KShareGoodsWidth;
        model.layoutHeight=KShareGoodsHeight;
    }
    else if ([msgType isEqualToString:UserCardMessageType]){
        model.layoutWidth=KUserVCardButtonWidth;
        model.layoutHeight=KUserVCardButtonHeight;
    }else if ([msgType isEqualToString:LocationMessageType]){
        model.layoutWidth = KLocationButtonWidth;
        model.layoutHeight = KLocationButtonHeight;
        
    }else if ([msgType isEqualToString:SendSingleRedPacketType]||[model.messageType isEqualToString:SendRoomRedPacketType]){
        /** 收到别人发送的单人红包 */
        model.layoutWidth = KRedEnvelopeWidth;
        model.layoutHeight = KRedEnvelpoeHeight;
    } else if ([msgType isEqualToString:kChat_PostShare]){
        
    }
    else if ([msgType isEqualToString:ChatCallMessageType]){
        ChatCallMessageInfo*info=[ChatCallMessageInfo mj_objectWithKeyValues:model.messageContent];
        //己方取消已发出的通话请求 CANCEL
        if ([info.callStatus isEqualToString:@"CANCEL"]) {
            if (model.isOutGoing) {
                model.showMessage=@"Canceled".icanlocalized;
            }else{
                model.showMessage=@"The other party has cancelled".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"REJECT"]){
            //己方拒绝收到的通话请求
            if (model.isOutGoing) {
                model.showMessage=@"Rejected".icanlocalized;
            }else{
                model.showMessage=@"The other party has rejected".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"HANGUP"]){
            // 己方挂断 HANGUP
            if (model.isOutGoing) {
                model.showMessage=@"Hang up".icanlocalized;
            }else{
                model.showMessage=@"The other party has hung up".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"BUSY_LINE"]){
            //  //己方忙碌 BUSY_LINE
            if (model.isOutGoing) {
                model.showMessage=@"The other party is busy".icanlocalized;
            }else{
                model.showMessage=@"Busy".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"NO_RESPONSE"]){
            //己方未接听 NO_RESPONSE
            if (model.isOutGoing) {
                model.showMessage=@"The other party did not answer".icanlocalized;
            }else{
                model.showMessage=@"Missed".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"ENGINE_UNSUPPORTED"]){
            //己方不支持当前引擎 ENGINE_UNSUPPORTED
            if (model.isOutGoing) {
                model.showMessage=@"Rejected".icanlocalized;
            }else{
                model.showMessage=@"The other party has rejected".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"NETWORK_ERROR"]){
            ////己方网络出错NETWORK_ERROR
            if (model.isOutGoing) {
                model.showMessage=@"Rejected".icanlocalized;
            }else{
                model.showMessage=@"The other party has rejected".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"REMOTE_CANCEL"]){
            //对方取消已发出的通话请求 REMOTE_CANCEL
            if (model.isOutGoing) {
                if([info.callType isEqualToString:@"VOICE"]){
                    model.showMessage = @"Missed voice call".icanlocalized;
                } else {
                    model.showMessage = @"Missed video call".icanlocalized;
                }
            }else{
                model.showMessage=@"Canceled".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"REMOTE_BUSY_LINE"]){
            ////对方忙碌REMOTE_BUSY_LINE
            if (model.isOutGoing) {
                model.showMessage=@"The other party is busy".icanlocalized;
            }else{
                model.showMessage=@"nimtips.busy".icanlocalized;
            }
        }else if ([info.callStatus isEqualToString:@"REMOTE_NO_RESPONSE"]){
            ///对方未接听  REMOTE_NO_RESPONSE
            if (model.isOutGoing) {
                model.showMessage=@"The other party did not answer".icanlocalized;
            }else{
                if([info.callType isEqualToString:@"VOICE"]){
                    model.showMessage=@"Missed voice call".icanlocalized;
                }else {
                    model.showMessage=@"Missed video call".icanlocalized;
                }
            }
        }else if ([info.callStatus isEqualToString:@"REMOTE_NETWORK_ERROR"]){
            ///对方网络错误REMOTE_NETWORK_ERROR
            if (model.isOutGoing) {
                model.showMessage=@"Rejected".icanlocalized;
            }else{
                model.showMessage=@"The other party has rejected".icanlocalized;
            }
        }
        if ([info.callStatus isEqualToString:@"SUCCESS"]){
            ////通话过程对方挂断 REMOTE_HANGUP
            // 己方挂断 HANGUP
            if (BaseSettingManager.isChinaLanguages) {
                model.showMessage=[NSString stringWithFormat:@"%@%@",@"Call Duration".icanlocalized,[self getMMSSFromSS:info.callTime]];
            }else{
                model.showMessage=[NSString stringWithFormat:@"%@ %@",@"Call Duration".icanlocalized,[self getMMSSFromSS:info.callTime]];
            }
        }
    }
    
    
}
//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(NSInteger )totalTime{
    NSInteger seconds = totalTime;
    NSString *format_time;
    NSString *str_hour;
    NSString * str_minute = [NSString stringWithFormat:@"%02lu",(seconds%3600)/60];
    NSString * str_second = [NSString stringWithFormat:@"%02lu",seconds%60];
    if (seconds>3600) {
        str_hour= [NSString stringWithFormat:@"%02lu",seconds/3600];
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }else{
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }
    
    
    return format_time;
    
}
-(void)setVoiceLayout:(ChatModel*)model{
    model.layoutHeight=40;
    if (model.mediaSeconds <=2) {
        model.layoutWidth=80;
        
    }else if (model.mediaSeconds==3){
        model.layoutWidth=90;
        
    } else if(model.mediaSeconds==4){
        model.layoutWidth=100;
        
    } else if (model.mediaSeconds==5){
        model.layoutWidth=110;
        
    } else if (model.mediaSeconds==6){
        model.layoutWidth=120;
        
    } else if (model.mediaSeconds==7){
        model.layoutWidth=130;
        
    } else if (model.mediaSeconds==8){
        model.layoutWidth=140;
        
    }else if (model.mediaSeconds>=9){
        model.layoutWidth=150;
        
    }
}
-(void)setImageLayout:(ChatModel*)model{
    NSDictionary *dicStr = [model.messageContent mj_JSONObject];
    ImageMessageInfo*info=[ImageMessageInfo mj_objectWithKeyValues:dicStr];
    if (info) {
        CGSize size= [self calculateSizeWithWidth:info.width  height:info.height ];
        model.layoutWidth=size.width;
        model.layoutHeight=size.height;
    }else{
        NSString *imgCachePath = [ MessageImageCache(model.chatID) stringByAppendingPathComponent:[NSString stringWithFormat:@"small_%@",model.fileCacheName]];
        UIImage*cachedImage=[UIImage imageWithContentsOfFile:imgCachePath];
        CGSize size=  [self calculateSizeWithWidth:cachedImage.size.width height:cachedImage.size.height];
        model.layoutWidth=size.width;
        model.layoutHeight=size.height;
    }
}
-(void)setVideoLayout:(ChatModel*)model{
    NSDictionary *dicStr = [model.messageContent mj_JSONObject];
    VideoMessageInfo*info=[VideoMessageInfo mj_objectWithKeyValues:dicStr];
    if (info) {
        if (info.height) {
            CGSize size= [self calculateSizeWithWidth:info.width  height:info.height ];
            
            model.layoutWidth=size.width;
            model.layoutHeight=size.height;
        }else{
            model.layoutWidth=120;
            model.layoutHeight=160;
        }
    }else{
        NSString *basePath = MessageVideoCache(model.chatID);
        NSString *detailPath = [basePath stringByAppendingPathComponent:[model.fileCacheName componentsSeparatedByString:@"."].firstObject];
        UIImage* cachedImage = [UIImage imageWithContentsOfFile:detailPath];;
        CGSize size=  [self calculateSizeWithWidth:cachedImage.size.width height:cachedImage.size.height];
        model.layoutWidth=size.width;
        model.layoutHeight=size.height;
    }
}
-(void)setTextlayout:(ChatModel*)model{
    NSMutableAttributedString*attrStr = [XMFaceManager emotionStrWithString:model.showMessage isOutGoing:model.isOutGoing];
    CGFloat height,width;
    if([UserInfoManager.sharedManager.fontSize isEqualToString: @"19"]){
        width = [NSString widthWithAttrbuteString:attrStr height:23 cgflotTextFont:19.0];
        width = width+19.0 > KTextMaxWidth ? KTextMaxWidth : width+19.0;
        model.layoutWidth = width+8;
    }else if([UserInfoManager.sharedManager.fontSize isEqualToString: @"17"]){
        width = [NSString widthWithAttrbuteString:attrStr height:21 cgflotTextFont:17.0];
        width = width+17.0 > KTextMaxWidth ? KTextMaxWidth : width+17.0;
        model.layoutWidth = width+6;
    }else{
        width = [NSString widthWithAttrbuteString:attrStr height:20 cgflotTextFont:16.0];
        width = width+16.0 > KTextMaxWidth ? KTextMaxWidth : width+16.0;
        model.layoutWidth = width+5;
    }
    if([UserInfoManager.sharedManager.fontSize isEqualToString: @"19"]){
        height = [NSString heightWithAttrbuteString:attrStr width:model.layoutWidth cgflotTextFont:19.0];
    }else if([UserInfoManager.sharedManager.fontSize isEqualToString: @"17"]){
        height = [NSString heightWithAttrbuteString:attrStr width:model.layoutWidth cgflotTextFont:17.0];
    }else{
        height = [NSString heightWithAttrbuteString:attrStr width:model.layoutWidth cgflotTextFont:16.0];
    }
    model.layoutHeight = height>30?height:30;
}
-(void)setUrllayout:(ChatModel*)model{
    NSMutableAttributedString*attrStr = [XMFaceManager emotionStrWithString:model.showMessage isOutGoing:model.isOutGoing];
    CGFloat width = [NSString widthWithAttrbuteString:attrStr height:20 cgflotTextFont:16.0];
    width = KTextMaxWidth;
    model.layoutWidth = width+5;
    CGFloat height = [NSString heightWithAttrbuteString:attrStr width:model.layoutWidth-10 cgflotTextFont:16.0];
    model.layoutHeight = height;
}
- (CGRect)rectInTextView:(UITextView *)textView stringRange:(NSRange)stringRange{
    UITextPosition *begin = [textView positionFromPosition:textView.beginningOfDocument offset:stringRange.location];
    UITextPosition *end = [textView positionFromPosition:begin offset:stringRange.length];
    UITextRange *textRange = [textView textRangeFromPosition:begin toPosition:end];
    return [textView firstRectForRange:textRange];
}
// 计算图片的尺寸
- (CGSize)calculateSizeWithWidth:(CGFloat)width height:(CGFloat)height {
    CGFloat wid = width;
    CGFloat hei = height;
    if (wid > 160) {
        wid = 160;
        hei = height / width * wid;
    } else if (wid < 70 ) {
        wid = 70;
    }
    if (hei > 160) {
        hei = 160;
        wid = width / height * hei;
    } else if (hei < 70) {
        hei = 70;
    }
    return CGSizeMake(wid, hei);
}

-(void)deleteMessageWihtTime:(NSInteger)time{
    NSInteger currentTime = [[GetTime getCurrentTimestamp]integerValue];
    if (time!=0) {
        [self.wctDatabase deleteObjectsFromTable:KWCChatModelTable where:ChatModel.messageTime <(currentTime - time*1000)];
    }
    
    
}
/// 撤回消息的时候 把消息类型设置Chat_withdraw+原消息模型
/// @param chatModel chatModel description
-(void)updateMessageTypeWithChatModel:(ChatModel*)chatModel{
    ChatModel*model=[self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==chatModel.messageID];
    if (model) {
        model.messageType=[NSString stringWithFormat:@"%@+%@",WithdrawMessageType,model.messageType];
        model.showMessage=chatModel.showMessage;
        //需要更新的属性
        NSArray *row = @[model.messageType,model.showMessage];
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.messageType,ChatModel.showMessage} withRow:row where:ChatModel.messageID==chatModel.messageID];
    }
}
-(void)updateMessageTypeWithMessageId:(NSString *)messageId{
    ChatModel*model=[self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==messageId];
    if (model) {
        model.messageType=[NSString stringWithFormat:@"%@+%@",WithdrawMessageType,model.messageType];
        //需要更新的属性
        NSArray *row = @[model.messageType];
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.messageType} withRow:row where:ChatModel.messageID==messageId];
    }
}
-(void)updateTranslateWithChatmodel:(ChatModel *)cmodel{
    if (cmodel.translateStatus==1) {
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.translateStatus,ChatModel.translateMsg,ChatModel.layoutWidth} withObject:cmodel where:ChatModel.messageID==cmodel.messageID];
    }else{
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.translateStatus,ChatModel.layoutWidth} withObject:cmodel where:ChatModel.messageID==cmodel.messageID];
    }
}
-(void)updateMsgTypeToNoticeRemoveChatTypeWithMessageId:(NSString *)msgId{

    ChatModel*model=[self.wctDatabase getOneObjectOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==msgId];
    if (model) {
        model.messageType=Notice_RemoveChatType;
        model.showMessage=@"TheOtherPartyDeletesAMessage".icanlocalized;
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.messageType,ChatModel.showMessage,ChatModel.layoutWidth,ChatModel.layoutHeight} withObject:model where:ChatModel.messageID==msgId];
//        [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_RemoveChatNotification object:nil];
    }
    
}

-(void)updateSingleRedPacketMessagStateByModel:(ChatModel *)redPacketModel{
    if (redPacketModel.redPacketAmount) {
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.showRedState,ChatModel.redPacketState,ChatModel.redPacketAmount} withObject:redPacketModel where:ChatModel.messageID==redPacketModel.messageID];
    }else{
        [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.showRedState,ChatModel.redPacketState} withObject:redPacketModel where:ChatModel.messageID==redPacketModel.messageID];
    }
    
    
    
}
- (void)updateSingleRedPacketShowRedStateByRedId:(NSString *)redId showRedState:(BOOL)showRedState{
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperty:{ChatModel.showRedState} withValue:@(showRedState) where:ChatModel.redId==redId];
    
}
-(void)updateSingleRedPacketMessagStateByRedId:(NSString *)redId redPacketState:(NSString *)redPacketState{
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperty:{ChatModel.redPacketState} withValue:redPacketState where:ChatModel.redId==redId];
}
-(NSArray *)fetchChatModelBySearchText:(NSString *)searchText authorityType:(NSString*)authorityType{
    if (searchText.length>0) {
        NSString*sear=[NSString stringWithFormat:@"%%%@%%",searchText];
        //得到对应的聊天记录
        NSArray<ChatModel*>*array=[self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.showMessage.like(sear)&&ChatModel.authorityType==authorityType&&(ChatModel.messageType==TextMessageType||ChatModel.messageType==AtSingleMessageType||ChatModel.messageType==AtAllMessageType)} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
        NSMutableArray*singleItems=[NSMutableArray array];
        NSMutableArray*groupItems=[NSMutableArray array];
        NSMutableDictionary *singleDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
        for (ChatModel*model in array) {
            if ([model.chatType isEqualToString:UserChat]) {
                [singleItems addObject:model];
            }else if ([model.chatType isEqualToString:GroupChat]){
                [groupItems addObject:model];
            }
        }
        //由于可能存在群ID和用户ID相同的情况 所以在这里先分开 再组合
        for (ChatModel *model in singleItems) {
            [singleDic setObject:model forKey:model.chatID];
        }
        for (ChatModel *model in groupItems) {
            [groupDic setObject:model forKey:model.chatID];
        }
        NSArray*allSingle=[singleDic allKeys];
        NSArray*allGroup=[groupDic allKeys];
        NSMutableArray*result=[NSMutableArray array];
        for (NSString*chatId in allSingle) {
            NSArray*singleArray= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.showMessage.like(sear)&&ChatModel.chatID==chatId&&ChatModel.chatType==UserChat&&(ChatModel.messageType==TextMessageType||ChatModel.messageType==AtSingleMessageType||ChatModel.messageType==AtAllMessageType)} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
            [result addObject:singleArray];
        }
        for (NSString*chatId in allGroup) {
            NSArray*singleArray= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.showMessage.like(sear)&&ChatModel.chatID==chatId&&ChatModel.chatType==GroupChat&&(ChatModel.messageType==TextMessageType||ChatModel.messageType==AtSingleMessageType||ChatModel.messageType==AtAllMessageType)} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
            [result addObject:singleArray];
        }
        return result;
    }
    return @[];
}
/// 获取所有的未读消息数量 以及消息
-(NSDictionary*)fetchAllUnReadMessageWihtChatModel:(ChatModel *)config{
    /*
     1. 获取最早一条未读消息的时间
     2. 获取这条未读消息之后所有的消息
     3. 获取未读消息的总数量 
     */
    NSArray<ChatModel*> * items;
    if ([config.authorityType isEqualToString:AuthorityType_circle]) {
        items = [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType&&ChatModel.circleUserId==config.circleUserId&&ChatModel.hasRead==@(NO)&&ChatModel.isOutGoing==NO&&(ChatModel.messageType==TextMessageType||ChatModel.messageType==GamifyMessageType||ChatModel.messageType==VoiceMessageType||ChatModel.messageType==URLMessageType||ChatModel.messageType==ImageMessageType||ChatModel.messageType==LocationMessageType||ChatModel.messageType==UserCardMessageType||ChatModel.messageType==AtAllMessageType||ChatModel.messageType==VideoMessageType||ChatModel.messageType==FileMessageType||ChatModel.messageType==ChatCallMessageType||ChatModel.messageType==TransFerMessageType||ChatModel.messageType==SendSingleRedPacketType||ChatModel.messageType==SendRoomRedPacketType||ChatModel.messageType==kChatOtherShareType||ChatModel.messageType==kChat_PostShare||ChatModel.messageType==PayHelperMessageType||ChatModel.messageType==ShopHelperMessageType||ChatModel.messageType==SystemHelperMessageType||ChatModel.messageType==C2COrderMessageType||ChatModel.messageType==PayHelperMessageType||ChatModel.messageType==ShopHelperMessageType||ChatModel.messageType==AnnouncementHelperMessageType)} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
        NSString * messageTime = items.lastObject.messageTime;
        NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.messageTime>=messageTime&&ChatModel.authorityType==config.authorityType&&ChatModel.circleUserId==config.circleUserId} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
        return @{@"msgs":array,@"count":@(items.count)};
    }else{
        items =  [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.authorityType==config.authorityType&&ChatModel.hasRead==@(NO)&&ChatModel.isOutGoing==NO&&(ChatModel.messageType==TextMessageType||ChatModel.messageType==VoiceMessageType||ChatModel.messageType==ImageMessageType||ChatModel.messageType==URLMessageType||ChatModel.messageType==GamifyMessageType||ChatModel.messageType==LocationMessageType||ChatModel.messageType==UserCardMessageType||ChatModel.messageType==AtAllMessageType||ChatModel.messageType==VideoMessageType||ChatModel.messageType==FileMessageType||ChatModel.messageType==ChatCallMessageType||ChatModel.messageType==TransFerMessageType||ChatModel.messageType==SendSingleRedPacketType||ChatModel.messageType==SendRoomRedPacketType||ChatModel.messageType==kChatOtherShareType||ChatModel.messageType==kChat_PostShare||ChatModel.messageType==PayHelperMessageType||ChatModel.messageType==ShopHelperMessageType||ChatModel.messageType==SystemHelperMessageType||ChatModel.messageType==C2COrderMessageType ||ChatModel.messageType==PayHelperMessageType||ChatModel.messageType==ShopHelperMessageType||ChatModel.messageType==AnnouncementHelperMessageType)} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
        NSString * messageTime = items.lastObject.messageTime;
        NSArray*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:{ChatModel.chatID==config.chatID&&ChatModel.chatType==config.chatType&&ChatModel.messageTime>=messageTime&&ChatModel.authorityType==config.authorityType} orderBy:ChatModel.messageTime.order(WCTOrderedDescending)];
        return @{@"msgs":array,@"count":@(items.count)};
    }
}
-(void)updateChatModelGroupApplyWithMessageId:(NSString*)messageId{
    NSArray<ChatModel*>*array= [self.wctDatabase getObjectsOfClass:[ChatModel class] fromTable:KWCChatModelTable where:ChatModel.messageID==messageId];
    ChatModel*cmodel=array.firstObject;
    if(cmodel != nil) {
        [self updateChatModelGroupApplyWith:cmodel];
    }
}
-(void)updateChatModelGroupApplyWith:(ChatModel*)cmodel{
    cmodel.showMessage = [cmodel.showMessage stringByReplacingOccurrencesOfString:@"ToConfirm".icanlocalized withString:@"HasConfirm".icanlocalized];
    cmodel.isShowOpenRedView = NO;
    NSArray *row = @[cmodel.showMessage,@(cmodel.isShowOpenRedView)];
    [self.wctDatabase updateRowsInTable:KWCChatModelTable onProperties:{ChatModel.showMessage,ChatModel.isShowOpenRedView} withRow:row where:ChatModel.messageID==cmodel.messageID];
}
@end
