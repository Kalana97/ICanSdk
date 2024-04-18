//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/3
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  WebSocketManager+HandleMessage.m
 - Description: WebSocketManager 处理收到的消息
 - Function List:
 - History:
 */


#import "WebSocketManager+HandleMessage.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+TimeLineNotice.h"
#import "TimeLineNoticeInfo.h"
#import "WCDBManager+CircleUserInfo.h"
#import "WCDBManager+GroupApplyInfo.h"
#import "WCDBManager+GroupListInfo.h"
#import "GroupApplyInfo.h"
#import "VoicePlayerTool.h"
#import "LocalNotificationManager.h"
#import "FriendSubscriptionInfo.h"
#import "BaseMessageInfo.h"
#import <WBGLinkPreview/WBGLinkPreview.h>
#import "TFHpple.h"

@implementation WebSocketManager (HandleMessage)

/// 通过收到的消息创建本地缓存chatModel
/// @param messageInfo messageInfo description
-(ChatModel*)createChatModelFromBaseMessageInfo:(BaseMessageInfo*)messageInfo {
    ChatModel*chatModel=[[ChatModel alloc]init];
    if ([messageInfo.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
        chatModel.isOutGoing = YES;
        chatModel.chatID=messageInfo.groupId?:messageInfo.toId;
        chatModel.messageFrom=messageInfo.fromId;
    }else{
        chatModel.isOutGoing = NO;
        chatModel.chatID=messageInfo.groupId?:messageInfo.fromId;
        chatModel.messageFrom=messageInfo.fromId;
    }
    chatModel.authorityType=AuthorityType_friend;
    //如果存在该字段 才赋值 因为由后台发送的消息 该字段为空
    if (messageInfo.authorityType.length>0) {
        chatModel.authorityType = messageInfo.authorityType;
    }
    if (messageInfo.fromCircleUserId) {
        chatModel.circleUserId = messageInfo.fromCircleUserId;
    }
    //如果是C2C类型的消息
    if ([messageInfo.authorityType isEqualToString:AuthorityType_c2c]) {
        if (messageInfo.extra.length>0) {
            NSDictionary * dict = [messageInfo.extra mj_JSONObject];
            chatModel.c2cOrderId = [dict valueForKey:@"orderId"];
            chatModel.c2cUserId = [dict valueForKey:@"c2cUserId"];
        }
    }
    chatModel.sendState  = 1;
    chatModel.messageTime=messageInfo.sendTime;
    chatModel.chatMode = messageInfo.chatMode;
    chatModel.messageID=messageInfo.messageId;
    chatModel.messageType=messageInfo.msgType;
    chatModel.chatType=messageInfo.groupId?GroupChat:UserChat;
    chatModel.destoryTime=[NSString stringWithFormat:@"%ld",(long)messageInfo.destroy];
    chatModel.message=[messageInfo mj_JSONString];
    chatModel.messageContent=messageInfo.msgContent;
    return chatModel;
}
-(void)didReceiveMessage:(NSString*)message{
    NSString *groupMsg = [AESEncryptor decryptAESWithString:message];
    DDLogInfo(@"didReceiveMessage=%@",groupMsg);
    NSDictionary *dicStr = [groupMsg mj_JSONObject];
    BaseMessageInfo*info=[BaseMessageInfo mj_objectWithKeyValues:dicStr];
    [self handleReceviMessage:info];
    
}
/// 处理收到普通聊天消息
/// @param model model description
-(void)handleReceiveChatMessageWith:(BaseMessageInfo*)model {
    NSString *messageType = model.msgType;
    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:model];
    if ([messageType isEqualToString:TextMessageType]) {
        TextMessageInfo *info = [TextMessageInfo mj_objectWithKeyValues:model.msgContent];
        NSString *inputString = info.content;
        NSString *htmlEntityPattern = @"&[A-Za-z]+;";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:htmlEntityPattern options:0 error:nil];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:inputString options:0 range:NSMakeRange(0, inputString.length)];
        if (matches.count > 0) {
            NSLog(@"HTML entities found in the string.");
            NSString *htmlString = inputString;

            NSMutableString *decodedString = [htmlString mutableCopy];
            NSRange range = [decodedString rangeOfString:@"&" options:NSLiteralSearch];

            while (range.location != NSNotFound) {
                NSRange semicolonRange = [decodedString rangeOfString:@";" options:NSLiteralSearch range:NSMakeRange(range.location, decodedString.length - range.location)];
                
                if (semicolonRange.location != NSNotFound) {
                    NSRange entityRange;
                    entityRange.location = range.location;
                    entityRange.length = semicolonRange.location - range.location + 1;
                    
                    NSString *entity = [decodedString substringWithRange:entityRange];
                    NSString *decodedEntity = [self decodeHTMLEntity:entity]; // Define your HTML entity decoding method
                    [decodedString replaceCharactersInRange:entityRange withString:decodedEntity];
                }
                
                range = [decodedString rangeOfString:@"&" options:NSLiteralSearch range:NSMakeRange(range.location + 1, decodedString.length - range.location - 1)];
            }
            chatModel.showMessage = decodedString;
        } else {
            NSLog(@"No HTML entities found in the string.");
            chatModel.showMessage = info.content;
        }
        
        chatModel.extra=info.extra;
    }else if ([messageType isEqualToString:GamifyMessageType]) {
        TextMessageInfo *info = [TextMessageInfo mj_objectWithKeyValues:model.msgContent];
        chatModel.showMessage = info.content;
        chatModel.extra = info.extra;
        chatModel.gamificationStatus = 1;
    }else if ([messageType isEqualToString:URLMessageType]) {
        TextMessageInfo*info = [TextMessageInfo mj_objectWithKeyValues:model.msgContent];
        chatModel.showMessage = info.content;
        chatModel.extra = info.extra;
        [self getThumbnailDetailsofUrlMsg:chatModel];
    } else if ([messageType isEqualToString:ImageMessageType]) {
        ImageMessageInfo*imageInfo=[ImageMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.extra=imageInfo.extra;
        chatModel.imageUrl=imageInfo.imageUrl;
        chatModel.thumbnails=imageInfo.thumbnails;
        chatModel.messageContent=[NSString decodeUrlString: model.msgContent];
        if ([model.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
            chatModel.sendState=1;
            chatModel.uploadState=1;
            chatModel.uploadProgress=@"100%";
        }
    }else if ([messageType isEqualToString:VoiceMessageType]){
        VoiceMessageInfo*info=[VoiceMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.mediaSeconds=info.duration;
        chatModel.fileServiceUrl=info.content;
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:UserCardMessageType]){
        UserCardMessageInfo*info=[UserCardMessageInfo mj_objectWithKeyValues:model.msgContent];
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:FileMessageType]){
        FileMessageInfo*info=[FileMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.extra=info.extra;
        chatModel.showFileName=info.name;
        chatModel.fileServiceUrl=info.fileUrl;
        chatModel.totalUnitCount=info.size;
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:AtSingleMessageType]){
        AtSingleMessageInfo*info=[AtSingleMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.showMessage=info.content;
        chatModel.extra=info.extra;
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:AtAllMessageType]){
        AtAllMessageInfo*info=[AtAllMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.showMessage=info.content;
        chatModel.extra=info.extra;
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:DynamicMessageType]){
        DynamicMessageInfo *info = [DynamicMessageInfo mj_objectWithKeyValues:model.msgContent];
        chatModel.messageContent = [info mj_JSONString];
        chatModel.merchantId = info.merchantId;
    }else if ([messageType isEqualToString:LocationMessageType]){
        LocationMessageInfo*info=[LocationMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.extra=info.extra;
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:TransFerMessageType]){
        TranferMessageInfo*info=[TranferMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.showMessage=info.content;
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:kChat_PostShare]){
        ChatPostShareMessageInfo*info=[ChatPostShareMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.messageContent=[info mj_JSONString];
    }
    else if ([messageType isEqualToString:ChatCallMessageType]){
        ChatCallMessageInfo*info=[ChatCallMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.messageContent=[info mj_JSONString];
    }else if ([messageType isEqualToString:VideoMessageType]){
        VideoMessageInfo*info=[VideoMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.messageContent=[info mj_JSONString];
        chatModel.fileCacheName=[NSString stringWithFormat:@"%@.mp4",[NSString getArc4random5:1]];
        chatModel.extra=info.extra;
        chatModel.fileServiceUrl=info.sightUrl;
        chatModel.imageUrl=info.content;
        chatModel.mediaSeconds=info.duration;
        chatModel.downloadState=3;
        chatModel.extra=info.extra;
        if ([model.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
            chatModel.sendState=1;
            chatModel.uploadState=1;
            chatModel.uploadProgress=@"100%";
        }
    }else if ([messageType isEqualToString:SendSingleRedPacketType]){
            //收到别人发送的单人红包
            SingleRedPacketMessageInfo*singleRedPacketInfo=[SingleRedPacketMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
            chatModel.messageContent=[singleRedPacketInfo mj_JSONString];
            chatModel.showMessage=singleRedPacketInfo.comment;
            chatModel.redId=singleRedPacketInfo.ID;
    }else if ([messageType isEqualToString:SendRoomRedPacketType]){
            //收到别人发送的多人红包
            SingleRedPacketMessageInfo*singleRedPacketInfo=[SingleRedPacketMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
            chatModel.messageContent=[singleRedPacketInfo mj_JSONString];
            chatModel.showMessage=singleRedPacketInfo.comment;
            chatModel.redId=singleRedPacketInfo.ID;
        
    }else if ([messageType isEqualToString:kChatOtherShareType]){
        ChatOtherUrlInfo*singleRedPacketInfo=[ChatOtherUrlInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.messageContent=[singleRedPacketInfo mj_JSONString];
    }else if ([messageType isEqualToString:RejectSingleRedPacketType ]){//收到退回的红包消息
        return;
    }
    
    else if ([messageType isEqualToString:GrabSingleRedPacketType]){
        if (![model.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
            //收到别人领取了你的单人红包的消息
            SingleRedPacketMessageInfo*singleRedPacketInfo=[SingleRedPacketMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
            chatModel.messageContent=[singleRedPacketInfo mj_JSONString];
            chatModel.redId=singleRedPacketInfo.ID;
            chatModel.redPacketState=KRedPacketsuccess;
            [[WCDBManager sharedManager]updateSingleRedPacketMessagStateByRedId: singleRedPacketInfo.ID redPacketState:KRedPacketsuccess];
            //通知界面进行改变
            [[NSNotificationCenter defaultCenter]postNotificationName:kReceiveSingleRedPacketGrabNotification object:chatModel userInfo:nil];
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                chatModel.showMessage=[NSString stringWithFormat:@"%@ %@",info.remarkName?:info.nickname,@"Received your red packet".icanlocalized];
                [self saveMessageWithChatModel:chatModel];
            }];
            return;
        }
        
    }else if ([messageType isEqualToString:GrabRoomRedPacketTypeType]){
        ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:model];
        //收到别人领取了你的多人红包的消息
        MultipleRedPacketMessageInfo*singleRedPacketInfo=[MultipleRedPacketMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.messageContent=[singleRedPacketInfo mj_JSONString];
        chatModel.redId=singleRedPacketInfo.ID;
        //通知界面进行改变
        [[NSNotificationCenter defaultCenter]postNotificationName:kReceiveSingleRedPacketGrabNotification object:chatModel userInfo:nil];
        if ([model.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
            if ([model.toId isEqualToString:[UserInfoManager sharedManager].userId]) {
                chatModel.showMessage=[NSString stringWithFormat:@"You received your red packet"].icanlocalized;
                [self saveMessageWithChatModel:chatModel];
            }
        }else{
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.fromId successBlock:^(UserMessageInfo * _Nonnull info) {
                chatModel.showMessage=[NSString stringWithFormat:@"%@ %@",info.remarkName?:info.nickname,@"Received your red packet".icanlocalized];
                [self saveMessageWithChatModel:chatModel];
                [self showLocalNotificationwithChatModel:chatModel];
            }];
        }
        return;
    }
    else if ([messageType isEqualToString:WithdrawMessageType]){
        WithdrawMessageInfo*info=[WithdrawMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.msgContent]];
        chatModel.messageID=info.content;
        chatModel.messageType=[NSString stringWithFormat:@"%@+%@",WithdrawMessageType,model.msgType];
        //由于消息同步问题 导致跟新了本地的showmessage字段的内容
        //如果是自己发送的
        if ([model.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
            //如果是APP端的消息则不处理 处理电脑端发送过来的撤回消息
            if (![model.platform isEqualToString:@"APP"]) {
                chatModel.messageType=[NSString stringWithFormat:@"%@+%@",WithdrawMessageType,model.msgType];
                chatModel.isOutGoing=YES;
                [[WCDBManager sharedManager]updateMessageTypeWithMessageId:chatModel.messageID];
                [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
                if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                    [self.delegate webSocketManagerDidReceiveMessage:chatModel];
                }
            }
        }else{
            if ([chatModel.chatType isEqualToString:UserChat]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                        chatModel.showMessage=[NSString stringWithFormat:@"\"%@\" %@",info.remarkName?:info.nickname,@"Recalled a message".icanlocalized];
                        [[WCDBManager sharedManager]updateMessageTypeWithChatModel:chatModel];
                        [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
                        if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                            [self.delegate webSocketManagerDidReceiveMessage:chatModel];
                        }
                    }];
                });
                
            }else{
                [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:chatModel.chatID userId:chatModel.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                    chatModel.showMessage=[NSString stringWithFormat:@"\"%@\" %@",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,@"Recalled a message".icanlocalized];
                    [[WCDBManager sharedManager]updateMessageTypeWithChatModel:chatModel];
                    [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
                    if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                        [self.delegate webSocketManagerDidReceiveMessage:chatModel];
                    }
                }];
            }
        }
        
        
        return;
    }else{
        return;
    }
    
    //只有单聊并且是以下类型的消息才会发送已经收到的消息回执
    if ([chatModel.chatType isEqualToString:UserChat]&&![model.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
        if ([messageType isEqualToString:VoiceMessageType]||[messageType isEqualToString:TextMessageType]||[messageType isEqualToString:URLMessageType]||[messageType isEqualToString:GamifyMessageType]||[messageType isEqualToString:LocationMessageType]||[messageType isEqualToString:ImageMessageType]||[messageType isEqualToString:VideoMessageType]||[messageType isEqualToString:UserCardMessageType]||[messageType isEqualToString:AtAllMessageType]||[messageType isEqualToString:AtSingleMessageType]||[messageType isEqualToString:TransFerMessageType]||[messageType isEqualToString:SendSingleRedPacketType]||[messageType isEqualToString:SendRoomRedPacketType]||[messageType isEqualToString:kChat_PostShare]||[messageType isEqualToString:kChatOtherShareType]) {
            [self sendHasReceiveMessageReceiptWithChatModel:chatModel];
        }
        
    }
    [self saveMessageWithChatModel:chatModel];
    // Create two NSDate objects representing the start and end times
            NSDate *startTime = [GetTime dateConvertFromTimeStamp:chatModel.messageTime]; // Replace this with your actual start time
            NSDate *endTime = [NSDate date];   // Replace this with your actual end time
            // Calculate the time difference in seconds
            NSTimeInterval timeDifference = [endTime timeIntervalSinceDate:startTime];
    if(timeDifference < 5) {
        NSLog(@"Time differenceUfffffffff: %.2f seconds", timeDifference);
        [self showLocalNotificationwithChatModel:chatModel];
    }
    
}

- (NSString *)decodeHTMLEntity:(NSString *)entity {
    NSDictionary *entityMap = @{
        @"&amp;": @"&",
        @"&lt;": @"<",
        @"&gt;": @">",
        @"&plus;": @"+",
    };
    NSString *decodedEntity = entityMap[entity];
    return decodedEntity ?: entity;
}

/// 处理收到的通知类型的消息（全新的自定义的消息格式）
/// @param messageInfo messageInfo description
-(void)handleReceviMessage:(BaseMessageInfo*)messageInfo{
    NSString*msgType=messageInfo.msgType;
    //收到对方消息回执
    if ([msgType isEqualToString:ReceiptMessageType]&&![messageInfo.fromId isEqualToString:[UserInfoManager sharedManager].userId]){
        [[WCDBManager sharedManager]updateChatModelReceiptStatus:messageInfo];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketDidReceiptBaseMessageInfo:)]) {
            [self.delegate webSocketDidReceiptBaseMessageInfo:messageInfo];
        }
    }else if ([msgType isEqualToString:ReceiptGroupMessageType]){
        //收到群聊已读回执 如果收到的消息回执是给自己发送的 那么不处理
        if (![messageInfo.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
            [[WCDBManager sharedManager]updateGroupChatModelReceiptStatus:messageInfo];
            if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketDidReceiptBaseMessageInfo:)]) {
                [self.delegate webSocketDidReceiptBaseMessageInfo:messageInfo];
            }
        }
    }else{
        //先判断本地是否存在该消息ID
        if (![[WCDBManager sharedManager]fetchLocalHaveChatModelWithMessageId:messageInfo.messageId]) {
            if ([messageInfo.msgType isEqualToString:Notice_AddGroupMessageType]) {
                [self handleNotice_addGroupMessageWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_QuitGroupMessageType]){
                
                [self handleNotice_QuitGroupMessageWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_DeleteFriendMessageType]){//删除好友消息
                
                [self handleNotice_DeleteFriendWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_AddFriendMessageType]){
                
                [self handleNotice_agreeFriendWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_SubjectMessageType]){
                
                [self handleNotice_subjectWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_UpdateGroupNicknameType]){
                [self handleNotice_groupNicknameWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_TransferGroupOwnerType]){
                [self handleNotice_TransferGroupOwnerWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_GroupRoleUpdateType]){
                [self handleNotice_Notice_GroupRoleUpdateWithMessage:messageInfo];
            } else if ([messageInfo.msgType isEqualToString:Notice_DestroyTimeType]){
                [self handleNotice_destoryTimeWithMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_ScreencastType]){
                [self handleScreenNoticeMessage:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_DestroyUserType]){
                [[NSNotificationCenter defaultCenter]postNotificationName:kDeleteFriendNotification object:messageInfo.fromId];
            }else if([messageInfo.msgType isEqualToString:Notice_FreezeType]){
                //冻结用户
                Notice_FreezeInfo*info=  [Notice_FreezeInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                if ([UserInfoManager sharedManager].lastLoginTime) {
                    if ([[UserInfoManager sharedManager].lastLoginTime integerValue]<=messageInfo.sendTime.integerValue) {
                        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:YES tips:[NSString stringWithFormat:@"%@^$%@",info.content,Notice_FreezeType]];
                    }
                }
            }else if ([messageInfo.msgType isEqualToString:Notice_Group_UpdateType]){
                //群设置更新了
                NoticeGroupUpdateInfo*info=[NoticeGroupUpdateInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                [self fetchGroupDetailRequest:info.groupId];
            }
            else if ([messageInfo.msgType isEqualToString:Notice_AllShutUpMessageType]){
                NoticeAllShutUpInfo*info=[NoticeAllShutUpInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                [[WCDBManager sharedManager]updateGroupAllShutUp:info.groupId allShutUp:info.allShutUp];
                [[NSNotificationCenter defaultCenter]postNotificationName:KGetGroupDetailNotification object:info.groupId];
            }else if ([messageInfo.msgType isEqualToString:Notice_ReadReceiptMessageType]){
                Notice_ReadReceiptInfo*info=[Notice_ReadReceiptInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                [[WCDBManager sharedManager]updateUserReadReceipt:info.readReceipt chatId:messageInfo.fromId];
            }else if ([messageInfo.msgType isEqualToString:Notice_ShowUserInfoMessageType]){
                NoticeShowUserInfoInfo*info=[NoticeShowUserInfoInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateGroupMessageNotification object:info.groupId userInfo:nil];
            }else if ([messageInfo.msgType isEqualToString:Notice_OnlineChangeType]){//好友的离线在线之后 收到的通知消息
                Notice_OnlineChangeInfo*notice_OnlineChangeInfo=[Notice_OnlineChangeInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_OnlineChangeNotification object:notice_OnlineChangeInfo];
                
            } else if ([messageInfo.msgType isEqualToString:Notice_LoginType]){
                NoticeLoginInfo*noticeLoginInfo=[NoticeLoginInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                if ([UserInfoManager sharedManager].lastLoginTime&&[[UserInfoManager sharedManager].lastLoginTime integerValue]<=noticeLoginInfo.time&&![noticeLoginInfo.token isEqualToString:[UserInfoManager sharedManager].token]) {
                    [[WebSocketManager sharedManager]userManualLogout];
                    NSDate*date=[GetTime dateConvertFromTimeStamp:[NSString stringWithFormat:@"%ld",noticeLoginInfo.time]];
                    NSString*text=[GetTime getTimeWithMessageDate:date];;
                    [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:YES tips:text];
                }
                
            }else if ([messageInfo.msgType isEqualToString:ShopHelperMessageType]){
                ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
                model.messageFrom=ShopHelperMessageType;
                model.chatID=ShopHelperMessageType;
                model.chatType=UserChat;
                [self saveMessageWithChatModel:model];
                [self showLocalNotificationwithChatModel:model];
                if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                    [self.delegate webSocketManagerDidReceiveMessage:model];
                }
            }else if ([messageInfo.msgType isEqualToString:TimeLine_Notice]){
                [self handleTimeLine_Notice:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_VersionType]){///** 版本更新 */
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_VersionNotification object:nil];
            }else if ([msgType isEqualToString:kNotice_JoinGroupReviewUpdate]){//收到群开启审核通知
                [self handleNotice_JoinGroupReviewUpdateWith:messageInfo];
            }else if ([msgType isEqualToString:Notice_JoinGroupApplyType]){//收到申请进群的消息
                [self handleNotice_JoinGroupApplyWith:messageInfo];
            }else if ([msgType isEqualToString:C2COrderMessageType]){//收到C2C订单状态改变的消息
                [self handleC2COrderMessageTypeWith:messageInfo];
            }else if ([msgType isEqualToString:C2CExtRechargeWithdrawType]){//收到充值的消息
                [self handleC2CExtRechargeWithdraw:messageInfo];
            }else if ([msgType isEqualToString:C2CTransferType]){//收到C2C转账的消息
                [self handleC2CTransfer:messageInfo];
            } else if ([messageInfo.msgType isEqualToString:Notice_BanMessageType]){//禁用
                if ([UserInfoManager sharedManager].lastLoginTime) {
                    if ([[UserInfoManager sharedManager].lastLoginTime integerValue]<=[messageInfo.sendTime integerValue]) {
                        NSDate*date=[GetTime dateConvertFromTimeStamp:messageInfo.sendTime];
                        NSString*text=[GetTime stringFromDate:date withDateFormat:@"yyyy-MM-dd"];
                        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:YES tips:[NSString stringWithFormat:@"%@,%@",text,Notice_BanMessageType]];
                        
                    }
                }
                
            }else if ([messageInfo.msgType isEqualToString:Notice_BlockUserType]){
                BlockUserMessageInfo*blockUserInfo=[BlockUserMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                [[NSNotificationCenter defaultCenter]postNotificationName:kNoticeBlockUsersNotification object:blockUserInfo userInfo:nil];
            }else if ([messageInfo.msgType isEqualToString:Add_friend_successType]){
                ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
                //如果是自己发送的消息 You  added  用户名 as a friend, say hi!
                if ([messageInfo.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
                    model.chatID=messageInfo.toId;
                    if (BaseSettingManager.isChinaLanguages) {
                        model.showMessage=@"You are become friends each other".icanlocalized;
                        [self saveMessageWithChatModel:model];
                    }else{
                        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                            model.showMessage=[NSString stringWithFormat:@"You  added %@ as a friend, say hi!",info.remarkName?:info.nickname];
                            [self saveMessageWithChatModel:model];
                        }];
                        
                    }
                    
                }else{
                    //用户名 Added you as a friend, Say hi !
                    //收到别人添加你为好友
                    model.chatID=messageInfo.fromId;
                    if (BaseSettingManager.isChinaLanguages) {
                        model.showMessage=@"You are become friends each other".icanlocalized;
                        [self saveMessageWithChatModel:model];
                    }else{
                        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                            model.showMessage=[NSString stringWithFormat:@"%@ Added you as a friend, Say hi !",info.remarkName?:info.nickname];
                            [self saveMessageWithChatModel:model];
                        }];
                        
                    }
                }
            }else if ([messageInfo.msgType isEqualToString:Notice_RemoveChatType]){
                //收到对方删除消息
                [self handleNotice_RemoVeMessage:messageInfo];
                
            }else if ([messageInfo.msgType isEqualToString:PayHelperMessageType]){
                ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
                model.messageFrom=PayHelperMessageType;
                model.chatID=PayHelperMessageType;
                [self saveMessageWithChatModel:model];
                [self showLocalNotificationwithChatModel:model];
                if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                    [self.delegate webSocketManagerDidReceiveMessage:model];
                }
            }else if ([messageInfo.msgType isEqualToString:SystemHelperMessageType]){
                [self handleSystemHelper:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:Notice_UserShutUp]) {
                [self handleNotice_UserShutUp:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:AIMessageType]){
                ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
                if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                    [self.delegate webSocketManagerDidReceiveMessage:model];
                }
            }else if ([messageInfo.msgType isEqualToString:AIMessageQuestionType]){
                ChatModel *model = [self createChatModelFromBaseMessageInfo:messageInfo];
                    [self.delegate webSocketManagerDidReceiveMessage:model];
            }else if ([messageInfo.msgType isEqualToString:AnnouncementHelperMessageType]) {
                [self handleAnnounceHelper:messageInfo];

            }else if ([messageInfo.msgType isEqualToString:Notice_PayQRType]){
                ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
                model.messageFrom=PayHelperMessageType;
                model.chatID=PayHelperMessageType;
                if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                    [self.delegate webSocketManagerDidReceiveMessage:model];
                }
            }else if ([messageInfo.msgType isEqualToString:PinMessageType]) {
                NSData *data = [messageInfo.msgContent dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *msgContent = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                BOOL isPin = NO;
                if([[msgContent objectForKey:@"action"] isEqualToString:@"Pin"]) {
                    isPin = YES;
                }
                [[WCDBManager sharedManager]updatePinStatusWithChatId:[msgContent objectForKey:@"pinnedMsgId"] isPin:isPin isOther:YES pinAudiance:[msgContent objectForKey:@"audience"]];
                ChatModel *model = [self createChatModelFromBaseMessageInfo:messageInfo];
                if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:)]) {
                    [self.delegate webSocketManagerDidReceiveMessage:model];
                }
            }else if ([messageInfo.msgType isEqualToString:ReactionMessage]){
                if(![messageInfo.fromId isEqualToString:[UserInfoManager sharedManager].userId]){
                    ReactionMessageInfo *info = [ReactionMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
                    [[WCDBManager sharedManager] updateReactionMessageByMessageId:info.reactedMsgId reaction:info.reaction action:info.action reactedPerson:messageInfo.fromId selfReaction:nil];
                    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:)]) {
                        [self.delegate webSocketManagerDidReceiveMessage:chatModel];
                    }
                }
            }else if ([messageInfo.msgType isEqualToString:C2CNotifyMessageType]) {
                [self handleC2COrderMessageTypeWith:messageInfo];
            }else if ([messageInfo.msgType isEqualToString:NoticeOTPMessageType]) {
                [self handleNoticeOTPMessageTypeWith:messageInfo];
            }else {//这些消息都是由客户端发送 - These messages are sent by the client
                //如果判断是APP发送 并且fromID是自己 则不处理 因为这些消息都是pc端为了同步消息，服务器再次发送的 - If it is judged that it is sent by the APP and the fromID is itself, it will not be processed because these messages are sent by the server again to synchronize the messages on the PC side.
                if ([messageInfo.platform isEqualToString:@"APP"]&&[messageInfo.fromId isEqualToString:UserInfoManager.sharedManager.userId]) {
                    return;
                }
                [self handleReceiveChatMessageWith:messageInfo];
            }
        }
    }
}

-(void)handleSystemHelper:(BaseMessageInfo*)messageInfo{
    [[UserInfoManager sharedManager]getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
    }];
    SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    if ([removeChatInfo.type isEqualToString:@"UserAuthPass"]) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:KUserAuthPassNotification object:nil];
    }
    ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
    model.messageFrom = SystemHelperMessageType;
    model.chatID = SystemHelperMessageType;
    [self saveMessageWithChatModel:model];
    [self showLocalNotificationwithChatModel:model];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
        [self.delegate webSocketManagerDidReceiveMessage:model];
    }
}

-(void)handleNotice_UserShutUp:(BaseMessageInfo*)messageInfo{
    ChatModel *model = [self createChatModelFromBaseMessageInfo:messageInfo];
    NSData *data = [messageInfo.msgContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *msgContent = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    BOOL userShutUp = [[msgContent objectForKey:@"userShutUp"] boolValue];
    NSString *userShutUpString = userShutUp ? @"true" : @"false";
    model.messageContent = userShutUpString;
    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
        [self.delegate webSocketManagerDidReceiveMessage:model];
    }
}


-(void)handleAnnounceHelper:(BaseMessageInfo*)messageInfo{
    [[UserInfoManager sharedManager]getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
    }];
    SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
    model.messageFrom = AnnouncementHelperMessageType;
    model.chatID = AnnouncementHelperMessageType;
    [self saveMessageWithChatModel:model];
    [self showLocalNotificationwithChatModel:model];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
        [self.delegate webSocketManagerDidReceiveMessage:model];
    }
}

- (void)handleNoticeOTPMessageTypeWith:(BaseMessageInfo*)messageInfo {
    [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil];
    if (![[WCDBManager sharedManager]fetchLocalHaveChatModelWithMessageId:messageInfo.messageId]) {
        ChatModel *model = [self createChatModelFromBaseMessageInfo:messageInfo];
        model.authorityType = AuthorityType_friend;
        model.chatID = NoticeOTPMessageType;
        model.chatType = NoticeOTPMessageType;
        model.messageType = NoticeOTPMessageType;
        ChatModel *NoticeOTPModel = [[WCDBManager sharedManager]insertNoticeOTPMessageWithChatModel:model];
        [self showLocalNotificationwithChatModel:NoticeOTPModel];
        if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:)]) {
            [self.delegate webSocketManagerDidReceiveMessage:NoticeOTPModel];
        }
    }
}

/// C2C订单状态改变的通知
/// @param messageInfo messageInfo description
-(void)handleC2COrderMessageTypeWith:(BaseMessageInfo*)messageInfo{
    [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil];
    if (![[WCDBManager sharedManager]fetchLocalHaveChatModelWithMessageId:messageInfo.messageId]){
        C2COrderMessageInfo*jsonInfo=[C2COrderMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
        ///创建一个显示在订单聊天页面的消息
        ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
        model.authorityType = AuthorityType_c2c;
        if ([jsonInfo.buyC2CUserId isEqualToString:C2CUserManager.shared.userId]) {
            model.chatID = jsonInfo.sellICanUserId;
            model.c2cUserId = jsonInfo.sellC2CUserId;
        }else{
            model.chatID = jsonInfo.buyICanUserId;
            model.c2cUserId = jsonInfo.buyC2CUserId;
        }
        model.c2cOrderId = jsonInfo.orderId;
        model.chatType = UserChat;
        if ([messageInfo.msgType isEqualToString:C2CNotifyMessageType]) {
            model.messageType = C2CNotifyMessageType;
        }else {
            model.messageType = C2COrderMessageType;
        }
        [self saveMessageWithChatModel:model];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
            [self.delegate webSocketManagerDidReceiveMessage:model];
        }
        ///创建钱包助手消息
        ChatModel*c2cHelperModel = [[WCDBManager sharedManager]insertC2CHelperMessageWithChatModel:model];
        [self showLocalNotificationwithChatModel:c2cHelperModel];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
            [self.delegate webSocketManagerDidReceiveMessage:c2cHelperModel];
        }
        if ([jsonInfo.status isEqualToString:@"Unpaid"]) {
            //如果订单状态是未付款 也就是刚刚创建的时候，广告拥有者本地缓存一条自动回复的消息
            if (jsonInfo.autoMessage) {
                ChatModel * autoMessageModel = [self createChatModelFromBaseMessageInfo:messageInfo];
                autoMessageModel.messageType = TextMessageType;
                autoMessageModel.showMessage = jsonInfo.autoMessage;
                autoMessageModel.isOutGoing = YES;
                autoMessageModel.authorityType = AuthorityType_c2c;
                autoMessageModel.sendState = 1;
                autoMessageModel.chatType = UserChat;
                autoMessageModel.messageID = [WCDBManager.sharedManager generateMessageID];
                autoMessageModel.c2cOrderId = jsonInfo.orderId;
                if ([jsonInfo.buyC2CUserId isEqualToString:C2CUserManager.shared.userId]) {
                    autoMessageModel.chatID = jsonInfo.sellICanUserId;
                    autoMessageModel.c2cUserId = jsonInfo.sellC2CUserId;
                }else{
                    autoMessageModel.chatID = jsonInfo.buyICanUserId;
                    autoMessageModel.c2cUserId = jsonInfo.buyC2CUserId;
                }
                [self saveMessageWithChatModel:autoMessageModel];
                if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
                    [self.delegate webSocketManagerDidReceiveMessage:autoMessageModel];
                }
            }
        }
    }
}

///处理c2c划转的消息
-(void)handleC2CTransfer:(BaseMessageInfo*)messageInfo{
    if (![[WCDBManager sharedManager]fetchLocalHaveChatModelWithMessageId:messageInfo.messageId]){
        ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
        model.authorityType = AuthorityType_c2c;
        model.chatType = UserChat;
        model.messageType = C2CTransferType;
        ///创建钱包助手消息
        ChatModel*c2cHelperModel = [[WCDBManager sharedManager]insertC2CHelperMessageWithChatModel:model];
        [self showLocalNotificationwithChatModel:c2cHelperModel];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
            [self.delegate webSocketManagerDidReceiveMessage:c2cHelperModel];
        }
    }
    
}
-(void)handleC2CExtRechargeWithdraw:(BaseMessageInfo*)messageInfo{
    if (![[WCDBManager sharedManager]fetchLocalHaveChatModelWithMessageId:messageInfo.messageId]){
        ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
        model.authorityType = AuthorityType_c2c;
        model.chatType = UserChat;
        model.messageType = C2CExtRechargeWithdrawType;
        ///创建钱包助手消息
        ChatModel*c2cHelperModel = [[WCDBManager sharedManager]insertC2CHelperMessageWithChatModel:model];
        [self showLocalNotificationwithChatModel:c2cHelperModel];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
            [self.delegate webSocketManagerDidReceiveMessage:c2cHelperModel];
        }
    }
    
}
/// 处理收到的帖子通知，例如有人评论或者转发了你的帖子
/// @param messageInfo messageInfo description
- (void)handleTimeLine_Notice:(BaseMessageInfo *)messageInfo {
    TimeLineJsonInfo*jsonInfo=[TimeLineJsonInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    TimeLineNoticeInfo*timeline=[[TimeLineNoticeInfo alloc]init];
    timeline.noteId=jsonInfo.ID;
    timeline.avatar=jsonInfo.avatar;
    timeline.msgId=messageInfo.messageId;
    timeline.nickName=jsonInfo.nickName;
    timeline.messageType=jsonInfo.messageType;
    timeline.userId=jsonInfo.userId;
    timeline.msgType=TimeLine_Notice;
    timeline.commentId=jsonInfo.commentId;
    timeline.time=jsonInfo.time;
    timeline.gender=jsonInfo.gender;
    if (![[UserInfoManager sharedManager].userId isEqualToString:messageInfo.fromId]) {
        [[WCDBManager sharedManager]insertTimeLineNoticeInfoOf:timeline];
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateNoticeInfoNumberNotification object:nil];
    }
    
}
#pragma mark - 收到删除消息的消息
- (void)handleNotice_RemoVeMessage:(BaseMessageInfo *)messageInfo {
    //如果会员在有效期里面并且用户开启了按钮
    if ((UserInfoManager.sharedManager.seniorValid||UserInfoManager.sharedManager.diamondValid)&&UserInfoManager.sharedManager.preventDeleteMessage) {
        return;
        
    }
    RemoveChatMsgInfo*removeChatInfo=[RemoveChatMsgInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    //如果在这里存在messageid的时候，那么需要把本地的消息改成 对方删除了一条消息
    if (removeChatInfo.messageIds && removeChatInfo.deleteAll && ![removeChatInfo.type isEqualToString:@"GroupAll"] && ![removeChatInfo.type isEqualToString:@"GroupPart"]) {
        if(![UserInfoManager.sharedManager.userId isEqualToString:messageInfo.fromId]){
            for (NSString *msgId in removeChatInfo.messageIds) {
                [[WCDBManager sharedManager]updateMsgTypeToNoticeRemoveChatTypeWithMessageId:msgId];
            }
        }
        ChatModel*config = [[ChatModel alloc]init];
        ///同步消息
        if ([messageInfo.platform isEqualToString:@"System"]) {
            config.chatID = messageInfo.fromId;
        }else{
            config.chatID = messageInfo.fromId;
        }
        config.chatType = UserChat;
        config.authorityType = messageInfo.authorityType;
        config.circleUserId = messageInfo.fromCircleUserId;
        if(![UserInfoManager.sharedManager.userId isEqualToString:messageInfo.fromId]){
            [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_RemoveChatNotification object:messageInfo];
    }else{
        if ([removeChatInfo.type isEqualToString:@"GroupAll"] || [removeChatInfo.type isEqualToString:@"GroupPart"]) {
            //群主或者管理员删除了群里面的所有消息
            if (![removeChatInfo.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
                ChatModel * config = [[ChatModel alloc]init];
                config.chatID = messageInfo.groupId;
                config.chatType = GroupChat;
                config.authorityType = AuthorityType_friend;
                ChatListModel*cacheModel= [[WCDBManager sharedManager]fetchOneChatListModelWithChatModel:config];
                if (cacheModel) {
                    if (removeChatInfo.messageIds == nil && [removeChatInfo.type isEqualToString:@"GroupAll"]) {
                        [[WCDBManager sharedManager]deleteResourceWihtChatId:messageInfo.groupId];
                        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
                    }else{
                        for (NSString *msgId in removeChatInfo.messageIds) {
                            [[WCDBManager sharedManager]updateMsgTypeToNoticeRemoveChatTypeWithMessageId:msgId];
                        }
                        [[WCDBManager sharedManager]deleteResourceWihtChatId:messageInfo.groupId];
                        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_RemoveChatNotification object:messageInfo];
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_RemoveChatNotification object:messageInfo];
        }else{
            //个人删除了全部消息
            ChatModel * config = [[ChatModel alloc]init];
            config.chatID = messageInfo.fromId;
//            ///同步消息
//            if ([messageInfo.platform isEqualToString:@"System"]) {
//
//            }else{
//                config.chatID = messageInfo.fromId;
//            }
            config.chatType = UserChat;
            config.authorityType = messageInfo.authorityType;
            config.circleUserId = messageInfo.fromCircleUserId;
            ChatListModel*cacheModel= [[WCDBManager sharedManager]fetchOneChatListModelWithChatModel:config];
            //如果本地存在聊天列表 那么需要显示对方删除了全部消息字样
            if (cacheModel) {
                if (removeChatInfo.deleteAll) {
                    [[WCDBManager sharedManager]deleteResourceWihtChatId:messageInfo.fromId];
                    if (messageInfo.authorityType.length>0) {
                        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
                    }
                    ChatModel*model=[self createChatModelFromBaseMessageInfo:messageInfo];
                    model.showMessage=@"The other party deleted all messages".icanlocalized;
                    [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:NO];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_RemoveChatNotification object:messageInfo];

                }
            }
            if([UserInfoManager.sharedManager.userId isEqualToString:messageInfo.fromId]){
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotice_RemoveChatNotification object:messageInfo];
            }

        }
    }
    
    
}

//处理收到的群邀请
-(void)handleNotice_JoinGroupApplyWith:(BaseMessageInfo*)messageInfo{
    GroupApplyInfo*applyInfo=[GroupApplyInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    applyInfo.messageId = messageInfo.messageId;
    applyInfo.messageTime = messageInfo.sendTime;
    [[WCDBManager sharedManager]insertGroupApplyInfo:applyInfo];
    
    ChatModel*chatModel=[self createChatModelFromBaseMessageInfo:messageInfo];
    chatModel.messageFrom=applyInfo.groupId;
    chatModel.chatID=applyInfo.groupId;
    chatModel.isOutGoing = NO;
    chatModel.authorityType=AuthorityType_friend;
    chatModel.sendState  = 1;
    chatModel.chatType=GroupChat;
    //收到该消息的时候 可以点击去确认
    chatModel.isShowOpenRedView = YES;
    chatModel.destoryTime=[NSString stringWithFormat:@"%ld",(long)messageInfo.destroy];
    chatModel.message=[messageInfo mj_JSONString];
    //需要URL解码收到的messagecontent
    if ([NSString decodeUrlString: messageInfo.msgContent]) {
        chatModel.messageContent=[NSString decodeUrlString: messageInfo.msgContent];
    }else{
        chatModel.messageContent=messageInfo.msgContent;
    }
    NSMutableString*content=[[NSMutableString alloc]init];
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    request.userId=applyInfo.inviterId;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        [content appendFormat:@"\"%@\"",response.nickname];
        [content appendString:@"Invite".icanlocalized];
        GetUserMessageRequest*drequest=[GetUserMessageRequest request];
        drequest.userId=applyInfo.userId;
        drequest.parameters=[drequest mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:drequest responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
            [content appendFormat:@"\"%@\"",response.nickname];
            [content appendString:@"joinIn".icanlocalized];
            [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:applyInfo.groupId successBlock:^(GroupListInfo * _Nonnull info) {
                [content appendFormat:@"\"%@\"",info.name];
                [content appendString:@"applyJoinGroup".icanlocalized];
                [content appendString:@"ToConfirm".icanlocalized];
                chatModel.showMessage = content;
                [self saveMessageWithChatModel:chatModel];
            }];
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}

/// 处理收到的群审核开启通知 只有群主和管理员能收到
/// @param messageInfo messageInfo description
-(void)handleNotice_JoinGroupReviewUpdateWith:(BaseMessageInfo*)messageInfo{
    Notice_JoinGroupReviewUpdateInfo*joinGroupInfo=[Notice_JoinGroupReviewUpdateInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    ChatModel*chatModel=[self createChatModelFromBaseMessageInfo:messageInfo];
    chatModel.messageFrom=joinGroupInfo.groupId;
    chatModel.chatID=joinGroupInfo.groupId;
    chatModel.isOutGoing = NO;
    chatModel.authorityType=AuthorityType_friend;
    chatModel.sendState  = 1;
    chatModel.chatType=GroupChat;
    chatModel.destoryTime=[NSString stringWithFormat:@"%ld",(long)messageInfo.destroy];
    chatModel.message=[messageInfo mj_JSONString];
    //需要URL解码收到的messagecontent
    if ([NSString decodeUrlString: messageInfo.msgContent]) {
        chatModel.messageContent=[NSString decodeUrlString: messageInfo.msgContent];
    }else{
        chatModel.messageContent=messageInfo.msgContent;
    }
    
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    request.userId=joinGroupInfo.operatorId;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        if (joinGroupInfo.open) {
            chatModel.showMessage = [NSString stringWithFormat:@"%@ %@",response.nickname,@"OpenApplyCheckTips".icanlocalized];
        }else{
            chatModel.showMessage = [NSString stringWithFormat:@"%@ %@",response.nickname,@"CloseApplyCheckTips".icanlocalized];
        }
        
        [self saveMessageWithChatModel:chatModel];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
/// 处理收到的邀请进群的消息
/// @param messageInfo messageInfo description
-(void)handleNotice_addGroupMessageWithMessage:(BaseMessageInfo*)messageInfo{
    if (![self.cacheMessageIds containsObject:messageInfo.messageId]) {
        [self.cacheMessageIds addObject:messageInfo.messageId];
        NoticeAddGroupInfo*addGroupInfo=[NoticeAddGroupInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
        ChatModel*notice_addGroupModel=[self createChatModelFromBaseMessageInfo:messageInfo];
        notice_addGroupModel.messageFrom=addGroupInfo.invite;
        notice_addGroupModel.chatID=messageInfo.groupId;
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateGroupMessageNotification object:messageInfo.groupId userInfo:nil];
        BOOL shouldSubscriptionGroup=YES;
        //遍历已经订阅的群订阅
        for (STOMPSubscription*sub in [WebSocketManager sharedManager].subscribeArray) {
            if ([sub.subscriptionAddress containsString:messageInfo.groupId]) {
                shouldSubscriptionGroup=NO;
                break;
            }
        }
        if (shouldSubscriptionGroup) {
            [self subscriptionGroupWihtGroupId:messageInfo.groupId];
        }
        [self getUserInfosWihNoticeMessageAddGroupInfo:addGroupInfo chatModel:notice_addGroupModel];
        [self fetchGetGroupList];
    }
    
}
-(void)fetchGetGroupList {
    GetGroupListRequest*request=[GetGroupListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupListInfo class] success:^(NSArray<GroupListInfo*>* response) {
        for (GroupListInfo*info in response) {
            [[WCDBManager sharedManager]updateGroupAllShutUp:info.groupId allShutUp:info.allShutUp];
        }
        [[WCDBManager sharedManager]insertOrUpdateGroupListInfoWithArray:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
-(void)getUserInfosWihNoticeMessageAddGroupInfo:(NoticeAddGroupInfo*)addGroupInfo chatModel:(ChatModel*)chatModel{
    
    NSMutableString*content=[[NSMutableString alloc]init];
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    if ([addGroupInfo.addGroupMode isEqualToString:KNotice_AddGroup_BeInvited]) {
        request.userId=addGroupInfo.invite;
    }else{
        request.userId=addGroupInfo.ids.lastObject;
    }
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        if ([addGroupInfo.addGroupMode isEqualToString:KNotice_AddGroup_BeInvited]) {
            if ([addGroupInfo.invite isEqualToString:[UserInfoManager sharedManager].userId]) {//是自己邀请
                [content appendString:@"You".icanlocalized];
            }else{
                [content appendString:response.nickname];
            }
            
            [content appendString:NSLocalizedString(@" Invite ", 邀请)];
            GetUserListRequest*request=[GetUserListRequest request];
            request.parameters=[addGroupInfo.ids mj_JSONString];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo*>* response) {
                for (int i=0; i<response.count; i++) {
                    UserMessageInfo*model=response[i];
                    if (i!=0) {
                        [content appendString:@"、"];
                    }
                    [content appendString:model.nickname];
                }
                chatModel.messageContent=content;
                
                chatModel.showMessage=[NSString stringWithFormat:@"%@%@",content,NSLocalizedString(@"Into group chat", 进入了群聊)];
                chatModel.messageFrom=addGroupInfo.invite;
                [self saveMessageWithChatModel:chatModel];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }else if([addGroupInfo.addGroupMode isEqualToString:KNotice_AddGroup_ScanCode]){
            if ([[NSString stringWithFormat:@"%@",addGroupInfo.ids.lastObject] isEqualToString:[UserInfoManager sharedManager].userId]) {
                [content appendString:@"You".icanlocalized];
            }else{
                [content appendString:@"\""];
                [content appendString:response.nickname];
                [content appendString:@"\""];
            }
            [content appendString:NSLocalizedString(@"Join group chat by scanning QR code", 通过扫描二维码加入了群聊)];
            chatModel.messageContent=content;
            chatModel.showMessage=[NSString stringWithFormat:@"%@",content];
            chatModel.messageFrom=addGroupInfo.invite;
            [self saveMessageWithChatModel:chatModel];
        } else if ([addGroupInfo.addGroupMode isEqualToString:KNotice_AddGroup_Search]){
            if ([[NSString stringWithFormat:@"%@",addGroupInfo.ids.lastObject] isEqualToString:[UserInfoManager sharedManager].userId]) {
                [content appendString:@"You".icanlocalized];
            }else{
                [content appendString:@"\""];
                [content appendString:response.nickname];
                [content appendString:@"\""];
            }
            
            [content appendString:@"Join group chat via search".icanlocalized];
            chatModel.messageContent=content;
            chatModel.showMessage=[NSString stringWithFormat:@"%@",content];
            chatModel.messageFrom=[NSString stringWithFormat:@"%@",addGroupInfo.ids.firstObject];
            [self saveMessageWithChatModel:chatModel];
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
    
    
}

/// 处理收到的退出群聊消息 如果是被踢出那么就会收到 如果是自己主动退出 那么不会收到
/// @param messageInfo <#messageInfo description#>
-(void)handleNotice_QuitGroupMessageWithMessage:(BaseMessageInfo*)messageInfo{
    if (![self.cacheMessageIds containsObject:messageInfo.messageId]) {
        [self.cacheMessageIds addObject:messageInfo.messageId];
        ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
        NoticeQuitGroupInfo*addGroupInfo=[NoticeQuitGroupInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
        [self getUserInfosWihNoticeMessageQuitGroupInfo:addGroupInfo chatModel:chatModel];
    }
    
}
-(void)getUserInfosWihNoticeMessageQuitGroupInfo:(NoticeQuitGroupInfo*)quitGroupInfo chatModel:(ChatModel*)chatModel{
    if ([quitGroupInfo.leave isEqualToString:[UserInfoManager sharedManager].userId]){
        [self unsubscribeGroupWithGroupId:chatModel.chatID];
    }
    if ([quitGroupInfo.operatore isEqualToString:[UserInfoManager sharedManager].userId]) {//有operator证明是群主踢人
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:quitGroupInfo.leave successBlock:^(UserMessageInfo * _Nonnull info) {
            chatModel.showMessage=[NSString stringWithFormat:@"%@ \%@ \%@ ",@"You removed".icanlocalized,info.remarkName?:info.nickname,@"from the group chat".icanlocalized];
            chatModel.messageFrom=quitGroupInfo.leave;
            [self saveMessageWithChatModel:chatModel];
        }];
    }else{
        if([quitGroupInfo.leave isEqualToString:[UserInfoManager sharedManager].userId]&&quitGroupInfo.kickedOut) {//自己被踢出群聊
            [self unsubscribeGroupWithGroupId:chatModel.chatID];
            chatModel.showMessage=@"You were removed from the group chat".icanlocalized;
            chatModel.messageFrom=quitGroupInfo.operatore?:chatModel.messageType;
            //删除本地缓存数据
            [[WCDBManager sharedManager]deleteGroupListInfoWithGroupId:chatModel.chatID];
            [self saveMessageWithChatModel:chatModel];
        } else if (!quitGroupInfo.kickedOut){//自己手动退出群聊 群主收到
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:quitGroupInfo.leave successBlock:^(UserMessageInfo * _Nonnull info) {
                chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",info.remarkName?:info.nickname,@"left the group chat".icanlocalized];
                chatModel.messageFrom=quitGroupInfo.leave;
                [self saveMessageWithChatModel:chatModel];
            }];
        }else if (quitGroupInfo.kickedOut&&!quitGroupInfo.operatore){//没有操作者 后台操作
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:quitGroupInfo.leave successBlock:^(UserMessageInfo * _Nonnull info) {
                chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",info.remarkName?:info.nickname,@"Kicked out of group chat".icanlocalized];
                chatModel.messageFrom=quitGroupInfo.leave;
                [self saveMessageWithChatModel:chatModel];
            }];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateGroupMessageNotification object:chatModel.chatID userInfo:nil];
}

-(void)fetchGroupDetailRequest:(NSInteger)groupId{
    GetGroupDetailRequest * request =[GetGroupDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/group/%zd",request.baseUrlString,groupId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GroupListInfo class] contentClass:[GroupListInfo class] success:^(GroupListInfo * response) {
        [[WCDBManager sharedManager]updateShowName:response.name chatId:response.groupId chatType:GroupChat];
        [[WCDBManager sharedManager]updateChatSettingIsShowNickname:response.displaysGroupUserNicknames chatId:[NSString stringWithFormat:@"%zd",groupId] chatType:GroupChat];
        //置顶
        [[WCDBManager sharedManager]updateChatSettingIsStick:response.topChat chatId:[NSString stringWithFormat:@"%zd",groupId]  chatType:GroupChat authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]updateIsStick:response.topChat chatId:[NSString stringWithFormat:@"%zd",groupId]  chatType:GroupChat];
        //免打扰
        [[WCDBManager sharedManager]updateIsNoDisturbing:response.messageNotDisturb chatId:[NSString stringWithFormat:@"%zd",groupId]  chatType:GroupChat];
        [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:response.messageNotDisturb chatId:[NSString stringWithFormat:@"%zd",groupId]  chatType:GroupChat authorityType:AuthorityType_friend];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QMUITips hideAllTips];
        });
        
        [[WCDBManager sharedManager]insertOrUpdateGroupListInfoWithArray:@[response]];
        [[WCDBManager sharedManager]updateChatSettingDestoryTime:response.destructionTime chatId:response.groupId chatType:GroupChat authorityType:AuthorityType_friend];
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
/// 处理收到的删除好友通知 Notice_DeleteFriend
/// @param messageInfo messageInfo description
-(void)handleNotice_DeleteFriendWithMessage:(BaseMessageInfo*)messageInfo{
    NoticeDeleteFriendInfo*info=[NoticeDeleteFriendInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    //如果是自己删除了好友 则不发送通知
    if ([info.operatore isEqualToString:UserInfoManager.sharedManager.userId]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDeleteFriendNotification object:messageInfo.fromId];
    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
    chatModel.messageContent=[NSString decodeUrlString: messageInfo.msgContent];
    chatModel.showMessage=NSLocalizedString(@"DeleteTips", 对方把你删除);
    
    chatModel.messageFrom=info.operatore;
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = info.operatore;
    config.chatType = UserChat;
    [[WCDBManager sharedManager]updateFriendRelationWithUserId:info.operatore isFriend:NO];
    [[WCDBManager sharedManager]deleteAllChatModelWith:config];
    [[WCDBManager sharedManager]deleteResourceWihtChatId:info.operatore];
    
    [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
    [[WCDBManager sharedManager]deleteUserMessageInfoWithUserId:info.operatore];
    UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
    request.userId=info.operatore;
    request.type=@"UserAll";
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

/// 处理收到的同意添加好友请求
/// @param messageInfo messageInfo description
-(void)handleNotice_agreeFriendWithMessage:(BaseMessageInfo*)messageInfo{
    NoticeAgreeFriendInfo*deleteInfo=[NoticeAgreeFriendInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    if ([deleteInfo.process isEqualToString:@"agree"]) {//同意添加好友 更新消息新的新的好友的好友请求的列表的状态
        if ([messageInfo.platform isEqualToString:@"System"]) {
            ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
            [[WCDBManager sharedManager]updateFriendRelationWithUserId:messageInfo.toId isFriend:1];
            [[WCDBManager sharedManager]updateFriendSubscriptionIsHasReadWithSender:messageInfo.toId SubscriptionType:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:kAgreeFriendNotification object:messageInfo.toId];
            if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:)]) {
                [self.delegate webSocketManagerDidReceiveMessage:chatModel];
            }
        }else{
            [[WCDBManager sharedManager]updateFriendRelationWithUserId:deleteInfo.operatore isFriend:1];
            [[WCDBManager sharedManager]updateFriendSubscriptionIsHasReadWithSender:deleteInfo.operatore SubscriptionType:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:kAgreeFriendNotification object:messageInfo.fromId];
        }
        
    }else if ([deleteInfo.process isEqualToString:@"apply"]){//申请
        if (![messageInfo.fromId isEqualToString:[UserInfoManager sharedManager].userId]) {
            FriendSubscriptionInfo*info=[[FriendSubscriptionInfo alloc]init];
            info.sender=messageInfo.fromId;
            info.subscriptionType=2;
            info.message=deleteInfo.content;
            info.messageTime=messageInfo.sendTime;
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.sender successBlock:^(UserMessageInfo * _Nonnull uinfo) {
                if (!uinfo.isFriend) {
                    info.showName = uinfo.nickname;
                    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
                    [[WCDBManager sharedManager]insertFriendSubscriptionInfo:info];
                    if([self.delegate respondsToSelector:@selector(receivedFriendRequest)]) {
                        [self.delegate receivedFriendRequest];
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:)]) {
                        [self.delegate webSocketManagerDidReceiveMessage:chatModel];
                    }
                }
            }];
            
        }
    }
    
}
-(void)handleNotice_subjectWithMessage:(BaseMessageInfo*)messageInfo{
    NoticeSubjectInfo*deleteInfo=[NoticeSubjectInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
    chatModel.showMessage=[NSString stringWithFormat:@"%@\"%@\"",@"Group name changed to".icanlocalized,deleteInfo.subject];
    chatModel.messageFrom=deleteInfo.operatore;
    [self saveMessageWithChatModel:chatModel];
    [[WCDBManager sharedManager]updateShowName:deleteInfo.subject chatId:deleteInfo.groupId chatType:GroupChat];
    [[WCDBManager sharedManager]updateGroupNameWithGroupId:deleteInfo.groupId groupName:deleteInfo.subject];
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateGroupMessageNotification object:messageInfo.groupId userInfo:nil];
    
    
}

/// 收到用户修改群备注的通知
/// @param messageInfo messageInfo descriptio
-(void)handleNotice_groupNicknameWithMessage:(BaseMessageInfo*)messageInfo{
    if (![self.cacheMessageIds containsObject:messageInfo.messageId]) {
        NoticeUpdateGroupNicknameInfo*deleteInfo=[NoticeUpdateGroupNicknameInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
        [[WCDBManager sharedManager]updateGroupMemberInfoWihtGroupId:messageInfo.groupId userId:deleteInfo.operatore groupNickname:deleteInfo.nickname];
    }
    
}
-(void)handleNotice_TransferGroupOwnerWithMessage:(BaseMessageInfo*)messageInfo{
    Notice_TransferGroupOwnerInfo*deleteInfo=[Notice_TransferGroupOwnerInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
    //新的群主
    if ([deleteInfo.freshGroupOwner isEqualToString:[UserInfoManager sharedManager].userId]) {
        chatModel.showMessage=[NSString stringWithFormat:@"%@%@",@"You ".icanlocalized,@"BecomeNewGroupOwnerTips".icanlocalized];
        [self saveMessageWithChatModel:chatModel];
    }else{
        [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:deleteInfo.groupId userId:deleteInfo.freshGroupOwner successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
            //            BecomeNewGroupOwnerTips
            chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",memberInfo.groupRemark?:memberInfo.nickname,@"BecomeNewGroupOwnerTips".icanlocalized];
            chatModel.messageFrom=deleteInfo.operatore;
            [self saveMessageWithChatModel:chatModel];
        }];
    }
}
-(void)handleNotice_Notice_GroupRoleUpdateWithMessage:(BaseMessageInfo*)messageInfo{
    Notice_GroupRoleUpdateInfo*deleteInfo=[Notice_GroupRoleUpdateInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
    if ([deleteInfo.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
        if ([deleteInfo.groupRole isEqualToString:@"Manager"]) {
            chatModel.showMessage=[NSString stringWithFormat:@"%@%@",@"You".icanlocalized,@"BecomGroupManager".icanlocalized];
            [self saveMessageWithChatModel:chatModel];
        }else if ([deleteInfo.groupRole isEqualToString:@"Member"]){
            chatModel.showMessage=[NSString stringWithFormat:@"%@%@",@"You".icanlocalized,@"BeRemoveGroupManager".icanlocalized];
            [self saveMessageWithChatModel:chatModel];
        }
        
    }else{
        [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:deleteInfo.groupId userId:deleteInfo.userId successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
            if ([deleteInfo.groupRole isEqualToString:@"Manager"]) {
                chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",memberInfo.groupRemark?:memberInfo.nickname,@"BecomGroupManager".icanlocalized];
                chatModel.messageFrom=deleteInfo.operatorId;
                [self saveMessageWithChatModel:chatModel];
            }else if ([deleteInfo.groupRole isEqualToString:@"Member"]){
                chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",memberInfo.groupRemark?:memberInfo.nickname,@"BeRemoveGroupManager".icanlocalized];
                chatModel.messageFrom=deleteInfo.operatorId;
                [self saveMessageWithChatModel:chatModel];
            }
        }];
    }
}
#pragma mark -  收到修改阅后即焚的消息
-(void)handleNotice_destoryTimeWithMessage:(BaseMessageInfo*)messageInfo{
    NoticeDestroyTimeInfo*deleteInfo=[NoticeDestroyTimeInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:messageInfo];
    chatModel.messageFrom=deleteInfo.operatore;
    if (![deleteInfo.operatore isEqualToString:[UserInfoManager sharedManager].userId]) {
        NSString * contenStr=nil;
        NSString*destroyTime=[NSString stringWithFormat:@"%@",deleteInfo.destroyTime];
        if ([destroyTime isEqualToString:@"0"]) {
            contenStr=@"DisabledBurnAfterReadin".icanlocalized;
        }else if ([destroyTime isEqualToString:@"35"]){
            //            "turn on burn after reading (burn immediately)"="开启了阅后即焚（即刻焚毁）";
            contenStr= @"turn on burn after reading (burn immediately)".icanlocalized;
        }else if ([destroyTime isEqualToString:@"1800"]){//30分钟
            //"set burn after reading to 30 minutes"="开启了阅后即焚（30分钟）";
            contenStr= @"set burn after reading to 30 minutes".icanlocalized;
        }else if ([destroyTime isEqualToString:@"7200"]){//120分钟
            contenStr= @"set burn after reading to 120 minutes".icanlocalized;
        }else if ([destroyTime isEqualToString:@"28800"]){//8小时
            contenStr= @"set burn after reading to 8 hours".icanlocalized;
        }  else if ([destroyTime isEqualToString:@"86400"]){//24小时
            contenStr= @"set burn after reading to 24 hours".icanlocalized;
        }else if ([destroyTime isEqualToString:@"604800"]){//7天
            contenStr= @"set burn after reading to 7 days".icanlocalized;
        }else if ([destroyTime isEqualToString:@"1296000"]){//15天
            contenStr= @"set burn after reading to 15 days".icanlocalized;
        }else if ([destroyTime isEqualToString:@"2592000"]){//30天
            contenStr= @"set burn after reading to 30 days".icanlocalized;
        }else if ([destroyTime isEqualToString:@"7776000"]){//90天
            contenStr= @"set burn after reading to 90 days".icanlocalized;
        }
        
        if ([chatModel.chatType isEqualToString:GroupChat]) {
            chatModel.showMessage=[NSString stringWithFormat:@"%@%@",@"Administrator".icanlocalized,contenStr];
            [[WCDBManager sharedManager]updateChatSettingDestoryTime:[NSString stringWithFormat:@"%@",deleteInfo.destroyTime] chatId:chatModel.chatID chatType:GroupChat authorityType:AuthorityType_friend];
            [self saveMessageWithChatModel:chatModel];
        }else{
            chatModel.showMessage=[NSString stringWithFormat:@"%@%@",@"Other side".icanlocalized,contenStr];
            [[WCDBManager sharedManager]updateChatSettingDestoryTime:[NSString stringWithFormat:@"%@",deleteInfo.destroyTime] chatId:chatModel.chatID chatType:UserChat authorityType:messageInfo.authorityType];
            [self saveMessageWithChatModel:chatModel];
        }
    }
    
    
}
-(void)handleScreenNoticeMessage:(BaseMessageInfo*)screenMessageInfo{
    NoticeScreencastInfo*screenInfo=[NoticeScreencastInfo mj_objectWithKeyValues:[NSString decodeUrlString: screenMessageInfo.msgContent]];
    //如果不是自己则不处理
    if (![screenInfo.operatore isEqualToString:[UserInfoManager sharedManager].userId]) {
        ChatModel *chatModel = [self createChatModelFromBaseMessageInfo:screenMessageInfo];
        chatModel.messageFrom=screenInfo.operatore;
        if ([screenInfo.screencastMode isEqualToString:Notice_ScreencastTypeCLOSE]) {
            if ([chatModel.chatType isEqualToString:GroupChat]) {
                [[WCDBManager sharedManager]updateChatSettingTowardsisOpenTaskScreenNotice:NO chatId:chatModel.chatID chatType:GroupChat authorityType:AuthorityType_friend];
                [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:screenMessageInfo.groupId userId:screenInfo.operatore successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                    chatModel.showMessage = [NSString stringWithFormat:@"\%@ \%@ ",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,NSLocalizedString(@"Turned off screenshot notifications", 你关闭了截屏通知)];
                    [self saveMessageWithChatModel:chatModel];
                }];
            }else{
                [[WCDBManager sharedManager]updateChatSettingTowardsisOpenTaskScreenNotice:NO chatId:chatModel.chatID chatType:UserChat authorityType:screenMessageInfo.authorityType];
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:screenInfo.operatore successBlock:^(UserMessageInfo * _Nonnull info) {
                    chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",info.remarkName?:info.nickname,NSLocalizedString(@"Turned off screenshot notifications", 你关闭了截屏通知)];
                    [self saveMessageWithChatModel:chatModel];
                }];
            }
        }else if ([screenInfo.screencastMode isEqualToString:Notice_ScreencastTypeOPEN]){
            if ([chatModel.chatType isEqualToString:GroupChat]) {
                [[WCDBManager sharedManager]updateChatSettingTowardsisOpenTaskScreenNotice:YES chatId:chatModel.chatID chatType:GroupChat authorityType:AuthorityType_friend];
                [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:screenMessageInfo.groupId userId:screenInfo.operatore successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                    chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,NSLocalizedString(@"Turn on screenshot notifications", 开启了截屏通知)];
                    [self saveMessageWithChatModel:chatModel];
                }];
            }else{
                [[WCDBManager sharedManager]updateChatSettingTowardsisOpenTaskScreenNotice:YES chatId:chatModel.chatID chatType:UserChat authorityType:screenMessageInfo.authorityType];
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:screenInfo.operatore successBlock:^(UserMessageInfo * _Nonnull info) {
                    chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",info.remarkName?:info.nickname,NSLocalizedString(@"Turn on screenshot notifications", 开启了截屏通知)];
                    [self saveMessageWithChatModel:chatModel];
                }];
            }
        }else{
            if ([chatModel.chatType isEqualToString:GroupChat]) {
                [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:screenMessageInfo.groupId userId:screenInfo.operatore successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                    chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,NSLocalizedString(@"Took a screenshot during the chat", 在聊天中截屏了)];
                    [self saveMessageWithChatModel:chatModel];
                }];
            }else{
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:screenInfo.operatore successBlock:^(UserMessageInfo * _Nonnull info) {
                    chatModel.showMessage=[NSString stringWithFormat:@"\%@ \%@ ",info.remarkName?:info.nickname,NSLocalizedString(@"Took a screenshot during the chat", 在聊天中截屏了)];
                    [self saveMessageWithChatModel:chatModel];
                }];
            }
        }
    }
    
}


//处理通过接口拿到的离线消息
-(void)handleMessageOffline:(MessageOfflineInfo*)messageOfflineInfo{
    NSArray*chatOfflineList=messageOfflineInfo.chatOfflineList;
    NSArray*groupChatOfflineList=messageOfflineInfo.groupChatOfflineList;
    for (NSString*json in groupChatOfflineList) {
        [self handleReceviMessage:[BaseMessageInfo mj_objectWithKeyValues:json]];
    }
    for (NSString*json in chatOfflineList) {
        [self handleReceviMessage:[BaseMessageInfo mj_objectWithKeyValues:json]];
    }
}

-(void)showLocalNotificationwithChatModel:(ChatModel*)model{
    UIApplicationState state =[[UIApplication sharedApplication] applicationState];
    switch (state) {
            //前台运行
        case UIApplicationStateActive:{
            NSString * from=model.chatID;
            /** 消息的类型 txt img */
            NSString * msgType = model.messageType;
            ChatModel * config = [[ChatModel alloc]init];
            config.authorityType = model.authorityType;
            config.chatID = from;
            config.chatType = model.chatType;
            ChatSetting*setting=[[WCDBManager sharedManager]fetchChatSettingWith:config];
            UserConfigurationInfo*configuration=[BaseSettingManager sharedManager].userConfigurationInfo;
            //如果是接受新消息并且是非免打扰
            if (configuration.isOpenSound&&!setting.isNoDisturbing&&![self.currentChatID isEqualToString:from]&&![model.messageFrom isEqualToString:[UserInfoManager sharedManager].userId]) {
                if ([msgType isEqualToString:VoiceMessageType]||[msgType isEqualToString:TextMessageType]||[msgType isEqualToString:URLMessageType]||[msgType isEqualToString:GamifyMessageType]||[msgType isEqualToString:LocationMessageType]||[msgType isEqualToString:ImageMessageType]||[msgType isEqualToString:VideoMessageType]||[msgType isEqualToString:UserCardMessageType]||[msgType isEqualToString:Notice_AddFriendMessageType]||[msgType isEqualToString:AtSingleMessageType]||[msgType isEqualToString:AtAllMessageType]||[msgType isEqualToString:SendSingleRedPacketType]||[msgType isEqualToString:SendRoomRedPacketType]||[msgType isEqualToString:PayHelperMessageType]||[msgType isEqualToString:kChatOtherShareType]||[msgType isEqualToString:kChat_PostShare]||[msgType isEqualToString:SystemHelperMessageType]||[msgType isEqualToString:C2COrderMessageType]||[msgType isEqualToString:NoticeOTPMessageType]) {
                    [[VoicePlayerTool sharedManager] playMessageReceiverVoice];
                }
                
            }
        }
            break;
            //后台状态
        case UIApplicationStateBackground:{
//            [self setLocalNotificationwithChatModel:model];
            NSLog(@"LocalNotification");
        }
            break;
        default:
            break;
    }
}

// 设置本地推送
// @param message message
-(void)setLocalNotificationwithChatModel:(ChatModel*)model{
    __block NSString * localUserName=@"";
    __block NSString * bodyStr=@"";
    __block NSString * msgType = model.messageType;
    __block NSString * chatType=model.chatType;
    __block NSString * from=model.chatID;
    if (![model.messageFrom isEqualToString:[UserInfoManager sharedManager].userId]) {
        ChatModel * config = [[ChatModel alloc]init];
        config.authorityType = model.authorityType;
        config.chatID = from;
        config.chatType = model.chatType;
        ChatSetting*setting=[[WCDBManager sharedManager]fetchChatSettingWith:config];
        UserConfigurationInfo*configuration=[BaseSettingManager sharedManager].userConfigurationInfo;
        if (configuration.isAcceptMessageNotice&&!setting.isNoDisturbing) {
            if (configuration.isShowMessageNoticeDetail) {
                bodyStr = [self getPushBodyStr:model msgType:msgType];
                if ([chatType isEqualToString:GroupChat]) {
                    GroupListInfo*info=[[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:from];
                    localUserName=info.name?:NSLocalizedString(@"Group Chats", 群聊);
                    [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:from userId:model.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                        if ([msgType isEqualToString:AtSingleMessageType]) {
                            AtSingleMessageInfo*info=[AtSingleMessageInfo mj_objectWithKeyValues:model.messageContent];
                            if ([info.atIds containsObject:[UserInfoManager sharedManager].userId]) {
                                bodyStr=[NSString stringWithFormat:@"%@%@",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,@"@you in the group chat".icanlocalized];
                            }else{
                                bodyStr=model.showMessage;
                                bodyStr=[NSString stringWithFormat:@"%@: %@",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,bodyStr];
                            }
                            
                        }else if ([msgType isEqualToString:AtAllMessageType]){
                            bodyStr=[NSString stringWithFormat:@"%@%@",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,@"@you in the group chat".icanlocalized];
                        }else{
                            bodyStr=[NSString stringWithFormat:@"%@: %@",![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname,bodyStr];
                        }
                        [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                    }];
                }else{
                    if ([msgType isEqualToString:PayHelperMessageType]) {
                        localUserName=@"PaymentAssistant".icanlocalized;
                        [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                    }if ([msgType isEqualToString:SystemHelperMessageType]) {
                        localUserName=@"systemnotification".icanlocalized;
                        [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                    }if([msgType isEqualToString:AnnouncementHelperMessageType]){
                        localUserName=@"AnnouncementNotification".icanlocalized;
                        [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                    }else if ([msgType isEqualToString:ShopHelperMessageType]){
                        localUserName=@"Mall Assistant".icanlocalized;
                        [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                    }else if ([msgType isEqualToString:C2COrderMessageType]){
                        localUserName=@"WalletAssistant".icanlocalized;
                        [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                    } else {//是单人聊天
                        if ([model.authorityType isEqualToString:AuthorityType_circle]) {//是交友的聊天
                            [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithIcanId:from successBlock:^(CircleUserInfo * _Nonnull info) {
                                localUserName=info.nickname;
                                [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                            }];
                        }else{
                            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:from successBlock:^(UserMessageInfo * _Nonnull info) {
                                if ([model.authorityType isEqualToString:AuthorityType_secret]) {
                                    bodyStr=@"You received a private message".icanlocalized;
                                    localUserName=@"";
                                }else{
                                    localUserName=info.remarkName?:info.nickname;
                                }
                            }];
                            [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
                        }
                        
                    }
                    
                }
                
            }else{
                bodyStr=NSLocalizedString(@"You received a new message", 你收到了一条新消息);
                localUserName=@"";
                [LocalNotificationManager setLacalNotificationWithTitle:bodyStr user:localUserName value:model.message];
            }
            
        }
    }
    
    
}
-(NSString*)getPushBodyStr:(ChatModel*)model msgType:(NSString*)msgType{
    __block NSString * bodyStr=@"";
    if ([msgType isEqualToString:TextMessageType]) {
        bodyStr = model.showMessage;
    } else if([msgType isEqualToString:GamifyMessageType]){
        bodyStr = NSLocalizedString(@"GameTips",[ 语音]);
    }else if ([msgType isEqualToString:URLMessageType]){
        bodyStr = [NSString stringWithFormat:@"[%@]",@"showReceiveUrlTip".icanlocalized];
    }else if ([msgType containsString:VoiceMessageType]) {
        bodyStr =  NSLocalizedString(@"VoiceTips",[ 语音]);
    }else if ([msgType isEqualToString:ImageMessageType]) {
        bodyStr = NSLocalizedString(@"ImageTips",[ 图片 ]);
    }else if ([msgType isEqualToString:LocationMessageType]){
        bodyStr = [NSString stringWithFormat:@"[%@]",NSLocalizedString(@"Location", 位置)];
    }else if([msgType isEqualToString:UserCardMessageType]){
        bodyStr = NSLocalizedString(@"ContactCardTips",[ 名片 ]);
    }else if ([msgType isEqualToString:FileMessageType]){
        bodyStr = NSLocalizedString(@"FileTips",[ 文件 ]);
    }else if ([msgType isEqualToString:kChatOtherShareType]){
        bodyStr = [NSString stringWithFormat:@"%@",@"Commodity sharing".icanlocalized];
    }else if ([msgType isEqualToString:kChat_PostShare]){
        bodyStr = [NSString stringWithFormat:@"%@",@"notification.sharedpost".icanlocalized];
    }else if ([msgType isEqualToString:ShopHelperMessageType]){
        ShopHelperMsgInfo*info=[ShopHelperMsgInfo mj_objectWithKeyValues:model.messageContent];
        bodyStr = [NSString stringWithFormat:@"%@",info.title];
    } else if ([msgType isEqualToString:SendSingleRedPacketType]){
        SingleRedPacketMessageInfo*singleRedPacketInfo=[SingleRedPacketMessageInfo mj_objectWithKeyValues:model.messageContent];
        bodyStr = [NSString stringWithFormat:@"[%@]%@",@"chatView.function.redPacket".icanlocalized,singleRedPacketInfo.comment];
    } else if ([msgType isEqualToString:SendRoomRedPacketType]){
        SingleRedPacketMessageInfo*singleRedPacketInfo=[SingleRedPacketMessageInfo mj_objectWithKeyValues:model.messageContent];
        bodyStr = [NSString stringWithFormat:@"[%@]%@",@"chatView.function.redPacket".icanlocalized,singleRedPacketInfo.comment];
    }else if ([msgType isEqualToString:SystemHelperMessageType]){
        SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.messageContent]];
        if ([removeChatInfo.type isEqualToString:@"UserAuthPass"]) {
            bodyStr=@"Authed".icanlocalized;
        }else if ([removeChatInfo.type isEqualToString:@"UserAuthFail"]) {
            bodyStr=@"Authenticationfailed".icanlocalized;
        }else if ([removeChatInfo.type isEqualToString:@"Other"]) {
            bodyStr=@"Other".icanlocalized;
        }
    }else if([msgType isEqualToString:AnnouncementHelperMessageType]){
        SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.messageContent]];

    }else if ([msgType isEqualToString:PayHelperMessageType]){
        
        PayHelperMsgInfo*removeChatInfo=[PayHelperMsgInfo mj_objectWithKeyValues:[NSString decodeUrlString: model.messageContent]];
        
        if ([removeChatInfo.payType isEqualToString:@"Transfer"]) {
            bodyStr=@"Transfer To Account".icanlocalized;
            
        }else if ([removeChatInfo.payType isEqualToString:@"RefundSingleRedPacket"]||[removeChatInfo.payType isEqualToString:@"RefundRoomRedPacket"]) {
            bodyStr=@"red packet Returned".icanlocalized;
            
        }else if ([removeChatInfo.payType isEqualToString:@"MobileRecharge"]) {
            bodyStr=@"Mobile Phone Recharge To Account".icanlocalized;
            
        }else if ([removeChatInfo.payType isEqualToString:@"GiftCard"]) {
            bodyStr=@"Gift Card Purchase".icanlocalized;
            
        }else if ([removeChatInfo.payType isEqualToString:@"BalanceRecharge"]) {
            bodyStr=@"Top Up Received".icanlocalized;
            
        }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_CREATE"]) {
            bodyStr=@"Withdrawal application".icanlocalized;
            
        }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_SUCCESS"]) {
            bodyStr=@"Successful withdrawal".icanlocalized;
            
        }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_FAIL"]) {
            bodyStr=@"Withdrawal failed".icanlocalized;
        }else if ([removeChatInfo.payType isEqualToString:@"Payment"]){
            if ([removeChatInfo.amount containsString:@"-"]) {
                bodyStr=@"Payment successful".icanlocalized;
            }else{
                bodyStr=@"Successfully Received".icanlocalized;
            }
            
        }else if ([removeChatInfo.payType isEqualToString:@"ReceivePayment"]){
            if ([removeChatInfo.amount containsString:@"-"]) {
                bodyStr=@"Payment successful".icanlocalized;
                
            }else{
                bodyStr=@"Successfully Received".icanlocalized;
                
            }
        }else if ([removeChatInfo.payType isEqualToString:@"Dialog"]){
            bodyStr=@"Top-upSuccess".icanlocalized;;
        }else if([removeChatInfo.payType isEqualToString:@"MomentEarnings"]){
            //"PostingIncome"="发帖收益";
            //        "AmountofEarnings"="收益金额";
            bodyStr=@"PostingIncome".icanlocalized;
        }
        
    }else if ([msgType isEqualToString:C2COrderMessageType]){
        C2COrderMessageInfo*msgInfo=[C2COrderMessageInfo mj_objectWithKeyValues:model.messageContent];
        
        if ([msgInfo.status isEqualToString:@"Unpaid"]) {
            bodyStr = @"C2COrderStateUnpaid".icanlocalized;
        }else if ([msgInfo.status isEqualToString:@"Paid"]) {
            bodyStr = @"C2COrderStatePaid".icanlocalized;
        }else if ([msgInfo.status isEqualToString:@"Appeal"]) {
            bodyStr = @"C2COrderStateAppeal".icanlocalized;
        }else if ([msgInfo.status isEqualToString:@"Completed"]) {
            bodyStr = @"C2COrderStateCompleted".icanlocalized;
        }else if ([msgInfo.status isEqualToString:@"Cancelled"]) {
            bodyStr = @"C2COrderStateCancelled".icanlocalized;
        }
    }
    return bodyStr;
}
-(void)getThumbnailDetailsofUrlMsg:(ChatModel *)textModel{
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detector matchesInString:textModel.showMessage options:0 range:NSMakeRange(0, [textModel.showMessage length])];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *emailMatches = [regex matchesInString:textModel.showMessage options:0 range:NSMakeRange(0, textModel.showMessage.length)];
    if (matches.count > 0 && emailMatches.count == 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [matches[0] valueForKeyPath:@"_url"];
            WBGLinkPreview *urlPreview;
            urlPreview = [[WBGLinkPreview alloc] init];
            [urlPreview previewWithText:url.absoluteString
                              onSuccess:^(NSDictionary *result) {
                if([result[@"title"] isEqualToString:@"YouTube"]){
                    NSString *youtubeUrl = url.absoluteString;
                    NSArray *Array;
                    NSString *videoId;
                    if([result[@"url"] containsString:@"/www.youtube.com/"]){
                        Array = [youtubeUrl componentsSeparatedByString:@"="];
                        videoId = [Array objectAtIndex:1];
                    }else if ([result[@"url"] containsString:@"/youtu.be/"]){
                        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"youtu\\.be\\/(.+?)\\?" options:NSRegularExpressionCaseInsensitive error:nil];
                        NSTextCheckingResult *match = [regex firstMatchInString:youtubeUrl options:0 range:NSMakeRange(0, [youtubeUrl length])];
                        if (match) {
                            NSRange videoIDRange = [match rangeAtIndex:1];
                            videoId = [youtubeUrl substringWithRange:videoIDRange];
                        } else {
                            NSLog(@"Video ID not found");
                        }
                    }
                    NSString *urlString = [@"https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAkeoMi-GD1Xaso9Z6l3wVVQcWO-m8tmqw&part=snippet&id=" stringByAppendingFormat:@"%@",videoId];
                    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
                    [urlRequest setHTTPMethod:@"GET"];
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        if(httpResponse.statusCode == 200){
                            NSError *parseError = nil;
                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                            NSArray *responseItemsArray = [responseDictionary valueForKeyPath:@"items"];
                            if(responseItemsArray.count > 0){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    textModel.thumbnailTitleofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.localized.title"][0];
                                    textModel.thumbnailImageurlofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.thumbnails.medium.url"][0];
                                    [[WCDBManager sharedManager]updateMessageContentByMessageId:textModel];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
                                });
                            }
                        }
                    }];
                    [dataTask resume];
                }
                else{
                    if(![result[@"title"]  isEqual: @""] && ![result[@"image"] isEqual:@""] && ![result[@"image"] isEqual:@"undefined"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            textModel.thumbnailTitleofTextUrl = result[@"title"];
                            textModel.thumbnailImageurlofTextUrl = result[@"image"];
                            [[WCDBManager sharedManager]updateMessageContentByMessageId:textModel];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
                        });
                    }
                }
            } onError:^(WBGPreviewError *error) {
            }];
        });
    }
}
//****** For the future use I have commented below lines *****//
//-(void)getThumbnailDetailsofUrlMsg:(ChatModel *)chatModel{
//    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
//    NSArray *matches = [detector matchesInString:chatModel.showMessage options:0 range:NSMakeRange(0, [chatModel.showMessage length])];
//
//    WBGLinkPreview *urlPreview;
//    urlPreview = [[WBGLinkPreview alloc] init];
//    NSURL *url = [matches[0] valueForKeyPath:@"_url"];
//    [urlPreview previewWithText:url.absoluteString
//                      onSuccess:^(NSDictionary *result) {
//        if([result[@"title"] isEqualToString:@"YouTube"]){
//            NSString *youtubeUrl = url.absoluteString;
//            NSArray *Array;
//            NSString *videoId;
//            if([result[@"url"] containsString:@"/www.youtube.com/"]){
//                Array = [youtubeUrl componentsSeparatedByString:@"="];
//                videoId = [Array objectAtIndex:1];
//            }
//            else if ([result[@"url"] containsString:@"/youtu.be/"]){
//                Array = [youtubeUrl componentsSeparatedByString:@"https://youtu.be/"];
//                videoId = [Array objectAtIndex:1];
//            }
//            NSString *urlString = [@"https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAkeoMi-GD1Xaso9Z6l3wVVQcWO-m8tmqw&part=snippet&id=" stringByAppendingFormat:@"%@",videoId];
//            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//            [urlRequest setHTTPMethod:@"GET"];
//            NSURLSession *session = [NSURLSession sharedSession];
//            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
//                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//                if(httpResponse.statusCode == 200){
//                    NSError *parseError = nil;
//                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//                    NSArray *responseItemsArray = [responseDictionary valueForKeyPath:@"items"];
//                    if(responseItemsArray.count > 0){
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            chatModel.thumbnailTitleofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.localized.title"][0];
//                            chatModel.thumbnailImageurlofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.thumbnails.medium.url"][0];
//                            [self saveMessageWithChatModel:chatModel];
//                            [self showLocalNotificationwithChatModel:chatModel];
//                        });
//                    }
//                    else{
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            chatModel.thumbnailTitleofTextUrl = nil;
//                            chatModel.thumbnailImageurlofTextUrl = nil;
//                            [self saveMessageWithChatModel:chatModel];
//                            [self showLocalNotificationwithChatModel:chatModel];
//                        });
//                    }
//                }
//                else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        chatModel.thumbnailTitleofTextUrl = nil;
//                        chatModel.thumbnailImageurlofTextUrl = nil;
//                        [self saveMessageWithChatModel:chatModel];
//                        [self showLocalNotificationwithChatModel:chatModel];
//                    });
//                }
//            }];
//            [dataTask resume];
//        }
//        else{
//            if(![result[@"title"]  isEqual: @""] && ![result[@"image"] isEqual:@""] && ![result[@"image"] isEqual:@"undefined"]){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    chatModel.thumbnailTitleofTextUrl = result[@"title"];
//                    chatModel.thumbnailImageurlofTextUrl = result[@"image"];
//                    [self saveMessageWithChatModel:chatModel];
//                    [self showLocalNotificationwithChatModel:chatModel];
//                });
//            }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    chatModel.thumbnailTitleofTextUrl = nil;
//                    chatModel.thumbnailImageurlofTextUrl = nil;
//                    [self saveMessageWithChatModel:chatModel];
//                    [self showLocalNotificationwithChatModel:chatModel];
//                });
//            }
//        }
//    } onError:^(WBGPreviewError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            chatModel.thumbnailTitleofTextUrl = nil;
//            chatModel.thumbnailImageurlofTextUrl = nil;
//            [self saveMessageWithChatModel:chatModel];
//            [self showLocalNotificationwithChatModel:chatModel];
//        });
//        NSLog(@"%@", error.description);
//    }];
//}
@end
