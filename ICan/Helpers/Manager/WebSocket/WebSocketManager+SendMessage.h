//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/10/3
- System_Version_MACOS: 10.14
- EasyPay
- File name:  WebSocketManager+SendMessage.h
- Description:
- Function List: 
- History:
*/
        


#import "WebSocketManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketManager (SendMessage)

/// 创建需要发送的json字符串
/// @param model model description
-(NSString*)createSendMessageWithChatModel:(ChatModel*)model;

/// 发送消息
/// @param jsonString 消息体
/// @param chatType 群聊还是单聊
-(void)sendMessageWithJsonString:(NSString*)jsonString chatType:(NSString*)chatType;
-(void)sendMessageWithChatModel:(ChatModel*)model;

/// 发送已收到消息回执
/// @param model model description
-(void)sendHasReceiveMessageReceiptWithChatModel:(ChatModel*)model;
//收到基本类型的消息发送已收到回执
-(void)sendHasRedMessageReceipt:(ChatModel*)model;
-(void)sendGroupHasReadMessageReceiptWithChatModel:(ChatModel*)model;
@end

NS_ASSUME_NONNULL_END
