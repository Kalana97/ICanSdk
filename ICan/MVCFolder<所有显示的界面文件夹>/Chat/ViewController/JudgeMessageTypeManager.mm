//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/11/2020
- File name:  JudgeMessageType.m
- Description:
- Function List:
*/
        

#import "JudgeMessageTypeManager.h"
#import "WCDBManager+ChatModel.h"
#import "VoicePlayerTool.h"
@implementation JudgeMessageTypeManager
+ (instancetype)shareManager{
    static JudgeMessageTypeManager*tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool=[[JudgeMessageTypeManager alloc]init];
    });
    return tool;
}
+(void)checkShouldSendHasReadMessageReceipt:(ChatModel*)model{
    NSString*msgType=model.messageType;
    //只有是未读的并且是收到的消息才发送消息已读回执
    if (!model.hasRead&&!model.isOutGoing) {
        if ([msgType isEqualToString:TextMessageType]||[msgType isEqualToString:GamifyMessageType]||[msgType isEqualToString:FileMessageType]||[msgType isEqualToString:URLMessageType]||[msgType isEqualToString:ImageMessageType]||[msgType isEqualToString:UserCardMessageType]||[msgType isEqualToString:TransFerMessageType]||[msgType isEqualToString:AtAllMessageType]||[msgType isEqualToString:AtSingleMessageType]||[msgType isEqualToString:VoiceMessageType]||[msgType isEqualToString:SendSingleRedPacketType]||[msgType isEqualToString:SendRoomRedPacketType]||[msgType isEqualToString:LocationMessageType]||[msgType isEqualToString:kChat_PostShare]||[msgType isEqualToString:kChatOtherShareType]) {
            model.hasRead=YES;
            //更新消息为已读
            [[WCDBManager sharedManager]updateMessageIsHasReadWithMessageId:model.messageID];
            //发送消息已读回执
            if ([model.chatType isEqualToString:GroupChat]) {
                [[WebSocketManager sharedManager]sendGroupHasReadMessageReceiptWithChatModel:model];
            }else {
                [[WebSocketManager sharedManager]sendHasRedMessageReceipt:model];
            }
            
        }
        
    }
}
+(void)checkShoulPlaySendMessageSuccessVoice:(ReceiptInfo*)receiptInfo messageItems:(NSArray*)messageItems  tableView:(UITableView*)tableView{
    for (ChatModel*model in messageItems) {
        if ([model.messageID isEqualToString:receiptInfo.msgId]) {
            if ([receiptInfo.msgType isEqualToString:VoiceMessageType]||[receiptInfo.msgType isEqualToString:TextMessageType]||[receiptInfo.msgType isEqualToString:URLMessageType]||[receiptInfo.msgType isEqualToString:GamifyMessageType]||[receiptInfo.msgType isEqualToString:LocationMessageType]||[receiptInfo.msgType isEqualToString:ImageMessageType]||[receiptInfo.msgType isEqualToString:VideoMessageType]||[receiptInfo.msgType isEqualToString:UserCardMessageType]||[receiptInfo.msgType isEqualToString:FileMessageType]||[receiptInfo.msgType isEqualToString:AtSingleMessageType]||[receiptInfo.msgType isEqualToString:AtAllMessageType]||[receiptInfo.msgType isEqualToString:kChat_PostShare]||[receiptInfo.msgType isEqualToString:kChatOtherShareType]) {
                [[VoicePlayerTool sharedManager]playSendMessageSuccessVoice];
                model.sendState=1;
                [tableView reloadData];
                NSIndexPath*index=[NSIndexPath indexPathForRow:messageItems.count -1 inSection:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                });
            }else{
                model.sendState=1;
                [tableView reloadData];
                NSIndexPath*index=[NSIndexPath indexPathForRow:messageItems.count -1 inSection:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                });
            }

            break;
        }
    }
    
}

+(void)checkShouldSendHasReadMessageReceiptWhenReceiveMessage:(ChatModel*)model{
    NSString*msgType=model.messageType;
    if ([msgType isEqualToString:VoiceMessageType]||[msgType isEqualToString:TextMessageType]||[msgType isEqualToString:URLMessageType]||[msgType isEqualToString:GamifyMessageType]||[msgType isEqualToString:LocationMessageType]||[msgType isEqualToString:ImageMessageType]||[msgType isEqualToString:VideoMessageType]||[msgType isEqualToString:UserCardMessageType]||[msgType isEqualToString:FileMessageType]||[msgType isEqualToString:AtAllMessageType]||[msgType isEqualToString:AtSingleMessageType]||[msgType isEqualToString:TransFerMessageType]||[msgType isEqualToString:SendSingleRedPacketType]) {
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateActive){
            [[WCDBManager sharedManager]updateMessageIsHasReadWithMessageId:model.messageID];
            if ([model.chatType isEqualToString:GroupChat]) {
                [[WebSocketManager sharedManager]sendGroupHasReadMessageReceiptWithChatModel:model];
            }else{
                [[WebSocketManager sharedManager]sendHasRedMessageReceipt:model];
            }
        }else{
            [[WCDBManager sharedManager]updateMessageIsHasReadWithMessageId:model.messageID];
            [[WebSocketManager sharedManager]sendHasRedMessageReceipt:model];
        }
    }
}

@end
