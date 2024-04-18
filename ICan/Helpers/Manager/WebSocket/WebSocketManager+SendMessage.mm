
//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/3
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  WebSocketManager+SendMessage.m
 - Description:
 - Function List:
 - History:
 */


#import "WebSocketManager+SendMessage.h"
#import "STOMPMacro.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "ChatModel.h"
@implementation WebSocketManager (SendMessage)
- (NSString*)createSendMessageWithChatModel:(ChatModel*)model {
    BaseMessageInfo*messageInfo = [[BaseMessageInfo alloc]init];
    messageInfo.msgContent = [NSString encodedUrlString:model.messageContent];
    messageInfo.messageId = model.messageID;
    messageInfo.msgType = model.messageType;
    messageInfo.chatMode = model.chatMode;
    messageInfo.sendTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]*1000];
    /**
     私聊的时间是120分钟 7200秒
     */
    messageInfo.authorityType = model.authorityType;
    if (model.authorityType == AuthorityType_secret) {
        messageInfo.destroy = 7200;
    }else{
        messageInfo.destroy = model.destoryTime?[model.destoryTime intValue]:0;
    }
    if (model.circleUserId) {
        messageInfo.fromCircleUserId=[CircleUserInfoManager shared].userId;
    }
    if (model.c2cUserId&&model.c2cOrderId) {
        //c2cUserId当前登录用户的c2cUserId
        messageInfo.extra = @{@"orderId":model.c2cOrderId,@"c2cUserId":C2CUserManager.shared.userId}.mj_JSONString;
    }
    messageInfo.fromId = [UserInfoManager sharedManager].userId;
    messageInfo.platform=@"APP";
    if ([model.messageType isEqualToString:Notice_PayQRType]) {
        messageInfo.endurance = false;
    }else{
        messageInfo.endurance = true;
    }
    //如果是群聊 则存在群聊ID
    if ([model.chatType isEqualToString:GroupChat]) {
        messageInfo.groupId = model.chatID;
    }
    if ([model.chatType isEqualToString:UserChat]) {
        messageInfo.toId = model.chatID;
    }
    if([model.messageType isEqualToString:@"Pin_Message"] || [model.messageType isEqualToString:ReactionMessage]){
        messageInfo.toId = model.messageTo;
    }
    return messageInfo.mj_JSONString;
}

-(void)sendMessageWithJsonString:(NSString*)jsonString chatType:(NSString*)chatType{
    if ([chatType isEqualToString:UserChat]) {
         [[WebSocketManager sharedManager] sendPersonChatMessage:jsonString];
     }else {
         [[WebSocketManager sharedManager] sendGroupMessage:jsonString];
     }
}

- (void)sendMessageWithChatModel:(ChatModel *)model {
    NSString *jsonString = [self createSendMessageWithChatModel:model];
    if([model.chatType isEqualToString:UserChat]) {
        [[WebSocketManager sharedManager] sendPersonChatMessage:jsonString];
    }else {
        if([model.messageType isEqualToString:@"Pin_Message"]) {
            NSData *data = [model.messageContent dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *msgContent = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if([[msgContent objectForKey:@"audience"] isEqualToString:@"Self"]) {
                [[WebSocketManager sharedManager] sendPersonChatMessage:jsonString];
            }else {
                [[WebSocketManager sharedManager] sendGroupMessage:jsonString];
            }
        }else {
            [[WebSocketManager sharedManager] sendGroupMessage:jsonString];
        }
    }
}

#pragma mark -- 发送单聊天消息
-(void)sendPersonChatMessage:(NSString *)chatContent {
    [self.client sendTo:SendPersonMessage body:chatContent];
}

#pragma mark -- 群聊发消息
-(void)sendGroupMessage:(NSString *)msg {
    [self.client sendTo:SendGroupMessage body:msg];
}
//收到基本类型的消息发送已读回执
-(void)sendHasRedMessageReceipt:(ChatModel*)model{
    ChatModel*receipModel=[[ChatModel alloc]init];
    receipModel.messageTo=model.messageFrom;
    receipModel.messageFrom=[UserInfoManager sharedManager].userId;
    receipModel.isOutGoing=YES;
    receipModel.chatType=UserChat;
    receipModel.messageID=model.messageID;
    receipModel.messageType=ReceiptMessageType;
    receipModel.chatID=model.messageFrom;
    receipModel.authorityType=model.authorityType;
    ReceiptMessageInfo*info=[[ReceiptMessageInfo alloc]init];
    info.receiptStatus=ReceiptREAD;
    receipModel.messageContent=[info mj_JSONString];
    [[WebSocketManager sharedManager]sendMessageWithChatModel:receipModel];
}
//收到基本类型的消息发送已收到回执
-(void)sendHasReceiveMessageReceiptWithChatModel:(ChatModel*)model{
    ChatModel*receipModel=[[ChatModel alloc]init];
    receipModel.messageTo=model.messageFrom;
    receipModel.messageFrom=[UserInfoManager sharedManager].userId;
    receipModel.isOutGoing=YES;
    receipModel.chatType=UserChat;
    receipModel.messageID=model.messageID;
    receipModel.messageType=ReceiptMessageType;
    receipModel.chatID=model.messageFrom;
    receipModel.authorityType=model.authorityType;
    ReceiptMessageInfo*info=[[ReceiptMessageInfo alloc]init];
    info.receiptStatus=ReceiptRECEIVE;
    receipModel.messageContent=[info mj_JSONString];
    [[WebSocketManager sharedManager]sendMessageWithChatModel:receipModel];
}
//收到群聊基本类型的消息发送已读回执
-(void)sendGroupHasReadMessageReceiptWithChatModel:(ChatModel*)model{
    ChatModel*receipModel=[[ChatModel alloc]init];
    receipModel.messageTo=model.messageFrom;
    receipModel.messageFrom=[UserInfoManager sharedManager].userId;
    receipModel.isOutGoing=YES;
    receipModel.chatType=UserChat;
    receipModel.messageID=model.messageID;
    receipModel.messageType=ReceiptGroupMessageType;
    receipModel.chatID=model.messageFrom;
    receipModel.authorityType=model.authorityType;
    ChatGroupReceiptInfo*info=[[ChatGroupReceiptInfo alloc]init];
    info.userId=[UserInfoManager sharedManager].userId;
    info.groupId=model.chatID;
    receipModel.messageContent=[info mj_JSONString];
    [[WebSocketManager sharedManager]sendMessageWithChatModel:receipModel];
}
@end
