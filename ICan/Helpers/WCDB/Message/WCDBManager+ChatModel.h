//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 17/9/2019
- File name:  WCDBManager+ChatModel.h
- Description: 处理消息
- Function List:
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "WCDBManager.h"
#import "ChatModel.h"
//NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (ChatModel)

/// 插入多条数据
/// @param chatModels chatModels description
- (void)insertChatModels:(NSArray<ChatModel*>*)chatModels;
/**
 插入某条数据
 @param chatModel chatModel description
 */
- (void)insertChatModel:(ChatModel *)chatModel;
/// 删除某个回话的消息
/// @param chatId 回话ID
/// @param chatType 回话类型
/// @param isSecret 是否是密聊
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
- (NSArray<NSString *> *)getMessageIdsByMessageType:(NSString*)messageType;
- (void)deleteAllChatModelWith:(ChatModel*)config;
/// 删除某条消息
/// @param messageId messageId description
- (void)deleteOneChatModelWithMessageId:(NSString*)messageId;
- (NSArray<ChatModel*>*)fetchChatModelMessageWihtConfigModel:(ChatModel*)configModel offset:(NSInteger)offset;
/// 查询某段时间的之前的的消息
/// @param chatID chatID description
/// @param messageTime 时间戳
/// @param chatType chatType description
- (NSArray<ChatModel*>*)fetchHistoryMessageWihtChatId:(NSString *)chatID messageTime:(NSString*)messageTime chatType:(NSString*)chatType;
/// 获取某个会话ID的某个会话的全部类型
/// @param chatID chatID description
/// @param chatType chatType description
- (NSArray<ChatModel*>*)fetchAllMessageWihtChatModel:(ChatModel *)config;
/// 查询媒体类型的消息（图片和视频）
/// @param chatID chatID description
- (NSArray<ChatModel*>*)fetchMediaChatModelWihtChatId:(NSString *)chatID chatType:(NSString*)chatType;
/// 查询支付组手消息
/// @param offset offset description
- (NSArray<ChatModel*>*)fetchPayHelperMessageTypewithoffset:(NSInteger)offset;
/// 查询c2c钱包组手消息
/// @param offset offset description
- (NSArray<ChatModel*>*)fetchC2CHelperMessageTypewithoffset:(NSInteger)offset;
/// 获取系统通知的消息
/// @param offset offset description
- (NSArray<ChatModel*>*)fetchSystemHelperMessageTypeWithoffset:(NSInteger)offset;
/// 根据消息ID查询本地是否存在某条消息/// @param offset offset description
- (NSArray<ChatModel*>*)fetchAnnouncementHelperMessageTypeWithoffset:(NSInteger)offset;
- (NSArray<ChatModel*>*)fetchDynamicHelperMessageTypeWithoffset:(NSInteger)offset chatID:(NSString*)chatId;
- (NSArray<ChatModel*>*)fetchDynamicHelperMessageTypeWithoutOffset;
- (NSArray<ChatModel*>*)fetchNoticeOTPMessageTypeWithoffset:(NSInteger)offset;
/// 根据消息ID查询本地是否存在某条消息
/// @param messageId 消息ID
- (BOOL)fetchLocalHaveChatModelWithMessageId:(NSString*)messageId;
- (NSArray<ChatModel*>*)fetchShopHelperMessageTypewithoffset:(NSInteger)offset;
/// 更新消息的发送状态为成功 也就是服务器收到
/// @param messageId 消息ID
- (void)updateChatModelIsSuccessSendWithMessageId:(NSString*)messageId;
- (void)updateMessageContentByMessageId:(ChatModel*)chatModel;
/// 更新消息的回执状态
/// //Chat_receipt RECEIVE("对方已收到")READ("对方已读", 1);
/// @param chatModel chatModel description
- (void)updateChatModelReceiptStatus:(BaseMessageInfo*)chatModel;
- (void)updateGamificationStatusWithChatModel:(ChatModel*)chatModel ;
- (void)updateTrueGamificationStatusWithChatModel:(ChatModel*)chatModel ;
// For message pin status
- (void)updatePinStatusWithChatId:(NSString*)messageId isPin:(BOOL)isPin isOther:(BOOL)isOther pinAudiance:(NSString *)pinAudiance;
- (NSArray<ChatModel*>*)getPinMessageWithChatModel:(NSString*)chatId;
/// 更新群聊有多少个人已读
/// @param chatModel chatModel description
- (void)updateGroupChatModelReceiptStatus:(BaseMessageInfo*)baseMessageInfo;
/// 更新消息的已读状态
/// 只有是未读的并且是收到的消息才发送消息已读回执 更新收到的消息的状态为已读
/// 1：收到的语音是否已读
/// @param messageId 消息ID
- (void)updateMessageIsHasReadWithMessageId:(NSString*)messageId;
- (void)updateVoiceMessageHasReadFromMessageId:(NSString *)messageId;
/// 根据消息类型计算高度
/// @param model model description
- (void)calculateChatModelWidthAndHeightWithChatModel:(ChatModel*)model;
/// 删除超过某段时间的消息
/// @param time time description
- (void)deleteMessageWihtTime:(NSInteger)time;
/// 删除所有的交友消息
- (void)deleteAllCircleMessage;
/// 撤回消息的时候 把消息类型设置Chat_withdraw+原消息模型
/// @param chatModel chatModel description
- (void)updateMessageTypeWithChatModel:(ChatModel*)chatModel;
/// 更新消息格式为撤回类型
/// @param messageId messageId description
- (void)updateMessageTypeWithMessageId:(NSString*)messageId;
/// 根据会话ID查询本地正在发送中的消息
/// @param chatId chatId description
- (NSArray*)fetchAllSendingMessageWithChatId:(NSString*)chatId;
/// 查询所有的发送中的消息
- (NSArray*)fetchAllSendingMessage;
- (NSArray*)fetchAllSendingFailedMessage;
/// 更新消息的状态为发送失败
- (void)updateSendingMessageSendStateToFail;
/// 翻译成功之后，更新长度以及保存翻译过后的消息
/// @param cmodel cmodel description
- (void)updateTranslateWithChatmodel:(ChatModel*)cmodel;
/// 如果在这里存在messageid的时候，那么需要把本地的消息改成 对方删除了一条消息
/// 通过消息ID把消息类型设置为
/// @param msgId 消息ID
- (void)updateMsgTypeToNoticeRemoveChatTypeWithMessageId:(NSString*)msgId;
#pragma mark - 红包相关
/// 更新领取单人红包成功
/// @param redPacketModel redPacketModel description
- (void)updateSingleRedPacketMessagStateByModel:(ChatModel*)redPacketModel;
/// 更新红包的状态
/// @param redId 红包ID
/// @param showRedState showRedState description
- (void)updateSingleRedPacketShowRedStateByRedId:(NSString *)redId showRedState:(BOOL)showRedState;
- (void)updateSingleRedPacketMessagStateByRedId:(NSString *)redId redPacketState:(NSString *)redPacketState;
/**
 搜索聊天记录 不搜索交友的消息
 */
- (ChatModel *)fetchChatModelByMessageId:(ChatModel *)chatModel;
- (ChatModel *)getChatModelByMessageId:(NSString *)msgId;
- (ChatModel *)getDynamicChatModelByMessageId:(NSString *)msgId;
- (NSArray *)fetchChatModelBySearchText:(NSString *)searchText authorityType:(NSString*)authorityType;
/// 获取所有的未读消息数量 以及消息
- (NSDictionary*)fetchAllUnReadMessageWihtChatModel:(ChatModel *)config;
/// 群邀请审核
/// 点击同意申请之后 把本地的去确认改成已确认
/// @param messageId messageId description
- (void)updateChatModelGroupApplyWithMessageId:(NSString*)messageId;
- (void)updateChatModelGroupApplyWith:(ChatModel*)cmodel;
-(void)updateReactionMessageByMessageId:(NSString *)messageId reaction:(NSString *)reaction action:(NSString *)action reactedPerson:(NSString *)reactedPerson selfReaction:(NSString *)selfReaction;
@end

//NS_ASSUME_NONNULL_END
