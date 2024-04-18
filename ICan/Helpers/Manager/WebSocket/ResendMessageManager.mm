//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 2/11/2020
 - File name:  ResendMessageManager.m
 - Description:
 - Function List:
 */


#import "ResendMessageManager.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import "WebSocketManager.h"
#import "OSSWrapper.h"
@implementation ResendMessageManager
+ (instancetype)sharedManager {
    static ResendMessageManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[ResendMessageManager alloc] init];
        api.currentSendingMsgs=[NSMutableArray array];
        
    });
    return api;
}

/// 开始重发消息
-(void)startResendMessage{
    [self.currentSendingMsgs removeAllObjects];
    /**
     1:获取所有发送中的消息
     */
    self.currentSendingMsgs=[NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchAllSendingMessage]];
    self.currentSendingFailedMsgs=[NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchAllSendingFailedMessage]];
    for(ChatModel*modelFailed in self.currentSendingFailedMsgs) {
        [self.currentSendingMsgs addObject:modelFailed];
    }
    for (ChatModel*model in self.currentSendingMsgs) {
        NSString*msgType=model.messageType;
        if ([msgType isEqualToString:TextMessageType]|| [msgType isEqualToString:URLMessageType]||[msgType isEqualToString:UserCardMessageType]) {
            model.messageTime=[NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            [[WCDBManager sharedManager]insertChatModel:model];
            [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
        }else if ([msgType isEqualToString:VoiceMessageType]){
            model.messageTime=[NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            [self sendVoice:model];
        }else if ([msgType isEqualToString:kChat_PostShare]){
            model.messageTime=[NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            [[WCDBManager sharedManager] saveChatListModelWithChatModel:model];
            [[WCDBManager sharedManager]insertChatModel:model];
            [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
            
        }else if ([msgType isEqualToString:kChatOtherShareType]||[msgType isEqualToString:LocationMessageType]){
            model.messageTime=[NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            [[WCDBManager sharedManager] saveChatListModelWithChatModel:model];
            [[WCDBManager sharedManager]insertChatModel:model];
            [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
        }
        
    }
    
}
-(void)sendVoice:(ChatModel*)model{
    if (model.uploadState!=1) {
        [[[OSSWrapper alloc]init] uploadVoiceWithChatModel:model uploadProgress:^(NSString * _Nonnull progress, ChatModel * _Nonnull chatModel) {
            
        } success:^(ChatModel * _Nonnull chatModel) {
            VoiceMessageInfo*info=[[VoiceMessageInfo alloc]init];
            info.content=chatModel.fileServiceUrl;
            info.duration=chatModel.mediaSeconds;
            model.messageContent=[info mj_JSONString];
            [[WCDBManager sharedManager]insertChatModel:chatModel];
            [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
            [[WCDBManager sharedManager]saveChatListModelWithChatModel:model];
        } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        }];
    }else{
        [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
        [[WCDBManager sharedManager]saveChatListModelWithChatModel:model];
    }
    
}
@end
