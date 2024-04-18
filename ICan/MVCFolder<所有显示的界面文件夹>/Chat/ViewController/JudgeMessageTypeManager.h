//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/11/2020
- File name:  JudgeMessageType.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JudgeMessageTypeManager : NSObject
+(instancetype)shareManager;

/// 在进入ChatViewController的时候 发送已读消息回执
/// @param model model description
+(void)checkShouldSendHasReadMessageReceipt:(ChatModel*)model;

/// 是否播放消息发送成功的声音
/// @param receiptInfo receiptInfo description
/// @param messageItems messageItems description
/// @param tableView tableView description
+(void)checkShoulPlaySendMessageSuccessVoice:(ReceiptInfo*)receiptInfo messageItems:(NSArray*)messageItems  tableView:(UITableView*)tableView;

/// 当在ChatViewController页面的时候 收到消息 是否发送已读回执
/// @param model model description
+(void)checkShouldSendHasReadMessageReceiptWhenReceiveMessage:(ChatModel*)model;


@end

NS_ASSUME_NONNULL_END
